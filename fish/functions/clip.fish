function clip -d "Copy stdin to clipboard"
    if type -q pbcopy
        pbcopy
    else if type -q wl-copy
        wl-copy
    else if type -q xclip
        xclip -selection clipboard
    end
end
