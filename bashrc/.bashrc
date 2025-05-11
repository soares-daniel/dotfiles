# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# --- Common Configurations (apply to both Git Bash and WSL) ---

# Project
alias cddf="cdsoftdevcode && cd ./ics2-ssa-data-factory"
alias cdportal="cdsoftdevcode && cd ./ics2-ssa-portal/ics2-ssa-dev-utils && source ics2-ssa-installation-scripts.sh && cd .."
alias gossaproject="cdsoftdevcode && cd ./ics2-ssa-portal"
alias cddatafactory="cdsoftdevcode && cd ./ics2-ssa-data-factory"
alias cddatalabdesign="cdsoftdevcode && cd ./ics2-ssa-data-lab-design"
alias cddatalabtools="cdsoftdevcode && cd ./ics2-ssa-data-lab-tools"

alias ls="eza --color=always --group-directories-first --icons"
alias ll="eza -la --icons --octal-permissions --group-directories-first"
alias l="eza -bGF --header --git --color=always --group-directories-first --icons"
alias llm="eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons"
alias la="eza --long --all --group --group-directories-first"
alias lx="eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons"
alias lS="eza -1 --color=always --group-directories-first --icons"
alias lt="eza --tree --level=2 --color=always --group-directories-first --icons"
alias l.="eza -a | grep -E '^\.'"

# Dirs (Common - adjust paths in environment-specific sections if needed)
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

alias cl='clear'

alias stowdotfiles="cddotfiles && ./setup.sh && cd -"

alias preview="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias cpreview="preview | xargs code"

eval "$(starship init bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# --- Environment-Specific Configurations ---

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # --- Git Bash (Windows) Specific ---
    echo "Loading Git Bash specific configurations..."

    export PATH=$PATH:/home/d.a.soares/.cargo/bin # Assuming this is correct for Windows Git Bash
    # Note: PATH manipulation might need adjustment depending on how Git Bash handles this

    # Maven/Java (Windows)
    alias mci="mvn clean install"
    alias mciskip="mci -DskipTests"
    alias mvn8="JAVA_HOME='/c/Program Files/Java/jdk1.8.0_202' && mvn"
    alias mvn17="JAVA_HOME='/c/Program Files/Java/jdk-17' && mvn"
    alias mvn11="JAVA_HOME='/c/Program Files/Java/jdk-11' && mvn"
    alias mci8="mvn8 clean install"
    alias mci11="mvn11 clean install"
    alias mci17="mvn17 clean install"
    alias mciskip8="mci8 -DskipTests"
    alias mciskip11="mci11 -DskipTests"
    alias mciskip17="mci17 -DskipTests"

    # Project (Windows Path)
    alias cdsoftdevcode="cd /c/EDF/softdev/code"

    # k9s (Assuming this is used in Windows Git Bash, if not, move to WSL section)
    alias k9s-dev='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-dev-eks --profile softdev-admin && kubectl config set clusters.arn:aws:eks:eu-west-1:431273878438:cluster/d-ew1-ics2-ssa-ssa-dev-eks.proxy-url socks5://localhost:1080'
    alias k9s-dev2='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-dev2-eks --profile softdev-admin && kubectl config set clusters.arn:aws:eks:eu-west-1:431273878438:cluster/d-ew1-ics2-ssa-ssa-dev2-eks.proxy-url socks5://localhost:1080'
    alias k9s-dev3='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-dev3-eks --profile softdev-admin && kubectl config set clusters.arn:aws:eks:eu-west-1:431273878438:cluster/d-ew1-ics2-ssa-ssa-dev3-eks.proxy-url socks5://localhost:1080'
    alias k9s-dev4='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-dev4-eks --profile softdev-admin && kubectl config set clusters.arn:aws:eks:eu-west-1:431273878438:cluster/d-ew1-ics2-ssa-ssa-dev4-eks.proxy-url socks5://localhost:1080'
    alias k9s-dev5='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-dev5-eks --profile softdev-admin && kubectl config set clusters.arn:aws:eks:eu-west-1:431273878438:cluster/d-ew1-ics2-ssa-ssa-dev5-eks.proxy-url socks5://localhost:1080'
    alias k9s-dev6='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-dev6-eks --profile softdev-admin && kubectl config set clusters.arn:aws:eks:eu-west-1:431273878438:cluster/d-ew1-ics2-ssa-ssa-dev6-eks.proxy-url socks5://localhost:1080'
    alias k9s-dev7='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-dev7-eks --profile softdev-admin && kubectl config set clusters.arn:aws:eks:eu-west-1:431273878438:cluster/d-ew1-ics2-ssa-ssa-dev7-eks.proxy-url socks5://localhost:1080'
    alias k9s-hf='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-hf-eks --profile softdev-admin && kubectl config set clusters.arn:aws:eks:eu-west-1:431273878438:cluster/d-ew1-ics2-ssa-ssa-hf-eks.proxy-url socks5://localhost:1080'
    alias k9s-int='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ics2-int-eks --profile softdev-admin && kubectl config set clusters.arn:aws:eks:eu-west-1:431273878438:cluster/d-ew1-ics2-ssa-ics2-int-eks.proxy-url socks5://localhost:1080'
    alias mfa='~/.aws/mfa.sh'

    alias cddotfiles="cd /c/EDF/code/dotfiles"
    alias sb="source ~/.config/bashrc/.bashrc"

    source <(ng completion script)

elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    # --- Bash in WSL (Ubuntu/Alpine) Specific ---
    echo "Loading WSL specific configurations..."

    export PATH="/home/d-a-soares/softdev/internal-tools/setup-dev-env/bin:${PATH}"
    export PATH=$PATH:/home/d-a-soares/.cargo/bin

    . "$HOME/.cargo/env"

    # Project (WSL Paths)
    alias cdsoftdevcode="cd /mnt/c/EDF/softdev/code"
    alias cdansible="cdsoftdevcode && cd ./ansible-common"
    alias ansiblenv="cdansible && cd ./VMs/env-docker"
    alias ansiblestart="ansiblenv && git pull && ./10_env.sh start"
    alias ansiblestop="ansiblenv && ./10_env.sh stop"

    # Docker (WSL)
    alias dco="docker compose"
    alias dps="docker ps"
    alias dpa="docker ps -a"
    alias dl="docker ps -l -q"
    alias dx="docker exec -it"

    alias cddotfiles="cd /mnt/c/EDF/code/dotfiles"
    alias sb="source /mnt/c/Users/d.a.soares/.config/bashrc/.bashrc"

fi

# --- End of Environment-Specific Configurations ---
