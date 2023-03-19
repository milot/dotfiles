#!/bin/bash

usage() {
  cat << EOF 
Usage: $(basename "${BASH_SOURCE[0]}") install

Easy installation script for dot files.

Available options:

help      Print this help and exit.
install   Install dot files.
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  flag=0
  param=''

  while :; do
    case "${1-}" in
    help) usage ;;
    -i | --install)
      install="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments use install or help."

  return 0
}

parse_params "$@"
setup_colors

if [ "${args[*]-}" = "install" ]; then
    msg "${RED}Requiring sudo permissions to install curl, unzip, zsh starship and copy binary files such as exa and kubecolor to appropriate directories."
    sudo apt update
    sudo apt install curl unzip zsh -y
    msg "${RED} Installing NeoVim"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    ./nvim.appimage
    git clone https://github.com/nvim-lua/kickstart.nvim.git
    mkdir ~/.config/nvim
    mv kickstart.nvim/* ~/.config/nvim/*
    rm -dr kickstart.nvim
    chsh -s /usr/bin/zsh
    msg "${RED}Installation in progress:${NOFORMAT}"
    msg "${NOFORMAT}* ${GREEN}Installing Oh-my-zsh"
    mkdir installation-files
    curl -L -o installation-files/omz-install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
    ZSH= sh installation-files/omz-install.sh --unattended
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
    msg "${NOFORMAT}* ${GREEN}Installing Starship"
    curl -L -o installation-files/starship-install.sh https://starship.rs/install.sh
    chmod +x installation-files/starship-install.sh
    ./installation-files/starship-install.sh
    msg "${NOFORMAT}* ${CYAN}Copying Starship Configuration"
    mkdir $HOME/.config/
    cp .config/starship.toml $HOME/.config/starship.toml
    msg "${NOFORMAT}* ${GREEN}Installing kubecolor"
    curl -L -o installation-files/kubecolor.tar.gz https://github.com/hidetatz/kubecolor/releases/download/v0.0.20/kubecolor_0.0.20_Linux_x86_64.tar.gz
    msg "${NOFORMAT}* ${CYAN}Copying kubecolor binaries"
    tar zxf installation-files/kubecolor.tar.gz -C installation-files/
    sudo mv installation-files/kubecolor /usr/bin/
    msg "${NOFORMAT}* ${GREEN}Installing exa (modern replacement for ls)"
    curl -L -o installation-files/exa.zip https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip
    msg "${NOFORMAT}* ${CYAN}Copying exa binaries"
    unzip installation-files/exa.zip -d installation-files
    sudo mv installation-files/bin/exa /usr/bin
    mkdir $HOME/.zfunc
    mv installation-files/completions/exa.zsh $HOME/.zfunc
    msg "${NOFORMAT}* ${CYAN}Copying .zshrc"
    cp .zshrc $HOME/.zshrc
    msg "${NOFORMAT}* ${GREEN}Installing Vundle (vim plugin manager)"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    msg "${NOFORMAT}* ${CYAN}Copying .vimrc, .vimrc.bundles and .vimrc.local"
    cp .vimrc .vimrc.bundles .vimrc.bundles.local $HOME/
    msg "${RED}---------------------------------------------------------------------"
    msg "${NOFORMAT}* ${YELLOW}DONE!"
    msg "${NOFORMAT}* ${RED}NOTE: Remember to run :PluginInstall to install plugins!"
    msg "${NOFORMAT}* ${RED}Now restart the terminal"
    msg "${RED}---------------------------------------------------------------------"
    rm -fr installation-files
fi
