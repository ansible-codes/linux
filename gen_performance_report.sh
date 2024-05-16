#!/bin/bash

# Set the output file
OUTPUT_FILE="system_report.txt"

# Function to write a section header to the report
write_section_header() {
    echo -e "\n==================== $1 ====================\n" >> $OUTPUT_FILE
}

# Clear the output file
> $OUTPUT_FILE

# Disk Usage
write_section_header "Disk Usage"
df -h >> $OUTPUT_FILE

# Memory RAM Usage
write_section_header "Memory RAM Usage"
free -h >> $OUTPUT_FILE

# Paging Usage
write_section_header "Paging Usage"
vmstat -s >> $OUTPUT_FILE

# Tomcat Memory Usage (assuming tomcat is the process name)
write_section_header "Tomcat Memory Usage"
ps aux | grep '[t]omcat' | awk '{print $2}' | xargs -I {} pmap {} | grep total >> $OUTPUT_FILE

# HTTP Memory Usage (assuming httpd is the process name)
write_section_header "HTTP Memory Usage"
ps aux | grep '[h]ttpd' | awk '{print $2}' | xargs -I {} pmap {} | grep total >> $OUTPUT_FILE

# OS Health
write_section_header "OS Health"
uptime >> $OUTPUT_FILE

# CPU Usage
write_section_header "CPU Usage"
top -bn1 | grep "Cpu(s)" >> $OUTPUT_FILE

# Networking Usage
write_section_header "Networking Usage"
ifstat -t 1 1 >> $OUTPUT_FILE

# Disk Space Usage
write_section_header "Disk Space Usage"
du -sh /* 2>/dev/null >> $OUTPUT_FILE

# Performance Metrics
write_section_header "Performance Metrics"
iostat >> $OUTPUT_FILE
mpstat >> $OUTPUT_FILE
sar -u 1 3 >> $OUTPUT_FILE

# Top Command Output
write_section_header "Top Command Output"
top -bn1 >> $OUTPUT_FILE

# Notify user
echo "System report generated in $OUTPUT_FILE"
