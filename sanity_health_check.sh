#!/bin/bash

# Output file
OUTPUT_FILE="/tmp/system_health_report.html"

# Oracle tnsnames.ora file path
TNSNAMES_FILE="/path/to/tnsnames.ora"

# Apache httpd.conf file path
HTTPD_CONF_FILE="/path/to/httpd.conf"

# Function to check service status
check_service_status() {
    service_name=$1
    if systemctl is-active --quiet $service_name; then
        echo "<tr><td>$service_name</td><td style='color: green;'>Running</td></tr>"
    else
        echo "<tr><td>$service_name</td><td style='color: red;'>Stopped</td></tr>"
    fi
}

# Function to parse and nslookup hostnames from tnsnames.ora
parse_and_nslookup_tnsnames() {
    echo "<h2>Oracle TNS Names Resolution</h2>" >> $OUTPUT_FILE
    echo "<table border='1'><tr><th>TNS Entry</th><th>Resolution</th></tr>" >> $OUTPUT_FILE

    # Filter out comments and extract hostnames
    grep -v "^#" $TNSNAMES_FILE | grep 'HOST' | awk -F= '{print $2}' | tr -d ')( ' | while read -r host; do
        if nslookup "$host" &>/dev/null; then
            echo "<tr><td>$host</td><td style='color: green;'>Resolved</td></tr>" >> $OUTPUT_FILE
        else
            echo "<tr><td>$host</td><td style='color: red;'>Failed to Resolve</td></tr>" >> $OUTPUT_FILE
        fi
    done

    echo "</table>" >> $OUTPUT_FILE
}

# Function to parse httpd.conf and test URLs
test_httpd_urls() {
    echo "<h2>Apache URL Testing</h2>" >> $OUTPUT_FILE
    echo "<table border='1'><tr><th>URL</th><th>HTTP Status</th></tr>" >> $OUTPUT_FILE

    # Extract URLs from httpd.conf and test them
    grep 'ServerName' $HTTPD_CONF_FILE | awk '{print $2}' | while read -r url; do
        status=$(curl -o /dev/null -s -w "%{http_code}" "http://$url")
        if [ "$status" == "200" ]; then
            echo "<tr><td>$url</td><td style='color: green;'>$status</td></tr>" >> $OUTPUT_FILE
        else
            echo "<tr><td>$url</td><td style='color: red;'>$status</td></tr>" >> $OUTPUT_FILE
        fi
    done

    echo "</table>" >> $OUTPUT_FILE
}

# Start HTML file
echo "<html><head><title>System Health Report</title></head><body>" > $OUTPUT_FILE
echo "<h1>System Health Report</h1>" >> $OUTPUT_FILE
echo "<table border='1'><tr><th>Service</th><th>Status</th></tr>" >> $OUTPUT_FILE

# Check status of Apache and Tomcat
echo "$(check_service_status httpd)" >> $OUTPUT_FILE
echo "$(check_service_status tomcat)" >> $OUTPUT_FILE

# Check system health
echo "<tr><td>CPU Load</td><td>$(uptime | cut -d ',' -f 4-)</td></tr>" >> $OUTPUT_FILE
echo "<tr><td>Memory Usage</td><td>$(free -m | awk '/Mem:/ {print $3 "MB / " $2 "MB"}')</td></tr>" >> $OUTPUT_FILE
echo "<tr><td>Disk Space</td><td>$(df -h | grep -m 1 '^/dev/' | awk '{print $3 " / " $2}')</td></tr>" >> $OUTPUT_FILE

# Close service status table
echo "</table>" >> $OUTPUT_FILE

# Parse tnsnames.ora and perform nslookup
parse_and_nslookup_tnsnames

# Parse httpd.conf and test URLs
test_httpd_urls

# Close HTML file
echo "</body></html>" >> $OUTPUT_FILE

# Print message to user
echo "System health report generated at $OUTPUT_FILE"
