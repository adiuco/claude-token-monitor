#!/bin/bash
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

logit "adding MCPs to Claude CLI"

claude mcp add  github -- npx -y "@modelcontextprotocol/server-github"
claude mcp add playwright -- npx "@playwright/mcp@latest"
claude mcp add context7 -- npx -y "@upstash/context7-mcp@latest"