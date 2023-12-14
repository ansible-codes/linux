#!/bin/bash

# Function to check if a variable is empty
check_empty() {
    local var_name="$1"
    local var_value="${!var_name}"

    if [ -z "$var_value" ]; then
        echo "Error: Parameter '$var_name' is empty."
        exit 1
    fi
}

# Get the current path
current_path=$(pwd)

file_path="$current_path/RepointDB_responseFile.txt"

# Check if the file is empty
if [ ! -s "$file_path" ]; then
    echo "Error: The file is empty."
    exit 1
fi

# Read the file line by line
while IFS= read -r line
do
    # Extract the key and value from each line
    key=$(echo "$line" | cut -d ':' -f 1)
    value=$(echo "$line" | cut -d ':' -f 2)

    # Remove spaces from key
    key=$(echo "$key" | tr -d ' ')

    # Assign the value to the variable named as key
    eval "$key=\"$value\""
done < "$file_path"

# Check each variable for emptiness
check_empty "Griffin_Jira_number"
check_empty "Point_to_UI_host"
check_empty "GriffinDB_host"
check_empty "GriffinDB_name"
check_empty "GriffinDB_credentials"
check_empty "GriffinAnalyticsDB_host"
check_empty "GriffinAnalyticsDB_name"
check_empty "GriffinAnalyticsDB_credentials"

# Example: Print all variables if none are empty
echo "Current Path: $current_path"
echo "Griffin_Jira_number: $Griffin_Jira_number"
echo "Point_to_UI_host: $Point_to_UI_host"
echo "GriffinDB_host: $GriffinDB_host"
# ... (continue with other variables as required)
