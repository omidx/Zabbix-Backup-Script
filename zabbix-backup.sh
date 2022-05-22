#!/usr/bin/env bash
# zabbix-backup.sh - Creates a complete, compressed backup of your Zabbix database and files.

# Author: Omid Samir | Twitter: @omidsx | GitHub: https://github.com/omidx | Website: https://www.omidx.com
# Dependencies: mailutils

# 0. Change the variables below to suit your environment
ZBX_FOLDER="/usr/share/zabbix"  # Folder where your Zabbix root installation is
BACKUP_FOLDER="/home/omidx/back"   # Folder where you want to store the backups
EMAIL="user@domain.com"      # Email ID where you want to receive a confirmation email
DATE=$(date +%Y-%m-%d)
LOG="${BACKUP_FOLDER}/logs/ZBX-backup.log"

echo "Zabbix Backup Log ${DATE}" > ${LOG}
echo "" >> ${LOG}

if [ -z ${ZBX_FOLDER} ] || [ -z ${BACKUP_FOLDER} ]; then
	echo "Cannot find ${ZBX_Folder} and/or ${BACKUP_FOLDER}" >> ${LOG}
	exit 1
fi
 
# 1. Check if Zabbix Config is a valid Zabbix installation
ZBX_CONFIG="/etc/zabbix/zabbix_server.conf"
 
if ! test -f ${ZBX_CONFIG}; then 
	echo "ERROR: Cannot detect Zabbix installation here... Exiting" >> ${LOG}
	exit 1
fi
 
# 2. Get the Zabbix database  information
DB_NAME=$(grep -E "^define\('DBName'" ${ZBX_CONFIG} | cut -d"'" -f4)
DB_USER=$(grep -E "^define\('DBUser'" ${ZBX_CONFIG} | cut -d"'" -f4)
DB_PASSWORD=$(grep -E "^define\('DBPassword'" ${ZBX_CONFIG} | cut -d"'" -f4)
DB_HOST=$(grep -E "^define\('DBHost'" ${ZBX_CONFIG} | cut -d"'" -f4)
 
# 3. Compress and backup the  Zabbix DB and the complete website files
mysqldump -u${DB_USER} -p${DB_PASSWORD} --databases ${DB_NAME} | gzip > ${BACKUP_FOLDER}/ZBX_db-${DATE}.gz;
 
if [ $? -ne 0 ]; then
	echo "ERROR: Couldn't dump your Zabbix database. Check your ZBX-config credentials and permissions" >> ${LOG}
	exit 1
fi
 
tar -zcf ${BACKUP_FOLDER}/ZBX_files-${DATE}.tar.gz  ${ZBX_FOLDER}/  >/dev/null 2>&1
 
if [ $? -ne 0 ]; then
	echo "ERROR: Couldn't backup your Zabbix directory..." >> ${LOG}
	exit 1
fi

echo "Website Backup Completed Successfully" >> ${LOG}
echo "" >> ${LOG}
echo "Zabbix site file list with size (depth=2): \n" >> ${LOG}
echo "$(du -h --max-depth 2 ${ZBX_FOLDER})" >> ${LOG}
echo "" >> ${LOG}
echo "Backup file information: \n" >> ${LOG}
echo "$(du -h ${BACKUP_FOLDER})" >> ${LOG}
echo "" >> ${LOG}

# email log
cat ${LOG} # | mail -s "Zabbix website Backup Successful" ${EMAIL}
