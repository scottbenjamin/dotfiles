function gr --wraps='git rev-parse --show-toplevel' --description 'alias gr git rev-parse --show-toplevel'
    git rev-parse --show-toplevel $argv
end
