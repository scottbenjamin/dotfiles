# Nushell Environment Config File
#
# version = "0.99.1"

def create_left_prompt [] {
    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)(ansi reset)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}


# XDG_CONFIG_HOM is set in default mac nushell dir
$env.XDG_CACHE_HOME = ($nu.home-path | path join '.cache')
$env.XDG_DATA_HOME = ($nu.home-path | path join '.local' 'share')
$env.XDG_STATE_HOME = ($nu.home-path | path join '.local' 'state')

$env.NUPM_HOME = ($env.XDG_DATA_HOME | path join 'nupm')


# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($env.XDG_CONFIG_HOME | path join nushell scripts) 
    ($env.XDG_CONFIG_HOME | path join nushell completions) 
    ($env.XDG_STATE_HOME | path join nushell modules) # Nushell modules dir
    ($env.NUPM_HOME | path join modules) # nupm modules
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To allow for 'shells'
use std/dirs shells-aliases *

# Set XDG Config Home
$env.VISUAL = "nvim"
$env.EDITOR = $env.VISUAL
$env.PAGER = "bat"


# Terminfo
$env.TERMINFO_DIRS = [
    $"($env.HOME)/.nix-profile/share/terminfo"
    $"/etc/profiles/per-user/($env.USER)/share/terminfo"
    "/run/current-system/sw/share/terminfo"
    "/nix/var/nix/profiles/default/share/terminfo"
    "/usr/share/terminfo"
]


# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
# path add ($env.CARGO_HOME | path join "bin")
# path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)

# write nushell for loop over a list of paths to append to the path
path add  /opt/homebrew/bin
path add  ($nu.home-path | path join ".local" "bin")
path add  ($nu.home-path | path join ".cargo" "bin")
path add  ($env.NUPM_HOME| path join scripts)
path add  $"($env.HOME)/.nix-profile/bin"
path add  $"/etc/profiles/per-user/($env.USER)/bin"
path add  /nix/var/nix/profiles/default/bin
path add  /run/current-system/sw/bin
path add  /usr/local/bin

# Linux
#$env.PATH = ($env.PATH | split row (char esep) | prepend '/home/linuxbrew/.linuxbrew/bin')

# Pyenv add to PATH
if (which pyenv | length ) > 0 {
  $env.PATH = ($env.PATH | split row (char esep) | prepend $"(pyenv root)/shims")
}

const nu_config_dir = ($nu.home-path | path join '.config/nushell')

zoxide init nushell | save -f ~/.zoxide.nu

$env.STARSHIP_CONFIG = ($nu.home-path | path join .config starship starship.toml )
#$env.NIX_CONF_DIR = ($nu.home-path | path join '.config' 'nix')
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' 

# Carapace completions
mkdir ~/.cache/carapace
carapace _carapace nushell | save -f ~/.cache/carapace/init.nu

# Atuin
mkdir ~/.local/share/atuin/
atuin init nu | save -f ~/.local/share/atuin/init.nu

# Starship
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
