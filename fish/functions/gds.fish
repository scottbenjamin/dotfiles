function gds --wraps='git diff'
    git diff --staged $argv
end
