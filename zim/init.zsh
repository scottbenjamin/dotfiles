zimfw() { source /Users/scottbenjamin/.config/zim/zimfw.zsh "${@}" }
zmodule() { source /Users/scottbenjamin/.config/zim/zimfw.zsh "${@}" }
fpath=(/Users/scottbenjamin/.config/zim/modules/git/functions /Users/scottbenjamin/.config/zim/modules/utility/functions /Users/scottbenjamin/.config/zim/modules/zsh-completions/src /Users/scottbenjamin/.config/zim/modules/k/functions /Users/scottbenjamin/.config/zim/modules/pvenv/functions /Users/scottbenjamin/.config/zim/modules/zim-k9s/functions ${fpath})
autoload -Uz -- git-alias-lookup git-branch-current git-branch-delete-interactive git-branch-remote-tracking git-dir git-ignore-add git-root git-stash-clear-interactive git-stash-recover git-submodule-move git-submodule-remove mkcd mkpw k pvenv
source /Users/${USER}/.config/zim/modules/powerlevel10k/powerlevel10k.zsh-theme
source /Users/${USER}/.config/zim/modules/environment/init.zsh
source /Users/${USER}/.config/zim/modules/git/init.zsh
source /Users/${USER}/.config/zim/modules/input/init.zsh
source /Users/${USER}/.config/zim/modules/termtitle/init.zsh
source /Users/${USER}/.config/zim/modules/utility/init.zsh
source /Users/${USER}/.config/zim/modules/ssh/init.zsh
source /Users/${USER}/.config/zim/modules/homebrew/init.zsh
source /Users/${USER}/.config/zim/modules/zim-zoxide/init.zsh
source /Users/${USER}/.config/zim/modules/exa/init.zsh
source /Users/${USER}/.config/zim/modules/fzf/init.zsh
source /Users/${USER}/.config/zim/modules/k/init.zsh
source /Users/${USER}/.config/zim/modules/zim-k9s/init.zsh
source /Users/${USER}/.config/zim/modules/completion/init.zsh
source /Users/${USER}/.config/zim/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /Users/${USER}/.config/zim/modules/zsh-history-substring-search/zsh-history-substring-search.zsh
source /Users/${USER}/.config/zim/modules/zsh-autosuggestions/zsh-autosuggestions.zsh
