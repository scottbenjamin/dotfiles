function glog --wraps='git log'
    git log --oneline --graph --decorate $argv
end
