function gstp --wraps='git stash'
    git stash pop $argv
end
