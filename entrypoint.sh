
#!/bin/sh -l

# Fetching inputs
WEBHOOK_URL=$1
REPO_NAME=$2
COMMIT_HASH=$3
REF_NAME=$4
MACHINE=$5

# Construct the JSON payload
PAYLOAD=$(jq -nc   --arg description "Deploying Repository: $REPO_NAME on branch $REF_NAME"   --arg commit_hash "$COMMIT_HASH"   --arg machine "$MACHINE"   --arg ref_name "$REF_NAME"   --arg ip "$(curl -s https://api.ipify.org)"   '{"embeds": [{"description": $description, "fields": [
    {"name": "Commit Hash", "value": $commit_hash},
    {"name": "Ref Name", "value": $ref_name},
    {"name": "Machine", "value": $machine},
    {"name": "IP Address", "value": $ip}
  ]}]}')

# Post to Discord
curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$WEBHOOK_URL"
