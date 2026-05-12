# fnm init (safe/smart)
if type -q fnm
    # Load fnm environment and auto-switch on directory change
    fnm env --shell fish --use-on-cd | source
end
