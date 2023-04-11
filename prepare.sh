#!/bin/env bash
set -eou pipefail

LOG="\033[0;33m" # yellow
ERR="\033[0;31m" # red
END="\033[0m"    # no color

log() {
    local msg="$1"
    echo -e "$msg"
}

log "${LOG}Installing ansible...${END}"
sudo apt update
sudo apt install -y software-properties-common

sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

if command -v ansible >/dev/null 2>&1; then
    log "${LOG}Ansible installed successfully! Version is:${END}"
    ansible --version
else
    log "${ERR}Ansible not installed, something went wrong!${END}"
    exit 1
fi

