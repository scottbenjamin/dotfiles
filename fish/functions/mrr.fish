function mrr --description "Open ready GitLab MRs in tmux windows with Cursor review agents"
    argparse 'r/reviewer=' 's/session=' 'b/base-dir=' 'R/repo-root=' 'm/model=' 'l/local-checkout' 'g/gitlab-only' 'f/force-restart' 'd/draft' 'n/no-attach' 'c/clone-missing' 'C/no-clone-missing' 'a/attach=' 'p/pick-attach' -- $argv
    or return 2

    if not type -q tmux
        echo "mrr: tmux is required"
        return 1
    end

    if set -q _flag_attach; and set -q _flag_pick_attach
        echo "mrr: use either --attach or --pick-attach"
        return 2
    end

    if set -q _flag_attach; or set -q _flag_pick_attach
        set -l target_session $_flag_attach

        if set -q _flag_pick_attach
            set -l sessions (tmux list-sessions -F '#S' 2>/dev/null)
            if test (count $sessions) -eq 0
                echo "mrr: no tmux sessions to attach"
                return 1
            end

            set -l mr_sessions (string match -r '^mr-review($|-)' -- $sessions)
            if test (count $mr_sessions) -eq 0
                echo "mrr: no mr-review sessions found to attach"
                return 1
            end
            set sessions $mr_sessions

            if type -q fzf
                set target_session (printf '%s\n' $sessions | fzf --prompt="mrr session> " --height=40% --reverse)
            else
                echo "mrr: fzf not found; available sessions:"
                for session_name in $sessions
                    echo "  $session_name"
                end
                read -P "attach to session: " target_session
            end
        end

        if test -z "$target_session"
            return 1
        end

        if not tmux has-session -t "$target_session" 2>/dev/null
            echo "mrr: session not found: $target_session"
            return 1
        end

        if set -q TMUX
            tmux switch-client -t "$target_session"
        else
            tmux attach-session -t "$target_session"
        end
        return 0
    end

    if not type -q glab
        echo "mrr: glab is required"
        return 1
    end
    # Auth check once in launcher; review agents should not repeat it.
    if not glab auth status >/dev/null 2>&1
        echo "mrr: glab auth failed; run 'glab auth login'"
        return 1
    end

    if not type -q jq
        echo "mrr: jq is required"
        return 1
    end

    if not type -q cursor-agent
        echo "mrr: cursor-agent is required"
        return 1
    end

    set -l reviewer $_flag_reviewer
    if test -z "$reviewer"
        set reviewer (glab api "/user" | jq -r '.username')
    end

    if test -z "$reviewer"
        echo "mrr: unable to determine reviewer username"
        return 1
    end

    set -l base_dir $_flag_base_dir
    if test -z "$base_dir"
        set base_dir "$HOME/code/mr-reviews"
    end
    mkdir -p "$base_dir"
    set -l clone_missing true
    if set -q _flag_no_clone_missing
        set clone_missing false
    end
    set -l clone_base_dir "$base_dir"
    set -l clone_dir_prompted false
    set -l local_checkout true
    if set -q _flag_local_checkout
        set local_checkout true
    end
    if set -q _flag_gitlab_only
        set local_checkout false
    end
    if set -q _flag_local_checkout; and set -q _flag_gitlab_only
        echo "mrr: use either --local-checkout or --gitlab-only"
        return 2
    end

    set -l repo_root $_flag_repo_root
    if test -z "$repo_root"
        set repo_root "$HOME/code"
    end

    set -l session $_flag_session
    if test -z "$session"
        set session "mr-review"
    end

    set -l session_exists false
    if tmux has-session -t "$session" 2>/dev/null
        set session_exists true
    end

    set -l endpoint "/merge_requests?scope=all&state=opened&reviewer_username=$reviewer&per_page=100"
    set -l include_drafts false
    if set -q _flag_draft
        set include_drafts true
    end

    set -l mr_rows (
        glab api "$endpoint" --paginate --output ndjson \
            | jq -r --arg reviewer "$reviewer" --argjson include_drafts $include_drafts '
                select(($include_drafts == true) or ((.draft | not) and (.work_in_progress | not)))
                | select((.reviewers // []) | map(.username) | index($reviewer))
                | [ (.project_id | tostring), .references.full, (.iid | tostring), .web_url ] | @tsv
            '
    )

    if test (count $mr_rows) -eq 0
        echo "mrr: no ready MRs found for reviewer @$reviewer"
        return 0
    end
    set -l total_found (count $mr_rows)
    set -l review_mode "local-checkout"
    if test "$local_checkout" = false
        set review_mode "gitlab-only"
    end

    set -l opened 0
    set -l skipped 0
    set -l already_approved 0
    set -l busy_skipped 0

    for row in $mr_rows
        set -l fields (string split \t -- $row)
        set -l project_id $fields[1]
        set -l full_ref $fields[2]
        set -l iid $fields[3]
        set -l web_url $fields[4]
        set -l repo_path (string split -m1 "!" -- $full_ref)[1]
        set -l repo_name (basename "$repo_path")
        if glab api "/projects/$project_id/merge_requests/$iid/approvals" \
            | jq -e --arg reviewer "$reviewer" '(.approved_by // []) | map(.user.username) | index($reviewer) != null' >/dev/null 2>&1
            set already_approved (math $already_approved + 1)
            continue
        end

        set -l repo_dir "$HOME"
        set -l worktree_dir ""
        if test "$local_checkout" = true
            set -l primary_repo_name_path ""
            set -l primary_repo_full_path ""
            set repo_dir ""
            if test -n "$repo_root"
                set primary_repo_name_path "$repo_root/$repo_name"
                set primary_repo_full_path "$repo_root/$repo_path"
                if test -d "$primary_repo_name_path/.git"
                    set repo_dir "$primary_repo_name_path"
                else if test -d "$primary_repo_full_path/.git"
                    set repo_dir "$primary_repo_full_path"
                end
            end

            if test -z "$repo_dir"; and test -d "$clone_base_dir/$repo_path/.git"
                set repo_dir "$clone_base_dir/$repo_path"
            end

            if test -z "$repo_dir"
                if test "$clone_missing" = true
                    if test "$clone_dir_prompted" = false
                        if test -t 0
                            read -P "mrr: clone missing repos into dir [$clone_base_dir]: " clone_choice
                            if test -n "$clone_choice"
                                set clone_base_dir (string trim -- "$clone_choice")
                            end
                        end
                        mkdir -p "$clone_base_dir"
                        set clone_dir_prompted true
                    end
                    set repo_dir "$clone_base_dir/$repo_path"
                    mkdir -p (dirname "$repo_dir")
                    git clone "git@gitlab.com:$repo_path.git" "$repo_dir" >/dev/null
                else
                    set -l searched_paths "$clone_base_dir/$repo_path"
                    if test -n "$repo_root"
                        set searched_paths "$primary_repo_name_path, $primary_repo_full_path, $clone_base_dir/$repo_path"
                    end
                    echo "mrr: skipping $repo_path!$iid (missing repo in: $searched_paths)"
                    set skipped (math $skipped + 1)
                    continue
                end
            end

            set worktree_dir "$clone_base_dir/.mrr-worktrees/$repo_path/mr-$iid"
        end
        set -l launcher "$HOME/code/dotfiles/scripts/mrr-launch-review.sh"
        set -l model ""
        if set -q _flag_model
            set model "$_flag_model"
        end
        set -l cmd_parts (string escape --style=script -- "$launcher" "$repo_dir" "$worktree_dir" "$iid" "$repo_path" "$web_url" "$model" "$local_checkout")
        set -l cmd (string join " " -- $cmd_parts)

        set -l window_name "$repo_name!$iid"
        set -l pane_id ""
        set -l window_exists false
        if test "$session_exists" = true
            if tmux list-windows -t "$session" -F '#W' | string match -q -- "$window_name"
                set window_exists true
            end
        end

        if test "$window_exists" = true
            set pane_id (tmux display-message -p -t "$session:$window_name" '#{pane_id}')
            tmux rename-window -t "$session:$window_name" "$window_name"
            tmux set-window-option -t "$session:$window_name" automatic-rename off >/dev/null
            tmux set-window-option -t "$session:$window_name" remain-on-exit on >/dev/null

            if not set -q _flag_force_restart
                set -l pane_dead (tmux display-message -p -t "$pane_id" '#{pane_dead}')
                set -l pane_cmd (tmux display-message -p -t "$pane_id" '#{pane_current_command}')
                if test "$pane_dead" = "0"
                    switch "$pane_cmd"
                        case fish zsh bash sh
                            # idle shell, safe to reuse
                        case '*'
                            set busy_skipped (math $busy_skipped + 1)
                            continue
                    end
                end
            end
        else if test "$session_exists" = false
            tmux new-session -d -s "$session" -n "$window_name" -c "$repo_dir"
            set pane_id (tmux display-message -p -t "$session:$window_name" '#{pane_id}')
            tmux rename-window -t "$session:$window_name" "$window_name"
            tmux set-window-option -t "$session:$window_name" automatic-rename off >/dev/null
            tmux set-window-option -t "$session:$window_name" remain-on-exit on >/dev/null
            set session_exists true
        else
            set pane_id (tmux new-window -t "$session" -n "$window_name" -c "$repo_dir" -P -F '#{pane_id}')
            tmux rename-window -t "$session:$window_name" "$window_name"
            tmux set-window-option -t "$session:$window_name" automatic-rename off >/dev/null
            tmux set-window-option -t "$session:$window_name" remain-on-exit on >/dev/null
        end

        tmux select-pane -t "$pane_id" -T "$window_name"
        tmux respawn-pane -k -t "$pane_id" "$cmd"
        set opened (math $opened + 1)
    end

    if test $opened -eq 0
        echo "mrr: found $total_found candidate MRs for @$reviewer ($review_mode)"
        if test $already_approved -gt 0
            echo "mrr: skipped $already_approved already approved by @$reviewer"
        end
        if test $busy_skipped -gt 0
            echo "mrr: skipped $busy_skipped windows with active processes (use --force-restart)"
        end
        if test $skipped -gt 0
            echo "mrr: skipped $skipped missing local repos"
        end
        echo "mrr: launched 0 review windows"
        return 0
    end

    echo "mrr: found $total_found candidate MRs for @$reviewer ($review_mode)"
    if test $already_approved -gt 0
        echo "mrr: skipped $already_approved already approved by @$reviewer"
    end
    if test $busy_skipped -gt 0
        echo "mrr: skipped $busy_skipped windows with active processes (use --force-restart)"
    end
    if test $skipped -gt 0
        echo "mrr: skipped $skipped missing local repos"
    end
    echo "mrr: launched $opened review windows in session $session"

    if set -q _flag_no_attach
        return 0
    end

    if set -q TMUX
        tmux switch-client -t "$session"
    else
        tmux attach-session -t "$session"
    end
end
