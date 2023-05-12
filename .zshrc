# Exports

export GOPATH=~/go
export PATH=$HOME/bin:/usr/local/bin:/usr/local/go/bin:$PATH
export PATH=$PATH:$GOPATH/bin
export GO111MODULE=on
export ZSH="$HOME/.oh-my-zsh"
fpath=(~/.zfunc $fpath)

# Plugins
plugins=(git docker golang zsh-autosuggestions zsh-syntax-highlighting)

# Oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias la='ls -A'
alias l='ls -CF'
alias ls="exa --icons --group-directories-first"
alias ll="exa --icons --group-directories-first -l"
alias grep='grep --color'
alias kubectl="kubecolor"
alias k="kubectl"
alias h="helm"
alias ip="ip -c"

# Functions

kgc() {
    kubectl config get-contexts
}

kuc() {
    if [ "$1" != "" ]; then
	    kubectl config use-context $1
    else
	    echo -e "\e[1;31m Error, please provide a valid context\e[0m"
    fi
}

# Starship elements

# Check which distro is running
case "$OSTYPE" in
  darwin*)
    _distro="macos"
  ;;
  linux*)
    _distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
  ;;
esac

# Set an icon based on the distro
case $_distro in
    *kali*)                  ICON="ﴣ";;
    *arch*)                  ICON="";;
    *debian*)                ICON="";;
    *raspbian*)              ICON="";;
    *ubuntu*)                ICON="";;
    *elementary*)            ICON="";;
    *fedora*)                ICON="";;
    *coreos*)                ICON="";;
    *gentoo*)                ICON="";;
    *mageia*)                ICON="";;
    *centos*)                ICON="";;
    *opensuse*|*tumbleweed*) ICON="";;
    *sabayon*)               ICON="";;
    *slackware*)             ICON="";;
    *linuxmint*)             ICON="";;
    *alpine*)                ICON="";;
    *aosc*)                  ICON="";;
    *nixos*)                 ICON="";;
    *devuan*)                ICON="";;
    *manjaro*)               ICON="";;
    *rhel*)                  ICON="";;
    *macos*)                 ICON="";;
    *)                       ICON="";;
esac

# Load Starship
export STARSHIP_DISTRO="$ICON "
eval "$(starship init zsh)"
if [ "$TMUX" = "" ]; then tmux; fi

