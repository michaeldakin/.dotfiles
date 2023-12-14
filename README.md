# README
This repo was originally for my neovim setup, but has been expanded to contain the majority of my current MacOS setup.

# Stow
This branch now uses GNU Stow to manage my dotfiles and symlinks them to ~/ or $XDG_CONFIG_HOME.
The version of Stow installed on MacOS Sonoma is 2.3.1 and has a slightly different setup than prior versions which used -D or --dotfiles.

To use this version of Stow, the setup is as following
```
~/.dotfiles
    /config
        /.config
    /local
        /.local
    /tmux
        /.tmux
    /zsh
        /.zsh
```

# Instructions
1. Install Git
    - Pull this repo `git clone https://github.com/michaeldakin/.dotfiles.git ~/.dotfiles`
2. Install Brew
    - cd to ~/.dotfiles
    - Run `brew bundle install`
3. Install iTerm2 and add profile
4. Confirm tmux and Neovim installed correctly and pull plugins via TPM and Lazy
    - tmux will self install and pull plugins on first launch
    - Neovim (if all dependencies are installed) will launch Lazy.nvim and pull all plugins in ~/.config/nvim/lua/mdakin/plugins
5. good luck with browser ext and tabs etc....

# Goals
A goal for this repo is to have my current MacOS running config in one place and be able to pull this down on a new device and be setup within the shortest possible time.
Realistically including MacOS profile settings should be included such as key repeat, keyboard focus etc.

## Todo list
- [x] Move ~~ all ~~ current used application configurations consolidated into ~~ ~/.config ~~ ~/.dotfiles directory
    - [ ] Generate list of apps which arent installed via Brew
- [x] Dump Brew list of applications
    - [ ] Add script to periodically / manually grab Brew apps and upload to git with submodule?
- [x] Setup Stow
- [] Create install script to pushd/stow folders
    - [ ] Setup git profile with name/email and .gitconfig (Similar to https://github.com/shakeelmohamed/stow-dotfiles/blob/main/git_setup.sh)
    - [ ] Detect MacOS (darwin) or Linux (RHEL) work vps with $XDG_CONFIG_HOME
    - [ ] Include Brew setup inside repo
    - [ ] Determine Neovim stable vs HEAD branch based off installed packages (make, curl-devel, git, etc)
    - [ ] live the dream?
