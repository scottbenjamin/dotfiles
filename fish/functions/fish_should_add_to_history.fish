function fish_should_add_to_history
    string match -rq '^ ' -- "$argv" && return 1
    string match -riq '(secret|password|token|aws_secret)' -- "$argv" && return 1
    return 0
end
