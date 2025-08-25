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
echo "Loading common configurations..."

# Project
alias cddf="cdsoftdevcode && cd ./ics2-ssa-data-factory"
alias cdportal="cdsoftdevcode && cd ./ics2-ssa-portal/ics2-ssa-dev-utils && source ics2-ssa-installation-scripts.sh && cd .."
alias gossaproject="cdsoftdevcode && cd ./ics2-ssa-portal"
alias cddatafactory="cdsoftdevcode && cd ./ics2-ssa-data-factory"
alias cddatalabdesign="cdsoftdevcode && cd ./ics2-ssa-data-lab-design"
alias cddatalabtools="cdsoftdevcode && cd ./ics2-ssa-data-lab-tools"
alias cddatalabaudit="cdsoftdevcode && cd ./ics2-ssa-data-lab-audit"

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

# k9s
alias k9s-dev1='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-dev1-eks --profile softdev-admin'
alias k9s-dev2='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-dev2-eks --profile softdev-admin'
alias k9s-dev3='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-dev3-eks --profile softdev-admin'
alias k9s-dev4='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-dev4-eks --profile softdev-admin'
alias k9s-dev5='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-dev5-eks --profile softdev-admin'
alias k9s-devops='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-devops-eks --profile softdev-admin'
alias k9s-arch='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-arch-eks --profile softdev-admin'
alias k9s-prod='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-prod-eks --profile softdev-admin'
alias k9s-pgs1='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ssa-pgs1-eks --profile softdev-admin'
alias k9s-int='aws eks update-kubeconfig --region eu-west-1 --name d-ew1-ics2-ssa-ics2-int-eks --profile softdev-admin'
alias mfa='~/.aws/mfa.sh'

eval "$(starship init bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Load Angular CLI autocompletion.
source <(ng completion script)

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

    alias cddotfiles="cd /c/EDF/code/dotfiles"

elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    # --- Bash in WSL (Ubuntu/Alpine) Specific ---
    echo "Loading WSL specific configurations..."

    export PATH="/home/d-a-soares/softdev/internal-tools/setup-dev-env/bin:${PATH}"
    export PATH=$PATH:/home/d-a-soares/.cargo/bin

    . "$HOME/.cargo/env"

    # Project (WSL Paths)
    alias cdsoftdevcode="cd ~/softdev/code"
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

    alias cddotfiles="cd /mnt/c/EDF/code/dotfiles && git pull"

    alias dive="docker run -ti --rm  -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive"
    alias start_using_aws_vpn="export http_proxy=http://127.0.0.1:1081/ && \
                       export https_proxy=http://127.0.0.1:1081/ && \
                       export HTTP_PROXY=http://127.0.0.1:1081/ && \
                       export HTTPS_PROXY=http://127.0.0.1:1081/ && \
                       export ALL_PROXY=socks5h://127.0.0.1:1080/"
    alias stop_using_vpn="export http_proxy= && \
                       export https_proxy= && \
                       export HTTP_PROXY= && \
                       export HTTPS_PROXY= && \
                       export ALL_PROXY="


    complete -C /usr/bin/terraform terraform

fi

echo "Environment setup complete."
# --- End of Environment-Specific Configurations ---