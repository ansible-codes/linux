#!/bin/bash

# Function to copy a key from one file to another
copy_key() {
    local key=$1
    local source_file=$2
    local destination_file=$3

    # Check if the key exists in the source file
    if ! grep -q "^$key:" "$source_file"; then
        echo "Key $key not found in the source file $source_file."
        return
    fi

    # Extract the value for the key from the source file
    local key_value=$(grep "^$key:" "$source_file" | awk '{ $1=""; sub(/^ /,""); print }')

    # Check if the key exists in the destination file
    if grep -q "^$key:" "$destination_file"; then
        # Key exists, replace the line
        sed -i "/^$key:/c\\$key: $key_value" "$destination_file"
    else
        # Key doesn't exist, append it
        echo "$key: $key_value" >> "$destination_file"
    fi

    echo "Key $key has been copied from $source_file to $destination_file"
}

# Define the keys and their respective source and destination files
KEY1="griffin_database_password"
SOURCE_FILE1="path/to/source1/main.yml"
DESTINATION_FILE1="path/to/destination1/main.yml"

KEY2="griffin_analytics_database_password"
SOURCE_FILE2="path/to/source2/main.yml"
DESTINATION_FILE2="path/to/destination2/main.yml"

# Copy each key independently
copy_key "$KEY1" "$SOURCE_FILE1" "$DESTINATION_FILE1"
copy_key "$KEY2" "$SOURCE_FILE2" "$DESTINATION_FILE2"
