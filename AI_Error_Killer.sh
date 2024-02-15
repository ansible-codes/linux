#!/bin/bash

# Log file paths for each service
LOG_FILES_APACHE=("/var/log/apache2/error.log")
LOG_FILES_TOMCAT=("/var/log/tomcat/catalina.out")
LOG_FILES_ORACLE=("/u01/app/oracle/diag/rdbms/mydb/mydb/trace/alert_mydb.log")
LOG_FILES_JAVA=("${LOG_FILES_TOMCAT[@]}") # Assuming Java errors are logged in Tomcat's log

ERROR_DB="error_db.csv"
TMP_ERRORS_FILE="/tmp/extracted_errors_$(date +%Y%m%d%H%M%S).log"
ERROR_SUMMARY_FILE="/tmp/error_summary_$(date +%Y%m%d).csv"

# Function to extract and categorize errors for a given service
extract_and_categorize_errors() {
    local service=$1
    local log_files=("${!2}")
    echo "Processing $service errors..."
    for log_file in "${log_files[@]}"; do
        if [ -f "$log_file" ]; then
            grep -i -f <(awk -F, -v s="$service" '$1==s {print $2}' "$ERROR_DB") "$log_file" >> "$TMP_ERRORS_FILE"
        else
            echo "Log file $log_file not found."
        fi
    done
}

# Function to match errors with solutions
match_errors_with_solutions() {
    echo "Matching errors with solutions..."
    while IFS=, read -r service pattern solution; do
        if grep -qi "$pattern" "$TMP_ERRORS_FILE"; then
            echo "Service: $service"
            echo "Error: $pattern"
            echo "Solution: $solution"
            echo ""
        fi
    done < "$ERROR_DB"
}

# Function to analyze error frequency
analyze_error_frequency() {
    echo "Date,Service,Error,Count" > "$ERROR_SUMMARY_FILE"
    while IFS=, read -r service pattern solution; do
        count=$(grep -oic "$pattern" "$TMP_ERRORS_FILE")
        if [ "$count" -ne 0 ]; then
            echo "$(date +%Y-%m-%d),$service,$pattern,$count" >> "$ERROR_SUMMARY_FILE"
        fi
    done < "$ERROR_DB"
    echo "Error frequency analysis saved to $ERROR_SUMMARY_FILE"
}

# Main execution flow
SERVICES=("Apache" "Tomcat" "Oracle" "Java")
for service in "${SERVICES[@]}"; do
    log_var="LOG_FILES_${service^^}"
    extract_and_categorize_errors "$service" "$log_var[@]"
done

match_errors_with_solutions
analyze_error_frequency

# Cleanup
rm -f "$TMP_ERRORS_FILE"
