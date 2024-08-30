zimfw() { source /home/scott/.config/zim/zimfw.zsh "${@}" }
zmodule() { source /home/scott/.config/zim/zimfw.zsh "${@}" }
fpath=(/home/scott/.config/zim/modules/git/functions /home/scott/.config/zim/modules/utility/functions /home/scott/.config/zim/modules/zsh-completions/src /home/scott/.config/zim/modules/k/functions /home/scott/.config/zim/modules/pvenv/functions /home/scott/.config/zim/modules/zim-k9s/functions ${fpath})
autoload -Uz -- git-alias-lookup git-branch-current git-branch-delete-interactive git-branch-remote-tracking git-dir git-ignore-add git-root git-stash-clear-interactive git-stash-recover git-submodule-move git-submodule-remove mkcd mkpw k pvenv
source /home/scott/.config/zim/modules/powerlevel10k/powerlevel10k.zsh-theme
source /home/scott/.config/zim/modules/environment/init.zsh
source /home/scott/.config/zim/modules/git/init.zsh
source /home/scott/.config/zim/modules/input/init.zsh
source /home/scott/.config/zim/modules/termtitle/init.zsh
source /home/scott/.config/zim/modules/utility/init.zsh
source /home/scott/.config/zim/modules/ssh/init.zsh
source /home/scott/.config/zim/modules/homebrew/init.zsh
source /home/scott/.config/zim/modules/zim-zoxide/init.zsh
source /home/scott/.config/zim/modules/exa/init.zsh
source /home/scott/.config/zim/modules/fzf/init.zsh
source /home/scott/.config/zim/modules/k/init.zsh
source /home/scott/.config/zim/modules/zim-k9s/init.zsh
source /home/scott/.config/zim/modules/completion/init.zsh
source /home/scott/.config/zim/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/scott/.config/zim/modules/zsh-history-substring-search/zsh-history-substring-search.zsh
source /home/scott/.config/zim/modules/zsh-autosuggestions/zsh-autosuggestions.zsh
