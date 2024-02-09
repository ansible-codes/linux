#!/bin/bash

# Define variables
git_repository_url="<git_repository_url>" # Replace with your Git repository URL
work_repo_dir="<work_repo_dir>"           # Replace with your working repository directory name
hostdir="<hostdir>"                       # Replace with your directory that contains hostnames
userID="<userID>"                         # Replace with your userID for ansible-vault
vault_password_file="<vault_password_file_path>" # Replace with your vault password file path

# Clone the Git repository
git clone "$git_repository_url"
if [ $? -ne 0 ]; then
    echo "Failed to clone the repository."
    exit 1
fi

# Navigate to the specified working directory within the cloned repository
cd "$work_repo_dir" || exit
if [ $? -ne 0 ]; then
    echo "The specified working directory does not exist."
    exit 1
fi

# Iterate over each hostname found in the specified directory
for hostname in $(ls "$hostdir"); do
    # Construct the path to the main.yml file for the current hostname
    yml_file="${hostdir}/${hostname}/main.yml"
    
    # Check if the main.yml file exists before attempting to decrypt
    if [ -f "$yml_file" ]; then
        # Execute the ansible-vault decrypt command
        ansible-vault decrypt "$yml_file" --vault-id "$userID@$vault_password_file"
        if [ $? -ne 0 ]; then
            echo "Failed to decrypt ${yml_file}."
            # Decide whether to exit or continue based on your preference
            # exit 1
        fi
    else
        echo "File ${yml_file} does not exist."
    fi
done
