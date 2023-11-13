#!/bin/bash

# Variables
REPO_URL="https://your-repository-url.git"  # Replace with your repository URL
BRANCH_NAME="new-branch"                    # Replace with your desired branch name

# Check if Git is installed
if ! command -v git &> /dev/null
then
    echo "git could not be found"
    exit
else
    echo "Git is installed"
fi

# Clone the repository
git clone $REPO_URL
if [ $? -ne 0 ]; then
    echo "Failed to clone the repository"
    exit 1
fi

# Change to repository directory
REPO_DIR=$(basename "$REPO_URL" .git)
cd $REPO_DIR

# Create and checkout the new branch
git checkout -b $BRANCH_NAME
if [ $? -ne 0 ]; then
    echo "Failed to create and checkout the new branch"
    exit 1
fi

# Push the new branch to remote
git push -u origin $BRANCH_NAME
if [ $? -ne 0 ]; then
    echo "Failed to push the new branch to remote"
    exit 1
fi

echo "Branch $BRANCH_NAME created and checked out successfully"
