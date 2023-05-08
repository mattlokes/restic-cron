#!/bin/bash

# Mandatory Env Variables
# [ARG_BACKUP_DIR]     - Directory to backup to Restic Repo
# [ARG_BACKUP_REPO]    - Restic Repo
# [ARG_BACKUP_PASSWD]  - Restic Repo Password
# [ARG_BACKUP_CRONTAB] - Crontab to run backup on 
if [ -z "$ARG_BACKUP_DIR" ]; then echo "Error: ARG_BACKUP_DIR must be set!!" && exit 0; fi
if [ -z "$ARG_BACKUP_REPO" ]; then echo "Error: ARG_BACKUP_REPO must be set!!" && exit 0; fi
if [ -z "$ARG_BACKUP_PASSWD" ]; then echo "Error: ARG_BACKUP_PASSWD must be set!!" && exit 0; fi
if [ -z "$ARG_BACKUP_CRONTAB" ]; then echo "Error: ARG_BACKUP_CRONTAB must be set!!" && exit 0; fi

# Optional Env Variables
# [ARG_BACKUP_OPTS]     - Restic Options
# [ARG_BACKUP_HOSTNAME] - Hostname to use for the backup
if [ ! -z "$ARG_BACKUP_HOSTNAME" ]; then ARG_BACKUP_HOSTNAME_OPT="-H $ARG_BACKUP_HOSTNAME"; fi

# Check ARG_BACKUP_DIR path exists and is directory
if [ ! -d "$ARG_BACKUP_DIR" ]; then echo "Error: ARG_BACKUP_DIR: $ARG_BACKUP_DIR is not mounted have you bind mounted properly?!!" && exit 0; fi

# Create passwd.f
echo "$ARG_BACKUP_PASSWD" > passwd.f

# Create job.sh
echo '#!/bin/bash' > job.sh
echo "/bin/restic $ARG_BACKUP_HOSTNAME_OPT -p passwd.f -r $ARG_BACKUP_REPO --verbose backup $ARG_BACKUP_DIR" >> job.sh
chmod +x job.sh

# Create crontab file and load
echo "$ARG_BACKUP_CRONTAB /usr/scheduler/job.sh | tee -a /var/log/cron.log" > crontab.f

# Start cron
echo "Starting restic-cron..."
echo "crontab: $ARG_BACKUP_CRONTAB"
echo "job.sh:"
cat job.sh

crontab crontab.f
crond -f
