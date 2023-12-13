#!/bin/bash

# Automated Backup and Rotation Script

# Configuration
project_folder="/home/linux-notebook/Dip/EnactOn/Project1"  #Add the path of the project which you have to backup
rotation_days=7                                             # Number of daily backups to keep
rotation_weeks=4                                            # Number of weekly backups to keep
rotation_months=3                                           # Number of monthly backups to keep
google_drive_folder="Task"                                  # Add the actual folder name created on Google Drive.
webhook_url="https://webhook.site/a50d3a70-59a0-4ad3-ba5f-460a8ba7ce9c"   # Pass the actual cURL (Create/Get from https://webhook.site)
log_file="backup_log.txt"                                   # Log file to store backup information

# Function for backup
perform_backup() {
    # Create the backup directory
    backup_dir="$project_folder-backup"
    mkdir "$backup_dir"

    # Creating the zip archive file
    zip -r "$backup_dir/project_backup.zip" "$project_folder"

    # Uploading the zip backup file to google drive
    rclone copy "$backup_dir/project_backup.zip" "task:$google_drive_folder"

    # Condition check it file is uploaded to Google Drive or not
    if [ $? -eq 0 ]; then
        echo "Backup successfully uploaded to Google Drive: $backup_dir/project_backup.zip"
        send_curl_request "BackupSuccessful"
    else
        echo "Backup upload to Google Drive failed"
        send_curl_request "BackupFailed"
        exit 1
    fi
}

# Function to send cURL request
send_curl_request() {
    # Check if cURL request is enabled (set to 1 for testing purposes)
    enable_curl=1

    if [ $enable_curl -eq 1 ]; then
        # Prepare cURL to send the request
        curl_data="{\"project\": \"$project_folder\", \"date\": \"$(date +"%Y-%m-%d %H:%M:%S")\", \"test\": \"$1\"}"

        # Sending cURL request with project information
        curl -X POST -H "Content-Type: application/json" -d "$curl_data" "$webhook_url"
    fi
}

# Function for rotational backup
rotate_backups() {
    # Listing the backup directory for taking the removing permission
    excess_backups=$(ls -t -d "$project_folder"-backup* 2>/dev/null | tail -n +$((rotation_days + rotation_weeks + rotation_months + 1)))

    # Check if there are excess backups before attempting removal
    if [ -n "$excess_backups" ]; then
        # Remove excess backups
        for backup_dir in $excess_backups; do
            rm -r "$backup_dir"
            echo "Removed old backup: $backup_dir" >> "$log_file"
        done
    else
        echo "No excess backups to remove." >> "$log_file"
    fi
}

# Function to add cron jobs
add_cron_jobs() {
    # Add cron job to run the script every 7 days
    if ! crontab -l | grep -q "0 3 */7 * * $PWD/script.sh"; then
        (crontab -l; echo "0 3 */7 * * $PWD/script.sh") | crontab -
        echo "Cron job added to run the script every 7 days."
    else
        echo "Cron job already exists for running the script every 7 days."
    fi

    # Add cron job to run the script every Sunday
    if ! crontab -l | grep -q "0 3 * * 0 $PWD/script.sh"; then
        (crontab -l; echo "0 3 * * 0 $PWD/script.sh") | crontab -
        echo "Cron job added to run the script every Sunday."
    else
        echo "Cron job already exists for running the script every Sunday."
    fi

    # Add cron job to run the script every 3 months
    if ! crontab -l | grep -q "0 3 1 1,4,7,10 * $PWD/script.sh"; then
        (crontab -l; echo "0 3 1 1,4,7,10 * $PWD/script.sh") | crontab -
        echo "Cron job added to run the script every 3 months."
    else
        echo "Cron job already exists for running the script every 3 months."
    fi
}

# Main script
echo "Starting automated backup and rotation..."

# Create backup Funtion
perform_backup

# Rotate backups Function
rotate_backups

# Add cron jobs Function
add_cron_jobs

echo "Backup and rotation completed successfully."