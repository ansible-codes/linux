#!/bin/bash

# Function to check if required dependencies are installed
check_dependencies() {
    local missing_deps=0
    for dep in curl openssl dig nslookup; do
        if ! command -v "$dep" &> /dev/null; then
            echo "Dependency missing: $dep"
            missing_deps=$((missing_deps + 1))
        fi
    done

    if [ "$missing_deps" -ne 0 ]; then
        echo "Please install missing dependencies before running the script."
        exit 1
    fi
}

# Check dependencies
check_dependencies

# Output HTML file
output_html="output_ssl_check.html"

# Start HTML file
echo "<html><body><table border='1'><tr><th>URL</th><th>Status (Secure)</th><th>Status (Insecure)</th><th>IP</th><th>Hostname</th><th>SSL Expiry</th></tr>" > "$output_html"

# Read each line in url_file.txt
while IFS= read -r url
do
    # Get the HTTP status code with SSL validation
    status_secure=$(curl -o /dev/null -s -w "%{http_code}" "$url")

    # Get the HTTP status code without SSL validation
    status_insecure=$(curl -o /dev/null -s -w "%{http_code}" --insecure "$url")

    # Extract IP and hostname
    ip=$(dig +short "$url" | head -n 1)
    hostname=$(nslookup "$ip" | awk '/name = / {print $4}' | sed 's/.$//')

    # Extract SSL Certificate Expiry Date
    ssl_expiry=$(echo | openssl s_client -servername "${url#*//}" -connect "${url#*//}":443 2>/dev/null | openssl x509 -noout -dates | grep 'notAfter=' | cut -d= -f2)

    # Log the results
    echo "<tr><td>$url</td><td>$status_secure</td><td>$status_insecure</td><td>$ip</td><td>$hostname</td><td>$ssl_expiry</td></tr>" >> "$output_html"

done < "url_file.txt"

# End HTML file
echo "</table></body></html>" >> "$output_html"

echo "Report generated: $output_html"
