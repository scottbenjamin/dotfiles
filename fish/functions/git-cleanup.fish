function git-cleanup --description "Remove local branches deleted from remote and their worktrees"
    git fetch --prune origin 2>&1 | grep -v '^$'

    set -l branches (git branch -v | grep '\[gone\]' | sed 's/^[+* ]//' | awk '{print $1}')

    if test (count $branches) -eq 0
        echo "✓ No stale branches to clean up."
        return 0
    end

    echo ""
    echo "Found "(count $branches)" stale branch(es):"
    echo ""

    for branch in $branches
        set -l worktree (git worktree list | grep "\[$branch\]" | awk '{print $1}')
        if test -n "$worktree"; and test "$worktree" != (git rev-parse --show-toplevel)
            git worktree remove --force "$worktree"
            echo "  ✕ worktree  $worktree"
        end
        git branch -D "$branch" >/dev/null 2>&1
        echo "  ✕ branch    $branch"
    end

    echo ""
    echo "✓ Cleaned up "(count $branches)" branch(es)."
end
