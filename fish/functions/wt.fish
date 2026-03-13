function wt --description "Git worktree manager"
    set -l cmd $argv[1]

    # No args → fzf switch
    if test -z "$cmd"
        set -l selected (git worktree list | fzf --height=~40% --reverse --ansi --prompt="worktree> " --bind=ctrl-n:down,ctrl-p:up)
        or return 0
        cd (string split -f1 " " -- $selected)
        __wt_print_location
        return
    end

    switch $cmd
        case ls
            # colored list with current marker
            set -l cwd (realpath (pwd))
            for line in (git worktree list)
                set -l wt_dir (realpath (string split -f1 " " -- $line) 2>/dev/null; or string split -f1 " " -- $line)
                if test "$cwd" = "$wt_dir"; or string match -q "$wt_dir/*" "$cwd"
                    echo (set_color --bold green)"▸ $line"(set_color normal)
                else
                    echo (set_color brblack)"  $line"(set_color normal)
                end
            end

        case new
            set -l branch $argv[2]
            if test -z "$branch"
                echo "Usage: wt new <branch-name>"
                return 1
            end
            set -l repo_root (git rev-parse --show-toplevel)
            set -l repo_name (basename $repo_root)
            set -l wt_dir (dirname $repo_root)/$repo_name-wt/$branch

            if git show-ref --verify --quiet refs/heads/$branch
                git worktree add $wt_dir $branch
            else
                git worktree add $wt_dir -b $branch
            end
            and cd $wt_dir
            or begin
                echo (set_color red)"Failed to create worktree"(set_color normal)
                return 1
            end

        case rm
            set -l branch $argv[2]
            if test -z "$branch"
                echo "Usage: wt rm <branch-name>"
                return 1
            end
            set -l main_wt (git worktree list --porcelain | head -1 | string replace "worktree " "")
            set -l repo_name (basename $main_wt)
            set -l wt_dir (dirname $main_wt)/$repo_name-wt/$branch

            # If we're inside the worktree being removed, cd to main first
            set -l cwd (realpath (pwd))
            set -l real_wt_dir (realpath $wt_dir 2>/dev/null; or echo $wt_dir)
            if test "$cwd" = "$real_wt_dir"; or string match -q "$real_wt_dir/*" "$cwd"
                cd $main_wt
            end

            read -l -P "Remove worktree "(set_color --bold yellow)"$wt_dir"(set_color normal)"? [y/N] " confirm
            if test "$confirm" = y -o "$confirm" = Y
                git worktree remove $wt_dir
                and git branch -d $branch 2>/dev/null
                and echo (set_color green)"Removed $wt_dir and branch $branch"(set_color normal)
                or echo (set_color green)"Removed $wt_dir"(set_color normal)
            else
                echo (set_color brblack)"Cancelled"(set_color normal)
            end

        case prune
            git worktree prune -v

        case '*'
            # Treat as switch target — match against path and branch name
            set -l matches
            set -l current_path
            for line in (git worktree list --porcelain)
                if string match -q "worktree *" -- $line
                    set current_path (string replace "worktree " "" -- $line)
                else if string match -q "branch *" -- $line
                    set -l branch (string replace -r "branch refs/heads/" "" -- $line)
                    if string match -qi "*$cmd*" -- $current_path $branch
                        set -a matches $current_path
                    end
                end
            end
            if test (count $matches) -eq 0
                echo (set_color red)"No worktree matching '$cmd'"(set_color normal)
                return 1
            else if test (count $matches) -gt 1
                # Multiple matches — let user pick via fzf
                set -l selected (printf '%s\n' $matches | fzf --height=~40% --reverse --prompt="multiple matches> " --bind=ctrl-n:down,ctrl-p:up)
                or return 0
                cd $selected
            else
                cd $matches[1]
            end
            __wt_print_location
    end
end

function __wt_print_location --description "Print current worktree branch"
    set -l branch (git branch --show-current 2>/dev/null)
    if test -n "$branch"
        echo (set_color --bold cyan)"▸ $branch"(set_color normal)
    end
end
