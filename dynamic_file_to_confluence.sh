#!/bin/bash

# Variables
FILE_PATH="/path/to/your/dynamic/file.txt"
CONFLUENCE_URL="https://yourconfluenceinstance.atlassian.net/wiki"
PAGE_ID="YOUR_PAGE_ID"
USERNAME="your@email.com"
API_TOKEN="ATATT3xFfGF0JoNyqK-Y-2phQ0C5qswjMrXP-qafALvMZFfHfZrsbPGVlndPMQj729aEdhzFlxfnuAWTCOEabndPzw8v1LoRPeuA4C35SuvGGw4gzakI_2n59qsrGJMbaYs1Uig-CBasweunoEQ8ZXPnbgIWIKPCHll6Qlbe8UYACQGmIoBVElA=13E775BC"
SPACE_KEY="YOUR_SPACE_KEY"

# Read file content
CONTENT=$(cat "$FILE_PATH")

# Convert newlines to '\n'
JSON_CONTENT=$(echo "$CONTENT" | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))')

# Construct JSON data
JSON_DATA="{\"version\":{\"number\":2},\"title\":\"Your Page Title\",\"type\":\"page\",\"body\":{\"storage\":{\"value\":$JSON_CONTENT,\"representation\":\"storage\"}}}"

# Use curl to push to Confluence
curl -u "$USERNAME:$API_TOKEN" -X PUT -H 'Content-Type: application/json' "$CONFLUENCE_URL/rest/api/content/$PAGE_ID" -d "$JSON_DATA"
