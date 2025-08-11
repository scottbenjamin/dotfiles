function tgf --wraps='terragrunt run-all hclfmt' --description 'alias tgf=terragrunt run-all hclfmt'
  terragrunt run-all hclfmt $argv
        
end
