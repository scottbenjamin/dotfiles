#!/usr/bin/env bash
# GitLab MR Review — a single self-contained herdr plugin command.
#
# Dispatches on the first arg; the manifest maps each action/pane/link-handler
# to one of these subcommands:
#   list                            open the fzf picker (overlay pane)
#   picker                          (runs inside that pane) pick an MR -> review/diff
#   review [proj iid src tgt title url]   worktree + diff pane + claude pane
#   diff   <proj> <iid> [title]     open MR diff in a pager pane
set -euo pipefail

HERDR="${HERDR_BIN_PATH:-herdr}"
SELF="${HERDR_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/gitlab-review.sh"

CONFIG_DIR="${HERDR_PLUGIN_CONFIG_DIR:-$HOME/.config/herdr/gitlab-review}"
STATE_DIR="${HERDR_PLUGIN_STATE_DIR:-$HOME/.local/state/herdr/gitlab-review}"
mkdir -p "$STATE_DIR"

# Load user config (.env) if present.
if [[ -f "$CONFIG_DIR/.env" ]]; then
  # shellcheck disable=SC1090,SC1091
  set -a; source "$CONFIG_DIR/.env"; set +a
fi

# Config + defaults (override in $CONFIG_DIR/.env — see .env.example).
GL_HOST="${HERDR_GL_HOST:-gitlab.com}"
GL_USER="${HERDR_GL_USER:-}"
GL_REPOS_DIR="${HERDR_GL_REPOS_DIR:-$HOME/code}"
GL_CACHE_DIR="${HERDR_GL_CACHE_DIR:-$STATE_DIR/repos}"
GL_PER_PAGE="${HERDR_GL_PER_PAGE:-50}"
GL_CACHE_TTL="${HERDR_GL_CACHE_TTL:-60}"   # reuse the picker result for this many seconds
GL_DIFF_VIEWER="${HERDR_GL_DIFF_VIEWER:-delta}"   # delta | less | lazygit

# Which coding agent reviews the MR. Presets: claude | pi | cursor.
# Any other value is treated as a binary on PATH that takes a trailing prompt
# and an optional --model flag (e.g. codex, gemini, aider).
GL_REVIEW_AGENT="${HERDR_GL_REVIEW_AGENT:-claude}"
# Model passed via --model. Unset -> per-agent default below; set empty ("") to
# force the agent's own default. (Use ${VAR-x} so an explicit "" is respected.)
GL_REVIEW_MODEL="${HERDR_GL_REVIEW_MODEL-__auto__}"
if [[ "$GL_REVIEW_MODEL" == "__auto__" ]]; then
  case "$GL_REVIEW_AGENT" in
    claude) GL_REVIEW_MODEL="sonnet" ;;
    cursor) GL_REVIEW_MODEL="composer-2.5" ;;
    *)      GL_REVIEW_MODEL="" ;;      # pi/others: use their own default
  esac
fi

# ---------------------------------------------------------------- helpers ---

gl_user() {
  if [[ -n "$GL_USER" ]]; then printf '%s\n' "$GL_USER"; return; fi
  local cache="$STATE_DIR/username" u
  if [[ -s "$cache" ]]; then cat "$cache"; return; fi
  u=$(glab api --hostname "$GL_HOST" /user 2>/dev/null | jq -r '.username // empty')
  [[ -n "$u" ]] || { echo "gitlab-review: cannot resolve GitLab username (glab auth?)" >&2; return 1; }
  printf '%s\n' "$u" | tee "$cache"
}

notify() {
  local title="$1" body="${2:-}" sound="${3:-request}"
  "$HERDR" notification show "$title" --body "$body" --sound "$sound" >/dev/null 2>&1 || true
}

_mtime() { stat -f %m "$1" 2>/dev/null || stat -c %Y "$1" 2>/dev/null || echo 0; }

# jq program: raw GitLab MR list -> our compact objects (drops my own MRs).
# Carries everything the list endpoint already returns so the preview can be
# rendered with zero extra network calls (description, labels, upvotes/downvotes,
# state, reviewers as plain usernames).
GL_MAP='[ .[]
  | select(.author.username != $me)
  | { iid, title,
      project: (.web_url | capture("^https?://[^/]+/(?<p>.+)/-/merge_requests/").p),
      project_id: .project_id,
      web_url, source_branch, target_branch,
      author: .author.username,
      draft: (.draft // .work_in_progress // false),
      state, description,
      labels: (.labels // []),
      upvotes: (.upvotes // 0),
      downvotes: (.downvotes // 0),
      reviewers: [.reviewers[]?.username],
      updated_at, created_at } ]'

_gl_list() {
  local user; user=$(gl_user) || return 1
  glab api --hostname "$GL_HOST" \
    "/merge_requests?scope=all&state=opened&reviewer_username=$user&per_page=$GL_PER_PAGE" 2>/dev/null
}

# Fast first paint: reviewer MRs from ONE list call, approvals not yet resolved
# (marked pending_approvals so the row shows a ⋯ placeholder).
gl_base_json() {
  local user; user=$(gl_user) || return 1
  _gl_list | jq --arg me "$user" "$GL_MAP | map(. + {pending_approvals: true})"
}

# Read a JSON array of MR objects on stdin, render + write each one's preview
# cache file. Purely local (jq only, no network) so it's cheap to run eagerly.
write_previews() {
  local preview_dir="$STATE_DIR/preview"
  mkdir -p "$preview_dir"
  local mr pid iid
  while IFS= read -r mr; do
    (
      pid=$(jq -r '.project_id' <<<"$mr")
      iid=$(jq -r '.iid' <<<"$mr")
      render_preview "$mr" > "$preview_dir/$pid-$iid.ansi" 2>/dev/null || true
    ) &
  done < <(jq -c '.[]')
  wait
}

# Full result: adds approval counts and drops MRs I've already approved.
# Approval calls run in parallel so the wait is ~one round-trip, not N. Also
# prefetches + caches the rendered preview block for each kept MR so the fzf
# preview pane is instant instead of making 2 live `glab api` calls per row.
gl_pending_json() {
  local user; user=$(gl_user) || return 1
  local base
  base=$(_gl_list | jq --arg me "$user" "$GL_MAP")
  [[ "$(jq 'length' <<<"$base" 2>/dev/null || echo 0)" -gt 0 ]] || { echo "[]"; return; }
  local preview_dir="$STATE_DIR/preview"
  mkdir -p "$preview_dir"
  local d i=0 mr
  d=$(mktemp -d)
  while IFS= read -r mr; do
    (
      pid=$(jq -r '.project_id' <<<"$mr")
      iid=$(jq -r '.iid' <<<"$mr")
      ap=$(glab api --hostname "$GL_HOST" "/projects/$pid/merge_requests/$iid/approvals" 2>/dev/null || echo '{}')
      # Skip MRs I've already approved; otherwise emit the MR with approval counts.
      if jq -e --arg me "$user" '([.approved_by[]?.user.username] | index($me)) != null' <<<"$ap" >/dev/null 2>&1; then
        :
      else
        full=$(glab api --hostname "$GL_HOST" "/projects/$pid/merge_requests/$iid" 2>/dev/null || true)
        local enriched
        enriched=$(jq -c --argjson ap "$ap" --argjson full "${full:-null}" \
          '. + {approvals_given: ((($ap.approved_by) // []) | length),
                approvals_required: (($ap.approvals_required) // 0),
                approved_by_usernames: (($ap.approved_by) // [] | map(.user.username)),
                ci: (($full.head_pipeline.status) // ($full.pipeline.status) // null),
                changes_count: (($full.changes_count) // null)}' <<<"$mr")
        printf '%s\n' "$enriched" > "$d/$i.json"
        render_preview "$enriched" > "$preview_dir/$pid-$iid.ansi" 2>/dev/null || true
      fi
    ) &
    ((i++)) || true
  done < <(jq -c '.[]' <<<"$base")
  wait
  cat "$d"/*.json 2>/dev/null | jq -s '.'
  rm -rf "$d"
}

# Serve a cached result when fresh, so reopening the picker soon is instant.
gl_pending_cached() {
  local max_age="${1:-$GL_CACHE_TTL}" cache="$STATE_DIR/pending.json"
  if [[ -s "$cache" ]]; then
    local age=$(( $(date +%s) - $(_mtime "$cache") ))
    if (( age >= 0 && age < max_age )); then cat "$cache"; return; fi
  fi
  local fresh; fresh=$(gl_pending_json)
  printf '%s' "$fresh" > "$cache"
  printf '%s\n' "$fresh"
}

# Shell command run in pane 1 to view an MR's changed files (target...HEAD).
diff_pane_cmd() {
  local wt="$1" iid="$2" target="$3"
  # `glab mr diff` is GitLab's authoritative MR diff (exact changed-file set,
  # no dependence on a fresh local target branch).
  case "$GL_DIFF_VIEWER" in
    delta)   printf 'glab mr diff %q | delta --side-by-side --navigate --paging=always' "$iid" ;;
    less)    printf 'glab mr diff %q | less -R' "$iid" ;;
    # lazygit shows the full branch history, not just the MR's changed files.
    # Kept as an escape hatch; press `w` in lazygit to diff against the target.
    lazygit) printf 'lazygit -p %q' "$wt" ;;
    *)       printf 'glab mr diff %q | delta --side-by-side --navigate --paging=always' "$iid" ;;
  esac
}

# JSON array (stdin) -> fzf rows. One pre-padded DISPLAY column (fixed-width
# fields, title last so nothing trails it) + hidden raw data fields. Tab fields:
#   1 display  2 iid  3 project  4 project_id  5 web_url  6 src  7 target  8 title
# A pending_approvals MR shows a ⋯ placeholder for the approval icon.
emit_rows() {
  jq -r '
    def rpad($n): tostring | if length >= $n then .[:$n] else . + (" " * ($n - length)) end;
    def fit($n): tostring | if length <= $n then . + (" " * ($n - length)) else "…" + .[(length - $n + 1):] end;
    .[]
    | ((if .draft then "📝" else "✅" end)
       + " " + (if .pending_approvals then "⋯"
                elif (.approvals_required // 0) > 0 and (.approvals_given // 0) >= (.approvals_required // 0) then "🟩"
                elif (.approvals_given // 0) > 0 then "🟨" else "⬜" end)
       + "  " + ((.project + "!" + (.iid|tostring)) | fit(40))
       + " " + (("@" + .author) | rpad(15))
       + " " + (((((now - ((.updated_at // "" | sub("\\.[0-9]+";"") | fromdateiso8601?) // now)) / 86400) | floor | tostring) + "d") | rpad(4))
       + "  " + .title) as $display
    | [$display, (.iid|tostring), .project, (.project_id|tostring), .web_url, .source_branch, .target_branch, .title]
    | @tsv'
}

# ------------------------------------------------------------ subcommands ---

cmd_list() { exec "$HERDR" plugin pane open --plugin absci.gitlab-review --entrypoint picker; }

cmd_rows_base() {
  local base; base=$(gl_base_json)
  emit_rows <<<"$base"
  # Write instant preview files (description + meta, no network) without
  # delaying first paint of the rows themselves.
  ( write_previews <<<"$base" ) >/dev/null 2>&1 &
}
cmd_rows_full() { gl_pending_cached | emit_rows; } # +approvals, drops approved-by-me

cmd_picker() {
  # First paint from the fast base list; fzf `reload`s with the enriched list
  # (approvals resolved, approved-by-me dropped) as soon as those calls finish.
  local base_rows
  base_rows=$(cmd_rows_base) || { echo "Failed to query GitLab (check glab auth / config)."; read -r; exit 1; }
  if [[ -z "$base_rows" ]]; then
    echo "No MRs awaiting your review. 🎉"; echo "(press enter to close)"; read -r || true; exit 0
  fi

  local pick key_pressed row
  pick=$(fzf --with-nth=1 --delimiter='\t' \
          --prompt="MR to review > " \
          --header="MRs awaiting review  ·  ✅ready/📝draft  ·  🟩/🟨/⬜ approvals (⋯ loading)  ·  enter: worktree+agent  ·  ctrl-d: diff  ·  ctrl-r: refresh  ·  type URL/proj!iid + ctrl-o: review that  ·  esc: cancel" \
          --preview-window=down,65%,wrap \
          --expect=ctrl-d \
          --bind="start:reload(bash $SELF rows-full)" \
          --bind="ctrl-r:reload(rm -f $STATE_DIR/pending.json; rm -rf $STATE_DIR/preview; bash $SELF rows-full)" \
          --bind="ctrl-o:become(bash $SELF review-query {q})" \
          --preview="bash $SELF preview {4} {2}" <<<"$base_rows") || exit 0

  key_pressed=$(head -1 <<<"$pick")
  row=$(sed -n '2p' <<<"$pick")
  [[ -n "$row" ]] || exit 0
  IFS=$'\t' read -r _display iid project _pid web_url src target title <<<"$row"

  if [[ "$key_pressed" == "ctrl-d" ]]; then
    exec bash "$SELF" diff "$project" "$iid" "$title"
  fi
  exec bash "$SELF" review "$project" "$iid" "$src" "$target" "$title" "$web_url"
}

# Render the rich detail block for a single MR object (our compact GL_MAP
# shape, optionally enriched with approvals_given/approvals_required/
# approved_by_usernames/ci/changes_count by gl_pending_json). Shared by the
# eager base-list prefetch and the enriched prefetch so cached and
# freshly-rendered output are byte-identical, and rendering is pure jq — no
# network — so it is safe to run in the fzf preview hot path.
render_preview() {
  local obj="$1"
  jq -rn --argjson m "$obj" '
    def days($t): ($t // "" | sub("\\.[0-9]+";"") | (fromdateiso8601? // null)) as $e
                  | if $e == null then "?" else (((now - $e)/86400)|floor|tostring)+"d" end;
    ($m.approved_by_usernames // null) as $approved |
    ($m.reviewers // []) as $revs |
    ($m.ci // null) as $ci |
    (if $ci == null then "⚪" elif $ci == "success" then "🟢"
     elif ($ci|test("failed|canceled")) then "🔴"
     elif ($ci|test("running|pending|created|waiting")) then "🟡"
     else "🟡" end) as $ci_icon |
    ($m.approvals_required // null) as $req |
    (if $approved == null then "⋯"
     elif $req > 0 and ($approved|length) >= $req then "✅"
     elif ($approved|length) > 0 then "🟡" else "⬜" end) as $ap_icon |
    "[1m" + $m.title + "[0m",
    "[2m" + ($m.project + "!" + ($m.iid|tostring))
      + " · " + ($m.state // "opened") + (if $m.draft then " · DRAFT" else "" end) + "[0m",
    "",
    "author     @" + ($m.author // "?"),
    "branch     " + ($m.source_branch // "?") + "  →  " + ($m.target_branch // "?"),
    "updated    " + days($m.updated_at) + " ago   (created " + days($m.created_at) + " ago)",
    "CI         " + $ci_icon + " " + ($ci // "—")
      + "     👍 " + (($m.upvotes // 0)|tostring) + "   👎 " + (($m.downvotes // 0)|tostring),
    (if $approved == null then "approvals  ⋯ loading…"
     else "approvals  " + $ap_icon + " " + (($approved|length)|tostring) + "/" + ($req|tostring)
       + (if ($approved|length) > 0 then "   ✓ " + ($approved|join(", ")) else "" end) end),
    "reviewers  " + (if ($revs|length) > 0
        then ($revs | map(if $approved != null and (. as $r | $approved | index($r)) then . + " ✓" else . end) | join(", "))
        else "—" end),
    (if (($m.labels // [])|length) > 0 then "labels     " + ($m.labels|join(", ")) else empty end),
    (if ($m.changes_count // null) != null then "changes    " + ($m.changes_count|tostring) + " files" else empty end),
    "",
    "─────────────────────────────────────────",
    ($m.description // "" | if . == "" then "(no description)" else . end)
  '
}

# fzf preview entrypoint. Args: <project_id> <iid>
# Always serves the prefetched cache file (written by rows-base/rows-full) —
# no `glab api` calls here, since a network round-trip in the preview hot
# path is what causes the fzf selection-move lag. Descriptions rarely change
# mid-session, so the freshness window is generous. If the cache file is
# genuinely absent (prefetch hasn't caught up yet), show a placeholder and
# rely on the background prefetch to fill it in for the next redraw.
GL_PREVIEW_MAX_AGE="${HERDR_GL_PREVIEW_MAX_AGE:-600}"
cmd_preview() {
  local pid="${1:-}" iid="${2:-}"
  [[ -n "$pid" && -n "$iid" ]] || { echo "(no MR selected)"; return; }
  local cache="$STATE_DIR/preview/$pid-$iid.ansi"
  if [[ -s "$cache" ]]; then
    local age=$(( $(date +%s) - $(_mtime "$cache") ))
    if (( age >= 0 && age < GL_PREVIEW_MAX_AGE )); then cat "$cache"; return; fi
    cat "$cache"; return   # stale is still better than a network stall
  fi
  echo "(loading…)"
}

cmd_review() {
  local PROJECT="${1:-}" IID="${2:-}" SRC="${3:-}" TARGET="${4:-}" TITLE="${5:-}" WEB_URL="${6:-}"

  # From a clicked MR URL (link handler): no args.
  if [[ -z "$PROJECT" || -z "$IID" ]]; then
    local url="${HERDR_PLUGIN_CLICKED_URL:-}"
    if [[ -z "$url" && -n "${HERDR_PLUGIN_CONTEXT_JSON:-}" ]]; then
      url=$(jq -r '.clicked_url // empty' <<<"$HERDR_PLUGIN_CONTEXT_JSON" 2>/dev/null || true)
    fi
    [[ -n "$url" ]] || { notify "GitLab review" "No MR selected." none; echo "no MR given" >&2; exit 1; }
    PROJECT=$(sed -E 's#^https?://[^/]+/(.+)/-/merge_requests/[0-9]+.*#\1#' <<<"$url")
    IID=$(sed -E 's#.*/-/merge_requests/([0-9]+).*#\1#' <<<"$url")
    WEB_URL="$url"
  fi

  local enc_project mr
  enc_project=$(jq -rn --arg p "$PROJECT" '$p|@uri')
  mr=$(glab api --hostname "$GL_HOST" "/projects/$enc_project/merge_requests/$IID" 2>/dev/null || true)
  if [[ -n "$mr" ]]; then
    [[ -n "$SRC"     ]] || SRC=$(jq -r '.source_branch' <<<"$mr")
    [[ -n "$TARGET"  ]] || TARGET=$(jq -r '.target_branch' <<<"$mr")
    [[ -n "$TITLE"   ]] || TITLE=$(jq -r '.title' <<<"$mr")
    [[ -n "$WEB_URL" ]] || WEB_URL=$(jq -r '.web_url' <<<"$mr")
  fi
  : "${TARGET:=main}"; : "${TITLE:=MR !$IID}"

  # Guard: only OPEN + READY MRs I haven't already approved.
  local me state pid approved
  me=$(gl_user) || exit 1
  [[ -n "$mr" ]] || { notify "Cannot verify MR !$IID" "GitLab API error" request; echo "no MR metadata" >&2; exit 1; }
  state=$(jq -r '.state' <<<"$mr")
  pid=$(jq -r '.project_id' <<<"$mr")
  approved=$(glab api --hostname "$GL_HOST" "/projects/$pid/merge_requests/$IID/approvals" 2>/dev/null \
    | jq -r --arg me "$me" 'if ([.approved_by[]?.user.username] | index($me)) then "yes" else "no" end')
  [[ "$state" == "opened" ]]   || { notify "Skipping MR !$IID" "not open (state=$state)" none; exit 0; }
  [[ "$approved" != "yes" ]]   || { notify "Skipping MR !$IID" "you already approved it" none; exit 0; }

  notify "Preparing MR !$IID" "$TITLE" done

  # Resolve a local clone (search $GL_REPOS_DIR, else clone into cache).
  local repo_name="${PROJECT##*/}" REPO="" d
  if [[ -d "$GL_REPOS_DIR" ]]; then
    while IFS= read -r d; do
      if git -C "$d" remote -v 2>/dev/null | grep -qiE "$GL_HOST[:/].*${PROJECT}(\.git)?"; then REPO="$d"; break; fi
    done < <(find "$GL_REPOS_DIR" -maxdepth 4 -type d -name "$repo_name" 2>/dev/null)
  fi
  if [[ -z "$REPO" ]]; then
    REPO="$GL_CACHE_DIR/$PROJECT"
    if [[ ! -d "$REPO/.git" ]]; then
      notify "Cloning $repo_name" "for MR !$IID review" done
      mkdir -p "$(dirname "$REPO")"
      glab repo clone "$PROJECT" "$REPO" -- --filter=blob:none >/dev/null 2>&1 \
        || git clone "git@$GL_HOST:$PROJECT.git" "$REPO" >/dev/null 2>&1 \
        || { notify "Clone failed" "$PROJECT" request; echo "clone failed: $PROJECT" >&2; exit 1; }
    fi
  fi

  # Fetch the MR head into a local branch.
  local branch="mr-$IID"
  git -C "$REPO" fetch -q origin "merge-requests/$IID/head:$branch" 2>/dev/null \
    || git -C "$REPO" fetch -q origin "$SRC:$branch" 2>/dev/null \
    || { notify "Fetch failed" "MR !$IID" request; echo "fetch failed" >&2; exit 1; }

  # Create a herdr worktree workspace on that branch (grouped under the parent
  # repo, labelled so it reads as a review in the sidebar).
  local label ws_json WS WT_PATH ROOT_PANE
  label="Review: ${PROJECT##*/}!$IID"
  ws_json=$("$HERDR" worktree create --cwd "$REPO" --branch "$branch" --label "$label" --focus --json 2>/dev/null || true)
  WS=$(jq -r '.result.workspace.workspace_id // .result.workspace_id // empty' <<<"$ws_json" 2>/dev/null || true)
  WT_PATH=$(jq -r '.result.worktree.path // .result.workspace.worktree.checkout_path // empty' <<<"$ws_json" 2>/dev/null || true)
  ROOT_PANE=$(jq -r '.result.root_pane.pane_id // empty' <<<"$ws_json" 2>/dev/null || true)
  : "${WT_PATH:=$REPO}"
  [[ -n "$WS" ]] || { notify "Worktree failed" "MR !$IID (branch already open?)" request; echo "worktree create failed: $ws_json" >&2; exit 1; }

  # Pane 1 (root): the MR diff; close the pane when the viewer quits.
  if [[ -n "$ROOT_PANE" ]]; then
    local dcmd; dcmd=$(diff_pane_cmd "$WT_PATH" "$IID" "$TARGET")
    "$HERDR" pane run "$ROOT_PANE" "$dcmd; $HERDR pane close $ROOT_PANE" >/dev/null 2>&1 || true
  fi

  # Pane 2: claude, split right, reviewing the code.
  local prompt="You are reviewing GitLab merge request !$IID: \"$TITLE\" ($WEB_URL).
This worktree has the MR branch ($branch) checked out; target branch is $TARGET. The pane to your left shows the diff.
Run 'glab mr diff $IID' (or 'git diff $TARGET...HEAD') to inspect the changes, then give a focused code review: correctness bugs, security issues, and anything that should block merge. Cite file:line. Do not modify files unless asked."
  # Resolve the agent binary + herdr identity label from the configured agent.
  local agent_bin agent_name
  case "$GL_REVIEW_AGENT" in
    cursor) agent_bin="cursor-agent"; agent_name="cursor" ;;
    *)      agent_bin="$GL_REVIEW_AGENT"; agent_name="$GL_REVIEW_AGENT" ;;
  esac
  if ! command -v "$agent_bin" >/dev/null 2>&1; then
    notify "Review agent not found" "$agent_bin not on PATH (HERDR_GL_REVIEW_AGENT)" request
    echo "agent binary not found: $agent_bin" >&2; exit 1
  fi
  local model_args=(); [[ -n "$GL_REVIEW_MODEL" ]] && model_args=(--model "$GL_REVIEW_MODEL")
  # claude/pi/cursor all take: <bin> [--model M] "<prompt>"
  "$HERDR" agent start "$agent_name" --workspace "$WS" --cwd "$WT_PATH" --split right --focus -- "$agent_bin" "${model_args[@]}" "$prompt" >/dev/null 2>&1 \
    || "$HERDR" agent start "$agent_name" --workspace "$WS" --cwd "$WT_PATH" --split right --focus -- "$agent_bin" "${model_args[@]}" >/dev/null 2>&1

  # Layout: diff pane (left) 67%, review agent (right) 33%. agent start splits
  # at 0.5; grow the diff pane by 0.17 so the divider lands at 0.67.
  if [[ -n "$ROOT_PANE" ]]; then
    "$HERDR" pane resize --pane "$ROOT_PANE" --direction right --amount 0.17 >/dev/null 2>&1 || true
  fi

  notify "Reviewing MR !$IID" "$TITLE — diff + claude" done
}

cmd_review_query() {
  local q="${1:-}"
  q="$(sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' <<<"$q")"
  [[ -n "$q" ]] || exit 0

  if [[ "$q" =~ ^https?://[^\ ]+/-/merge_requests/[0-9]+ ]]; then
    local project iid
    project=$(sed -E 's#^https?://[^/]+/(.+)/-/merge_requests/[0-9]+.*#\1#' <<<"$q")
    iid=$(sed -E 's#.*/-/merge_requests/([0-9]+).*#\1#' <<<"$q")
    exec bash "$SELF" review "$project" "$iid" "" "" "" "$q"
  elif [[ "$q" =~ ^[^\ ]+![0-9]+$ ]]; then
    local project="${q%!*}" iid="${q##*!}"
    exec bash "$SELF" review "$project" "$iid"
  else
    notify "Can't parse MR" "$q" request
    exit 1
  fi
}

cmd_diff() {
  local PROJECT="${1:-}" IID="${2:-}" enc_project
  [[ -n "$PROJECT" && -n "$IID" ]] || { echo "usage: gitlab-review.sh diff <project> <iid>" >&2; exit 1; }
  enc_project=$(jq -rn --arg p "$PROJECT" '$p|@uri')
  glab api --hostname "$GL_HOST" "/projects/$enc_project/merge_requests/$IID/diffs?per_page=100" 2>/dev/null \
    | jq -r '.[] | "\n=== " + (.new_path // .old_path) + " ===\n" + .diff' \
    | ${PAGER:-less -R}
}

# --------------------------------------------------------------- dispatch ---

cmd="${1:-}"; shift || true
case "$cmd" in
  list)      cmd_list "$@" ;;
  picker)    cmd_picker "$@" ;;
  rows-base) cmd_rows_base "$@" ;;
  rows-full) cmd_rows_full "$@" ;;
  preview)   cmd_preview "$@" ;;
  review)    cmd_review "$@" ;;
  review-query) cmd_review_query "$@" ;;
  diff)      cmd_diff "$@" ;;
  *) echo "usage: gitlab-review.sh {list|picker|rows-base|rows-full|preview|review|review-query|diff}" >&2; exit 2 ;;
esac
