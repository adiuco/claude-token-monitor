#!/bin/bash
# This script is used to bootstrap the development container environment.
set -e
# Ensure the script is run from the correct directory it exists in
cd "$(dirname "$0")"  
# capture the SCRIPT_DIR for anchoring invocation
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# code guard to bail if not using common logging
if ! command -v "$SCRIPT_DIR/00-a-common.sh" &> /dev/null; then
     logit "$SCRIPT_DIR/00-a-common.sh not found, exiting"
        exit 1;     
fi
# source the common logging script
source "$SCRIPT_DIR/00-a-common.sh"



logit "# 📦 DevContainer Installation Report" 
logit "## 📊 Installation Summary"



logit "Preparing toolchains.."


logit "Setting locale to en_US.UTF-8"
sudo locale-gen en_US.UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

logit "installing NVM to allow multiple Node.js versions"
logit "Details here: https://github.com/nvm-sh/nvm?tab=readme-ov-file#install--update-script "

if ! command -v nvm &> /dev/null; then
    logit "NVM not found, installing..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
 
export NVM_DIR="${HOME}/.nvm"
source "${NVM_DIR}/nvm.sh" # This loads nvm

else
    logit "NVM is already installed, checking version..."
    nvm --version
fi

logit "nvm is installed in ${NVM_DIR}"
nvm -v

logit "adding nodejs and npm"
nvm install node --lts


## 
# install claude-code based
##
logit "Checking for Claude Code CLI"

#check if latest claude-code is installed
if ! command -v claude &> /dev/null; then
    logit "Claude CLI not found, installing..."
    npm install -g @anthropic-ai/claude-code

else
    logit "Claude CLI installed, checking version...one moment please"

    claude --version
    
fi
logit""
logit "Run claude, login, use your subscription NOT API key, ctrl-c 2x to exit and then run these next steps"
logit ""
logit "To set your timezone in the container, run:"
logit "sudo ln -sf /usr/share/zoneinfo/Etc/GMT+5 /etc/localtime"
logit ""
logit "Replace GMT+5 with your timezone, e.g., GMT+8 for Singapore, GMT+1 for London, etc."
logit "You can find your timezone at https://en.wikipedia.org/wiki/List_of_tz_database_time_zones"

## 
# install gh based on https://github.com/cli/cli/blob/trunk/docs/install_linux.md
##

logit "Installing GitHub CLI..."
#check if gh is installed and if not do the following

if ! command -v gh &> /dev/null; then

(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

else
    logit "Already installed in "`$(which gh)`" version and status: "
    gh --version
logit""
    logit "Your status: "
    gh auth status || logit "You may need to run 'gh auth login' to authenticate."

fi
logit ""
logit ""

logit "## IT IS STRONGLY ADVISED TO USE A PERSONAL ACCESS TOKEN!"
logit "Why? Because it limits access to just the repositories you want to work with, and not your entire account."
logit
logit "You can generate a token at:"
logit " https://github.com/settings/personal-access-tokens"
logit ""
logit 'To add the token, gh auth login -> choose github.com ->choose ssh -> generate new ssh key (select no) -> Paste your token '

logit "now do ${SCRIPT_DIR}/01-setup-agentics-base.sh to install the base agentics tools (it may take a few minutes to install the first time)"
logit "and then ${SCRIPT_DIR}/02-reg-mcp.sh to register the Model Context Protocols (MCPs) with Claude CLI"