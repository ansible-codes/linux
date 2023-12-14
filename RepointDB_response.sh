#!/bin/bash

file_path="/path/to/your/file/RepointDB_responseFile.txt"

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

# Example: Print all variables
echo "Griffin_Jira_number: $Griffin_Jira_number"
echo "Point_to_UI_host: $Point_to_UI_host"
echo "GriffinDB_host: $GriffinDB_host"
echo "GriffinDB_name: $GriffinDB_name"
echo "GriffinDB_credentials: $GriffinDB_credentials"
echo "GriffinAnalyticsDB_host: $GriffinAnalyticsDB_host"
echo "GriffinAnalyticsDB_name: $GriffinAnalyticsDB_name"
echo "GriffinAnalyticsDB_credentials: $GriffinAnalyticsDB_credentials"
# ... (continue with other variables as required)
