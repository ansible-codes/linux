#!/bin/bash

# Prompt for new values
read -p "Enter new database host: " new_host
read -p "Enter new database service name: " new_service_name
read -p "Enter new database username: " new_username

# Replace the old values with new ones in main.yaml
sed -i "s/database_host: .*/database_host: $new_host/" main.yaml
sed -i "s/database_service_name: .*/database_service_name: $new_service_name/" main.yaml
sed -i "s/database_username: .*/database_username: $new_username/" main.yaml

echo "Updated main.yaml with new values."
