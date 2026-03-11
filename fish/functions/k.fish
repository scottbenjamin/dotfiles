# function to wrap kubectl
function k --wraps=kubectl
  command kubectl $argv
end
