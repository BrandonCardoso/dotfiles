# .dotfiles
Configuration files for various programs.

## How to use/install
This repo is setup to use [GNU Stow](https://www.gnu.org/software/stow/) to create symlinks in your home directory to all of the configuration files for each application.

Clone into your home directory (or use Stow's `--target` flag) and install the git submodules.
```
cd ~
git clone git@github.com:BrandonCardoso/.dotfiles.git
cd .dotfiles
git submodule update --init --recursive
```

Use `stow -v <folder>` to create symlinks to the configuration files in `<folder>`.

`stow -v --simulate <folder>` to preview the changes before applying.

