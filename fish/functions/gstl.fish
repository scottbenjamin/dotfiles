function gstl --wraps='git stash'
    git stash list $argv
end
