#!/bin/sh

# set -x
set -e

# Construct the JSON payload
PAYLOAD=$(jq -nc   --arg description "Deploying Repository: $GITHUB_REPOSITORY on branch $GITHUB_REF_NAME"   --arg commit_hash "$GITHUB_SHA"   --arg machine "$RUNNER_NAME"   --arg ref_name "$GITHUB_REF_NAME"   --arg ip "$(curl -s https://api.ipify.org)"   '{"embeds": [{"description": $description, "fields": [
    {"name": "Commit Hash", "value": $commit_hash},
    {"name": "Ref Name", "value": $ref_name},
    {"name": "Machine", "value": $machine},
    {"name": "IP Address", "value": $ip}
  ]}]}')

# Post to Discord
# curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$INPUT_DISCORD_WEBHOOK_URL"
curl -X POST -H "Content-Type: application/json" -d '{"content": "done :)"}' "$INPUT_DISCORD_WEBHOOK_URL"


# https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions