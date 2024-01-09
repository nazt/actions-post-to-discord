#!/bin/sh
set -e

# Function to get the public IP address
get_public_ip() {
    curl -s https://api.ipify.org
}

# Gather information from the environment
GITHUB_REPOSITORY=${GITHUB_REPOSITORY:-"Unknown Repository"}
GITHUB_REF_NAME=${GITHUB_REF_NAME:-"Unknown Branch"}
GITHUB_SHA=${GITHUB_SHA:-"Unknown SHA"}
RUNNER_NAME=${RUNNER_NAME:-"Unknown Runner"}

env
# Construct the JSON payload using a heredoc for better readability
PAYLOAD=$(jq -nc --arg description "Deploying Repository: $GITHUB_REPOSITORY on branch $GITHUB_REF_NAME" \
               --arg commit_hash "$GITHUB_SHA" \
               --arg repo "$GITHUB_REPOSITORY" \
               --arg machine "$RUNNER_NAME" \
               --arg ref_name "$GITHUB_REF_NAME" \
               --arg actor "$GITHUB_ACTOR" \
               --arg ip "$(get_public_ip)" \
               '{
                   "embeds": [
                       {
                           "description": $description,
                           "fields": [
                               {"name": "Repo:", "value": $repo},
                               {"name": "Commit:", "value": $commit_hash},
                               {"name": "Branch/Tag:", "value": $ref_name},
                               {"name": "Machine:", "value": $machine},
                               {"name": "IP Address:", "value": $ip},
                               {"name": "Actor:", "value": $actor}
                           ]
                       }
                   ]
               }')

# Post to Discord
DISCORD_WEBHOOK_URL=${INPUT_DISCORD_WEBHOOK_URL:-"Your Webhook URL Here"}
curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$DISCORD_WEBHOOK_URL"
