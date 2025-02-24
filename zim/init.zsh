# FILE AUTOMATICALLY GENERATED FROM /Users/scottbenjamin/.config/zsh/.zimrc
# EDIT THE SOURCE FILE AND THEN RUN zimfw build. DO NOT DIRECTLY EDIT THIS FILE!

if [[ -e ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]] zimfw() { source "${HOME}/.config/zim/zimfw.zsh" "${@}" }
fpath=("${HOME}/.config/zim/modules/git/functions" "${HOME}/.config/zim/modules/utility/functions" "${HOME}/.config/zim/modules/zsh-completions/src" "${HOME}/.config/zim/modules/k/functions" "${HOME}/.config/zim/modules/pvenv/functions" "${HOME}/.config/zim/modules/zim-k9s/functions" "${HOME}/.config/zim/modules/zim-starship/functions" ${fpath})
autoload -Uz -- git-alias-lookup git-branch-current git-branch-delete-interactive git-branch-remote-tracking git-dir git-ignore-add git-root git-stash-clear-interactive git-stash-recover git-submodule-move git-submodule-remove mkcd mkpw k pvenv
source "${HOME}/.config/zim/modules/environment/init.zsh"
source "${HOME}/.config/zim/modules/git/init.zsh"
source "${HOME}/.config/zim/modules/input/init.zsh"
source "${HOME}/.config/zim/modules/termtitle/init.zsh"
source "${HOME}/.config/zim/modules/utility/init.zsh"
source "${HOME}/.config/zim/modules/direnv/init.zsh"
source "${HOME}/.config/zim/modules/ssh/init.zsh"
source "${HOME}/.config/zim/modules/homebrew/init.zsh"
source "${HOME}/.config/zim/modules/zim-zoxide/init.zsh"
source "${HOME}/.config/zim/modules/exa/init.zsh"
source "${HOME}/.config/zim/modules/fzf/init.zsh"
source "${HOME}/.config/zim/modules/k/init.zsh"
source "${HOME}/.config/zim/modules/zim-k9s/init.zsh"
source "${HOME}/.config/zim/modules/zim-starship/init.zsh"
source "${HOME}/.config/zim/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "${HOME}/.config/zim/modules/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "${HOME}/.config/zim/modules/zsh-autosuggestions/zsh-autosuggestions.zsh"
