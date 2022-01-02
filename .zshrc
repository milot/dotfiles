# Start tmux
if [ "$TMUX" = "" ]; then tmux; fi

export PATH=/usr/bin:/home/milot/.local/bin:$PATH

# WSL2-only fix
fix_wsl2_interop() {
    for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
        if [[ -e "/run/WSL/${i}_interop" ]]; then
            export WSL_INTEROP=/run/WSL/${i}_interop
        fi
    done
}

# Colormap -- Useful for shell customization
function colormap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

# Custom kubectl functions
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

# Custom Alias
alias ls="exa --icons --group-directories-first"
alias ll="exa --icons --group-directories-first -l"
alias grep='grep --color'
alias kubectl="kubecolor"
alias k="kubectl"
alias h="helm"

# Check which distro is running
_distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')

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
    *)                       ICON="";;
esac

# Load Starship
export STARSHIP_DISTRO="$ICON "
eval "$(starship init zsh)"
