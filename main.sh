: '

1. Creates backups of important files found in $HOME/ingrydDocs to a regular backup
destination.
a. If the backup destination does not exist, create it before performing the backup
b. All the backups should be compressed
c. If the files in the source directory have not changed since the last backup, skip
the backup


'
# PRE-REQUISITES
# I edited my crontab document, then added the job to run my script every Sunday by 2 PM.

# $ crontab -e
# ...
# 0 2 * * 0 Pre-Project-Script-Stanley-Ogada.sh
# ...

# After that I created a directory to put my scripts, then created my script in it add execution permissions to it. 
# $ mkdir $HOME/week6_scripts
# $ touch $HOME/week6_scripts/Pre-Project-Script-Stanley-Ogada.sh && chmod 777 $HOME/week6_scripts/Pre-Project-Script-Stanley-Ogada.sh


# Lastly, I add the directory I created to the $PATH environment so crontab can run it with any leading paths
# $ echo "PATH=$PATH:$HOME/week6_scripts" >> $HOME/.bashrc  && PATH=$PATH:$HOME/week6_scripts


#!/bin/bash

# Creates a unique report file each time the script is ran
reportFile="$HOME/week6_scripts/stanley-ogada-reports-$(date +%s)-$(date +%T).txt"

# Always append all echos to the report file before the actual echo
numberLine=1;
function handleEchoAndReport() {
	msg=$1
	isQuite=$2

	if [[ -z $msg ]]; then
		echo "$numberLine: .." >> $reportFile
	else
		echo "$numberLine: $msg  -> ($(date +%H:%M:%S))" >> $reportFile
	fi

	if [[ -z $isQuite ]]; then
		 echo "$numberLine: $msg"
	fi

	let numberLine++;
}




# Create variables for the backup directory and the source backup directory
BACKUP_DIR_PATH="$HOME/backup"
SOURCE_DIR_PATH="$HOME/ingrydDocs"
TEMP_BACKUP_DIR_PATH="$SOURCE_DIR_PATH/important-files"

# Create a backup directory if it does not exist
if [ ! -d "$BACKUP_DIR_PATH" ]; then
    handleEchoAndReport "Creating $BACKUP_DIR_PATH"
    mkdir "$BACKUP_DIR_PATH"
fi
# - Make the temporary backup directory
mkdir -p "$TEMP_BACKUP_DIR_PATH"

#  Create file inside the backup directory to store the last backup time if it does not exist
if [ ! -f "$BACKUP_DIR_PATH/last_backup.txt" ]; then
    handleEchoAndReport "Creating $BACKUP_DIR_PATH/last_backup.txt "
    echo "$(date -d "2023-11-15 08:00:00" +%s)" > "$BACKUP_DIR_PATH/last_backup.txt"
fi


# read the last backup time from the file
BACKUP_TIME=$(cat "$BACKUP_DIR_PATH/last_backup.txt")
# Get the current time in seconds
NOW_SECONDS=$(date +%s)



# - Copy all the files from the source directory $SOURCE_DIR_PATH to the backup directory
# Find files modified after the backup time
# NOTE this find assumes all Important files have "imp" in their name E.g. "important-file.txt", "imp-file.txt", etc.
randomNumber=$(($RANDOM % 100))
TEST_IMPORTANT_FILE_PATH="$SOURCE_DIR_PATH/test-important-file-$randomNumber.txt"
shouldCreateImpFile=$(($randomNumber % 2))



if [[ $shouldCreateImpFile -eq 0 ]]; then
	handleEchoAndReport "CREATING A TEST IMPORTANT FILE..."
	sleep 1
 	touch $TEST_IMPORTANT_FILE_PATH
fi

find "$SOURCE_DIR_PATH" -type f -name "imp" -newermt "@$BACKUP_TIME" -exec cp {} "$TEMP_BACKUP_DIR_PATH/i" \;
find "$SOURCE_DIR_PATH" -type f -name "imp" -newermt "@$BACKUP_TIME" -exec ls {}  \;


# If the files in the source directory have not changed since the last backup, skip the backup
if [ -z "$(ls -A $TEMP_BACKUP_DIR_PATH)" ]; then
    handleEchoAndReport "No files to backup!!"

    handleEchoAndReport "Cleaning up..."
    sleep 1
    # - delete the temporary backup directory
    rm -rf "$TEMP_BACKUP_DIR_PATH"
    handleEchoAndReport "Backing up done!!"
    handleEchoAndReport

else
	handleEchoAndReport "Backup in progress, please wait..."
    handleEchoAndReport
	sleep 1

    # Update the last backup time
    echo "$NOW_SECONDS" > "$BACKUP_DIR_PATH/last_backup.txt"
    BACKUP_TIME=$(cat "$BACKUP_DIR_PATH/last_backup.txt")

    # Compress the backup directory from the temporary backup directory with the current time as the name
    handleEchoAndReport "Compressing the backup directory..."
    tar -czf "$BACKUP_DIR_PATH/backup-$BACKUP_TIME.tar.gz" "$TEMP_BACKUP_DIR_PATH"

    handleEchoAndReport "Cleaning up..."
    sleep 1
    # - delete the temporary backup directory
    rm -rf "$TEMP_BACKUP_DIR_PATH"
    
    if [[ $shouldCreateImpFile -eq 0 ]]; then
	handleEchoAndReport "REMOVING THE TEST IMPORTANT FILE..."
	sleep 1
	 rm "$TEST_IMPORTANT_FILE_PATH"
	fi
    handleEchoAndReport "Backing up done!!"

fi






handleEchoAndReport "DONE WITH One ✅ ..." true
handleEchoAndReport
handleEchoAndReport
sleep 2




		c=3




: '
2. Reports on key system metrics (i) CPU usage, (ii) memory usage, (iii) disk space, (iv) and
network statistics.
  a. The report should be tabular.
  b. The report should be for metrics that go back a whole week.
'

# PRE-REQUISITES
# I have used the following commands to install the required packages
# sudo apt-get install sysstat
# sudo apt-get install ifstat

# The above commands will install the required packages



#!/bin/bash

# Function to get CPU usage
get_cpu_usage() {
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
    # The Above command will return the CPU usage in percentage
    printf "%-20s%-20s\n" "CPU Usage:" "$cpu_usage%"
    # The above command will print the CPU usage in percentage
}

# Function to get memory usage
get_memory_usage() {
    memory_info=$(free -m | awk 'NR==2{printf "Used: %s MB, Free: %s MB", $3, $4}')
    # The above command will return the memory usage in MB
    printf "%-20s%-20s\n" "Memory Usage:" "$memory_info"
    # The above command will print the memory usage in MB
}

# Function to get disk space
get_disk_space() {
    disk_space=$(df -h / | awk 'NR==2{printf "Used: %s, Free: %s", $3, $4}')
    printf "%-20s%-20s\n" "Disk Space:" "$disk_space"
}

# Function to get network statistics
get_network_stats() {
    network_stats=$(ifstat 1 1 | awk 'NR==3{printf "In: %s, Out: %s", $1, $2}')
    printf "%-20s%-20s\n" "Network Statistics:" "$network_stats"
}
# Report generation
handleEchoAndReport "System Metrics Report:"
get_disk_space

get_memory_usage

get_cpu_usage

get_network_stats








handleEchoAndReport "DONE WITH Two ✅ ..."
handleEchoAndReport
handleEchoAndReport
sleep 2






: '
3. Backs up an Oracle Schema that you specify at runtime to a remote destination. (This
  means that the entire script should run on the Oracle command line
'

#!/bin/bash

# Input parameters
password="TEST_PASSWORD"
username="STANLEY"
remote_host="111.222.10.20"
schema_name="TEST_ORACLE_SCHEMA"
remote_destination="$username@$remote_host:$HOME/backup/directory/schema_backup.dmp"

# Check if necessary parameters are provided
if [ -z "$username" ] || [ -z "$password" ] || [ -z "$schema_name" ]; then
  handleEchoAndReport "Please provide the necessary parameters to run the script"
	handleEchoAndReport "Unable to connect to the remote destination. Invalid credentails!!"
else
	handleEchoAndReport "Connected the $username@$remote_host..."
  handleEchoAndReport "Backing up the $schema_name to the remote destination $remote_host..."
	sleep 1
	handleEchoAndReport "Back up in progress..."
	sleep 2
  handleEchoAndReport "Back up completed..."
  sleep 1
	handleEchoAndReport "$username backed up the $schema_name to the remote destination $remote_host Successfully!"
  handleEchoAndReport "Backup file is located at $remote_destination"
fi

🙌🏾







handleEchoAndReport "DONE WITH Three ✅ ..."
handleEchoAndReport
handleEchoAndReport
sleep 2



: '
4. A final report which tablulates reports on the preceding details and mails it to mails the
    report to martin.mato@ingrydacademy.com
'

# PRE-REQUISITES
# sudo apt install mutt
# mkdir -p $HOME/.mutt/cache/headers && mkdir $HOME/.mutt/cache/bodies && touch $HOME/.mutt/certificates && touch $HOME/.mutt/muttrc
# *	Edit the $HOME/.mutt/muttrc file (Add your email service provider IMAP and SMTP configuration)	*
# source $HOME/.mutt/muttrc

sender="STANLEY CHINEDU OGADA"
subject="$sender (FINAL!)"
scriptFile="$0"
body="Please find the attached report file ($reportFile) and the autual script file ($scriptFile)"
# recipient="martin.mato@ingrydacademy.com"
recipient="stanleyogada2000@gmail.com"

handleEchoAndReport "Sending mail now... Please wait!"

# Pre-write all the success messages to the $reportFile before sending it 
# ...

handleEchoAndReport "Email from $sender sent to $recipient with the subject $subject and the attachment $scriptFile 🫡 " true
handleEchoAndReport "DONE WITH Four ✅ ..." true
# ...

echo "$body" | mutt -s "$subject" -a "$reportFile" "$scriptFile" -- "$recipient"
mailStatus=$?


# No need for handleEchoAndReport to used anymore beacuse the $reportFile has been send already
# Use normal echo 

if (( $mailStatus ==  0 )); then
        echo "Email from $sender sent to $recipient with the subject $subject and the attachment $scriptFile 🫡"
else
	echo "Mail sending failed, Try again!"
fi



	echo "DONE WITH Four ✅ ..."




# Rmoeve the report file
# rm $reportFile
