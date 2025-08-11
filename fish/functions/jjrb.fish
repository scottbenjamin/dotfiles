function jjrb --wraps='jj rebase -d main' --description 'alias jjrb=jj rebase -d main'
  jj rebase -d main $argv
        
end
