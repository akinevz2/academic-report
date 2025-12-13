#!/bin/bash

# Ensure the user provides a GitHub repository URL as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <GitHub Repo URL>"
    exit 1
fi

# Define the GitHub repository URL
REPO_URL="$1"
REPO_NAME=$(basename "$REPO_URL" .git)
LOCAL_DIR="./"

# Step 1: Clone the GitHub repository
echo "Cloning repository: $REPO_URL"
git clone "$REPO_URL/kinescript"
cd "$LOCAL_DIR" || { echo "Failed to enter the repository directory."; exit 1; }

# search step:


echo "Searching for Gist URLs in README.md..."
GIST_URLS=$(grep -o 'https://gist.githubusercontent.com/[a-zA-Z0-9_/-]\+/[a-zA-Z0-9_]\+/raw/[a-zA-Z0-9_/-]\+' README.md)

# If no Gist URLs are found, notify the user and exit
if [ -z "$GIST_URLS" ]; then
    echo "No Gist URLs found in README.md."
    exit 0
fi


# Step 3: Output Gist URLs to stdout
echo "Found Gist URLs:"
echo "$GIST_URLS"

# Step 4: Download the Gists
echo "Downloading Gists..."
for GIST_URL in $GIST_URLS; do
    # Extract the filename from the URL (last part after the last '/')
    FILENAME=$(basename "$GIST_URL")
    
    # Use wget or curl to download the Gist file
    echo "Downloading $GIST_URL to $FILENAME"
    wget -q --show-progress "$GIST_URL" -O "$FILENAME" || curl -sL "$GIST_URL" -o "$FILENAME"
    
    # Check if download was successful
    if [ $? -eq 0 ]; then
        echo "Successfully downloaded $FILENAME"
    else
        echo "Failed to download $FILENAME"
    fi
done

# Final message
echo "Thank you."