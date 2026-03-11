function clipp -d "Paste from clipboard"
    if type -q pbpaste
        pbpaste
    else if type -q wl-paste
        wl-paste
    else if type -q xclip
        xclip -selection clipboard -o
    end
end
