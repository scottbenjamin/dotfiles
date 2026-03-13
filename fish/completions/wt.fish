# Subcommands (only when no subcommand given yet)
complete -c wt -f -n __fish_use_subcommand -a ls -d "List worktrees"
complete -c wt -f -n __fish_use_subcommand -a new -d "Create worktree"
complete -c wt -f -n __fish_use_subcommand -a rm -d "Remove worktree"
complete -c wt -f -n __fish_use_subcommand -a prune -d "Clean up stale worktrees"

# Switch targets (worktree names, excluding current) as first arg
complete -c wt -f -n __fish_use_subcommand -a '(begin
    set -l cwd (pwd)
    for line in (git worktree list --porcelain 2>/dev/null | grep "^worktree ")
        set -l wt (string replace "worktree " "" -- $line)
        if test "$cwd" != "$wt"; and not string match -q "$wt/*" "$cwd"
            basename $wt
        end
    end
end)'

# wt new: branches that don't already have a worktree
complete -c wt -f -n "__fish_seen_subcommand_from new" -a '(begin
    set -l wt_branches (git worktree list --porcelain 2>/dev/null | string match -r "(?<=^branch refs/heads/).+")
    for b in (git branch --format="%(refname:short)" 2>/dev/null)
        contains -- $b $wt_branches; or echo $b
    end
end)'

# wt rm: worktree names excluding main repo
complete -c wt -f -n "__fish_seen_subcommand_from rm" -a '(begin
    set -l main_wt (git worktree list --porcelain 2>/dev/null | head -1 | string replace "worktree " "")
    for line in (git worktree list --porcelain 2>/dev/null | grep "^worktree ")
        set -l wt (string replace "worktree " "" -- $line)
        if test "$wt" != "$main_wt"
            basename $wt
        end
    end
end)'
