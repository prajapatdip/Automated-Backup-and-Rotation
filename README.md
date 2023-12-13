
# Automated Backup and Rotation Script

### Script to Perform Automated Backup and Rotation for a Project

This script automates the backup process for a project, creating a zip archive of the project's code files. The generated backup file is then uploaded to Google Drive for secure storage. The script follows a rotation strategy, removing older backups to optimize storage usage. Additionally, it keeps a log file to track the history of all backups.


## Features

#### 1. Backup Creation:
* The script generates a zip archive of the specified project folder.

#### 2.Google Drive Integration:

* Utilizing the rclone tool, the script uploads the backup file to a specified folder on Google Drive.

#### 3.Rotation Strategy:

* The script implements a rotational backup strategy, allowing customization through script arguments or variables.
* It preserves the last 'x' daily backups, the last 'x' weekly backups (on Sundays), and the last 'x' monthly backups.
* Older backups beyond the specified retention periods are deleted.

#### 4.Log File:

* The script maintains a log file with relevant information, including success/failure messages, timestamps, and details of removed backups.

### Usage:

* The script takes the project folder, rotation strategy parameters, Google Drive folder name, webhook URL, and log file path as configuration parameters.
* Upon execution, it performs the backup, rotates the backups, updates the log file, and sends a cURL request on success.

### Cron Jobs:

* Three cron jobs are added to the script for automated execution:
    * Run the script every 7 days.
    * Run the script every Sunday.
    * Run the script every 3 months.

### Script Customization:

Customize the backup frequency, retention periods, and other settings through script arguments or variables.

#### Note:

* Ensure the script is configured with accurate paths and variables.
* For Google Drive integration, replace the placeholder with the actual Google Drive folder name.
* Update the webhook URL for cURL requests with the specific endpoint.

This script provides an efficient and automated solution for project backup management, offering flexibility and robustness in maintaining essential data backups.
## Pre-Requisites

__1. Linux Environment:__
* The script is designed to run in a Linux environment. Make sure you are using a Linux distribution such as Ubuntu, CentOS, Debian, etc.

__2. Dependencies:__
* Install necessary dependencies, including zip, rclone, and curl. You can use package managers like apt or yum to install these dependencies.

For example, on Ubuntu:
```
    sudo apt-get update
    sudo apt-get install zip rclone curl
```

__3. Google Drive Configuration:__
* Configure rclone with your Google Drive credentials. Follow the official rclone documentation (`https://rclone.org/drive/`) for setting up Google Drive with rclone.

__4. Webhook URL:__
* Obtain a valid webhook URL to receive cURL requests. You can use services like webhook.site to generate a unique URL for testing purposes.

__5. Cron Job Permissions:__
* Ensure the user running the script has the necessary permissions to set up cron jobs. You may need to modify user permissions or run the script with appropriate privileges.

__6. Script Configuration:__
* Set up the script with accurate configuration parameters:
    *  `project_folder`: The path to the project folder to be backed up.
    * `rotation_days`, `rotation_weeks`, `rotation_months`: Backup rotation parameters.
    * `google_drive_folder`: The name of the Google Drive folder to store backups.
    * `webhook_url`: The URL for cURL requests.
    * `log_file`: The path to the log file.

__7. Cron Job Setupe:__
* The script relies on cron jobs for automated execution. If you haven't set up cron jobs before, familiarize yourself with how to edit the crontab file and add scheduled tasks.

## Script Execution Locally.

```
    git clone https://github.com/prajapatdip/Kubernetes-first.git
    cd Automated-Backup-and-Rotation
```

__Execution Permission:__

```
    chmod +x backup_rclone.sh
```

__Runnig the Script:__
```
    sh backup_rclone.sh
```