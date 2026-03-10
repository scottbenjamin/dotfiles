# Scott's dotfiles

<!--toc:start-->
- [Scott's dotfiles](#scotts-dotfiles)
- [Getting started](#getting-started)
<!--toc:end-->

My collection of dotfiles

## Getting started

The expectation is that you clone this directory and then symlink the files
to the correct locations that the tools expect

## Prerequisites

- GNU Stow
- Fish, tmux, Neovim, WezTerm, Waybar
- Nerd Font(s) used by terminal/editor/bar themes
- Waybar helpers: `playerctl`, `python3-gobject` (`gi`), and `curl`

## Use these

From the cloned repo issue:

```shell
stow -R .
```

## Notes

- `tmux` is intentionally excluded from `.stowrc`; link or copy `tmux/tmux.conf` manually if you use tmux.
