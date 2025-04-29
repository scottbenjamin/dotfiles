function ll --wraps='eza -l --color=always --group-directories-first --icons' --wraps='ls -al' --description 'alias ll=ls -al'
  ls -al $argv
        
end
