#!/bin/bash

# Define paths to the files
FILE1="path/to/first/main.yml"
FILE2="path/to/second/main.yml"

# Function to extract and compare a specific key
compare_key() {
    key=$1
    val1=$(grep "$key" "$FILE1" | awk '{ print $2 }')
    val2=$(grep "$key" "$FILE2" | awk '{ print $2 }')

    if [ "$val1" == "$val2" ]; then
        echo "$key is the same in both files."
    else
        echo "$key differs."
    fi
}

# Compare griffin_database_password
compare_key "griffin_database_password"

# Compare griffin_analytics_database_password
compare_key "griffin_analytics_database_password"
