#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 7 ]]; then
  echo "usage: mrr-launch-review.sh <repo_dir> <worktree_dir> <iid> <repo_path> <web_url> <model> <local_checkout>" >&2
  exit 2
fi

repo_dir="$1"
worktree_dir="$2"
iid="$3"
repo_path="$4"
web_url="$5"
model="${6:-}"
local_checkout="${7:-false}"

if [[ "$local_checkout" == "true" ]]; then
  mr_ref="refs/mrr/$iid"

  mkdir -p "$(dirname "$worktree_dir")"
  git -C "$repo_dir" fetch origin "refs/merge-requests/$iid/head:$mr_ref" --force >/dev/null

  if git -C "$worktree_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$worktree_dir" checkout --detach "$mr_ref" >/dev/null
  elif [[ -e "$worktree_dir" ]]; then
    echo "mrr: path exists but not git worktree: $worktree_dir" >&2
    exit 1
  else
    git -C "$repo_dir" worktree add --detach "$worktree_dir" "$mr_ref" >/dev/null
  fi

  cd "$worktree_dir"
else
  cd "$repo_dir"
fi

prompt="/mr-review-context
Review GitLab MR $repo_path!$iid ($web_url)."
caveman_skill="$HOME/.cursor/skills/caveman/SKILL.md"
if [[ -f "$caveman_skill" ]]; then
  prompt="/caveman
$prompt"
fi

if [[ -n "$model" ]]; then
  exec cursor-agent --model "$model" "$prompt"
else
  exec cursor-agent "$prompt"
fi
