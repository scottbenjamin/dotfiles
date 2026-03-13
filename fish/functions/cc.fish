function cc --description "Resume last Claude Code session"
    # Trigger waiting-for-input visual on startup
    bash ~/code/dotfiles/ghostty/hooks/claude-waiting.sh
    claude --continue $argv
    # Reset all colors on exit (including ANSI palette if dimmed)
    bash ~/code/dotfiles/ghostty/hooks/claude-default.sh
end
