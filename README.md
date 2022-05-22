# Zabbix-Backup-Script
Zabbix backup script: A bash script to compress and backup a complete Zabbix database &amp; Files.

# backup_Zabbix_MySQL
Scripts to backup a zabbix application database that uses MySQL (tested using MariaDB).

This script (by default) creates a **.sql** file using **mysqldump** containing the backup of the zabbix database, which contains configuration data and item history.

Then, the script uses *tar* and *bzip2* to compress the database dump.

#### Usage ####

1) Change the variables below to suit your environment (Line 8 - 10):
    $ ZBX_FOLDER=""      # Folder where your Zabbix root installation is
    $ BACKUP_FOLDER=""   # Folder where you want to store the backups
    $ EMAIL=""           # Email ID where you want to receive a confirmation email

2) make the script executable and run it.
    $ chmod a+x zabbix-backup.sh
    $ ./zabbix-backup.sh
