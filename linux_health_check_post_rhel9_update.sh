#!/bin/bash
######################################
# Douglas Cardoso
# Devops team
# FEB/2024
#####################################
LOG_FILE="/tmp/linux_health_check.log"

# Function to log a message
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to check and log processes
check_process() {
    service_name=$1
    log_message "Checking processes for $service_name..."
    ps aux | grep $service_name | grep -v grep | tee -a "$LOG_FILE"
}
# Add these calls after the existing service status checks
check_process "tomcat"
check_process "apache2\|httpd"
check_process "supervisord"
check_process "splunk"
check_process "python"
check_process "prometheus"

# Check Linux services status
log_message "Checking Linux Services Status..."
systemctl list-units --type=service --state=running | grep -E "tomcat|httpd|apache2|splunk|supervisord|prometheus" | tee -a "$LOG_FILE"

# Check Tomcat status
log_message "Checking Tomcat Status..."
systemctl status tomcat | grep "Active:" | tee -a "$LOG_FILE"

# Check HTTP (Apache/Nginx) status
log_message "Checking HTTP Status..."
systemctl status apache2 || systemctl status httpd | grep "Active:" | tee -a "$LOG_FILE"

# Check Splunk status
log_message "Checking Splunk Status..."
systemctl status splunk | grep "Active:" | tee -a "$LOG_FILE"

# Check Supervisor status
log_message "Checking Supervisor Status..."
systemctl status supervisord | grep "Active:" | tee -a "$LOG_FILE"

# Check Prometheus status
log_message "Checking Prometheus Status..."
systemctl status prometheus | grep "Active:" | tee -a "$LOG_FILE"

# Check size of directories
log_message "Checking size of /app/supervisor/logs..."
du -sh /app/supervisor/logs | tee -a "$LOG_FILE"

log_message "Checking size of /app..."
du -sh /app | tee -a "$LOG_FILE"

# Check CPU, Memory, Disk Space, and Networking
log_message "Checking CPU, Memory, Disk Space, and Networking..."
top -bn1 | head -n 5 | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"
ifconfig | tee -a "$LOG_FILE"

# Perform nslookup and tnsping for hostnames in tnsnames.ora
log_message "Performing nslookup and tnsping for hostnames in /app/oracle/tnsnames.ora..."
grep "HOST" /app/oracle/tnsnames.ora | awk -F= '{print $2}' | sed 's/).*//' | while read -r hostname; do
    log_message "nslookup for $hostname"
    nslookup "$hostname" | tee -a "$LOG_FILE"
    log_message "tnsping for $hostname"
    tnsping "$hostname" | tee -a "$LOG_FILE"
done

log_message "Linux Health Check Completed."

echo "Script complete"
