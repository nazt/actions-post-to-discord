#!/bin/sh

# set -x
set -e



# Fetching inputs
env
# Construct the JSON payload
PAYLOAD=$(jq -nc   --arg description "Deploying Repository: $INPUT_REPO_NAME on branch $INPUT_REF_NAME"   --arg commit_hash "$INPUT_COMMIT_HASH"   --arg machine "$INPUT_MACHINE"   --arg ref_name "$INPUT_REF_NAME"   --arg ip "$(curl -s https://api.ipify.org)"   '{"embeds": [{"description": $description, "fields": [
    {"name": "Commit Hash", "value": $commit_hash},
    {"name": "Ref Name", "value": $ref_name},
    {"name": "Machine", "value": $machine},
    {"name": "IP Address", "value": $ip}
  ]}]}')

echo "$INPUT_WEBHOOK_URL"
echo "$INPUT_WEBHOOK_URL"

# Post to Discord
curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$INPUT_WEBHOOK_URL"
