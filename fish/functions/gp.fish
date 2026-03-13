function gp --wraps='git pull' --description 'alias gp=git pull'
    git pull $argv
end

function gP --wraps='git push origin' --description 'alias gP=git push origin'
    git push origin $argv
end
