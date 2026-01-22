function _tide_item_shortpwd
    set -l pwd_string (string replace -- $HOME '~' $PWD)
    set -l parts (string split '/' $pwd_string)
    set -l num_parts (count $parts)

    # Keep last 3 components
    if test $num_parts -gt 3
        set parts $parts[-3..-1]
    end

    # Use existing pwd icons
    set -l icon $tide_pwd_icon
    if test "$PWD" = "$HOME"
        set icon $tide_pwd_icon_home
        set parts '~'
    else if not test -w "$PWD"
        set icon $tide_pwd_icon_unwritable
    end

    set -l display (string join '/' $parts)
    _tide_print_item shortpwd "$icon $display"
end
