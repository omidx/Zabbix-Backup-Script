# Zabbix-Backup-Script
Zabbix backup script: A bash script to compress and backup a complete Zabbix database &amp; Files.

#### Usage ####

1) Change the variables below to suit your environment (Line 8 - 10):
```bash
    $ ZBX_FOLDER=""      # Folder where your Zabbix root installation is
    $ BACKUP_FOLDER=""   # Folder where you want to store the backups
    $ EMAIL=""           # Email ID where you want to receive a confirmation email

2) make the script executable and run it.
```bash
    $ chmod a+x zabbix-backup.sh
    $ ./zabbix-backup.sh
