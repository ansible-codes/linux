#!/bin/bash

# Path to the file containing URLs
file_path="test_url_griffin.txt"

# Check if the file exists
if [ ! -f "$file_path" ]; then
    echo "Error: File not found."
    exit 1
fi

# Read each line from the file
while IFS= read -r url
do
    # Check if the URL is accessible
    if curl --output /dev/null --silent --head --fail "$url"; then
        echo "URL $url is accessible."
    else
        echo "URL $url is not accessible."
    fi
done < "$file_path"
