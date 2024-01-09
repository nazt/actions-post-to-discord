#!/bin/sh

set -x
set -e



# Fetching inputs
WEBHOOK_URL="$INPUT_WEBHOOK_URL"
REPO_NAME="$INPUT_REPO_NAME"
COMMIT_HASH="$INPUT_COMMIT_HASH"
REF_NAME="$INPUT_REF_NAME"
MACHINE="$INPUT_MACHINE"


env
# Construct the JSON payload
PAYLOAD=$(jq -nc   --arg description "Deploying Repository: $REPO_NAME on branch $REF_NAME"   --arg commit_hash "$COMMIT_HASH"   --arg machine "$MACHINE"   --arg ref_name "$REF_NAME"   --arg ip "$(curl -s https://api.ipify.org)"   '{"embeds": [{"description": $description, "fields": [
    {"name": "Commit Hash", "value": $commit_hash},
    {"name": "Ref Name", "value": $ref_name},
    {"name": "Machine", "value": $machine},
    {"name": "IP Address", "value": $ip}
  ]}]}')

echo "$WEBHOOK_URL"
# Post to Discord
curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$WEBHOOK_URL"
