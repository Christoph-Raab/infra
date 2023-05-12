#!/bin/env bash
set -eou pipefail

LOG="\033[0;33m" # yellow
ERR="\033[0;31m" # red
END="\033[0m"    # no color

log() {
    local msg="$1"
    local lvl="${2:-"-i"}"
    local out

    if [[ "$lvl" == "-i" ]];then
        out="${LOG}$msg${END}"
    else
        out="${ERR}$msg${END}"
    fi
    echo -e "$out"
}

CLONE="${1:-"no"}"

log "Updating apt cache..."
sudo apt update

log "Checking for ansible..."
if ! command -v ansible >/dev/null 2>&1; then
    log "Installing ansible..."
    sudo apt install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible

    log "Ansible installed successfully! Version is:"
    ansible --version
fi
echo

log "Checking additional requirements..."
if ! command -v git >/dev/null 2>&1; then
    log "- Installing git..."
    sudo apt install git
fi

log "All requirements setup!"
echo

if [[ "$CLONE" == "--clone" ]];then
    log "Cloning repo to $HOME/infra..."
    target_dir="$HOME/infra"
    if [[ -d "$target_dir" ]];then
        log "Target dir $target_dir already exists, aborting..." -e
        exit 1
    else
        git clone https://github.com/Christoph-Raab/infra.git "$target_dir"
    fi
    echo
fi

log "Preparation done!"
