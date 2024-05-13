#!/bin/bash
# Author: 
# script name: adhoc_scp_copy.sh
# Define the directory to copy
directory_to_copy="/path/to/source_directory"

# Read the list of hosts from the file
hosts_file="file_host.txt"
while IFS= read -r host; do
    # Ignore empty lines and lines starting with #
    if [[ -n "$host" && ! "$host" =~ ^# ]]; then
        scp -r "$directory_to_copy" "$host:/path/to/destination_directory"
    fi
done < "$hosts_file"
