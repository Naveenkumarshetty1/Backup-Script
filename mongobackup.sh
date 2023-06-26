#!/bin/bash

#Executing this command will lock writes writes on server.
#Write lock will be releases at the end of the script after completing backup process.

#mongo admin --eval "printjson(db.fsyncLock())"


#Paths And Credentials

MONGODUMP_PATH="/usr/bin/mongodump"
MONGO_HOST="127.0.0.1" # Always replace with your server ip
MONGO_PORT="27017"
S3_BUCKET_NAME="inventorydigi-backup" #replace with your bucket name on Amzon S3
backup_location="/mnt/inventory/mongobackups/"
backup_name="digi-Inventory"
TODAY=$(date "+%Y-%m-%d")
#ATABASE="admin"
#Backup Process
cd $backup_location
#$MONGODUMP_PATH  --host $MONGO_HOST --out $backup_name-$TODAY
$MONGODUMP_PATH  --host $MONGO_HOST -u 'digiroot' -p 'digiR00t'  --out $backup_name-$TODAY
tar cfz $backup_name-$TODAY.tar.gz $backup_name-$TODAY

CompletedTime=$(date +%Y-%m-%d" "%H:%M:%S)
echo $CompletedTime
#Unlock database writes
#mongo admin --eval "printjson(db.fsyncUnlock())"

rm -rf $backup_name-$TODAY

# Upload to S3
s3cmd put /$backup_location/$backup_name-$TODAY.tar.gz s3://$S3_BUCKET_NAME/ &&  echo "Successfully completed full backup from 10.30.4.208 on $TODAY Please find Backups at $S3_BUCKET_NAME bucket" | mail -s "digi-Inventory full backup"  backups@xcubelabs.com
rm -rf $backup_name-$TODAY.tar.gz
"mongobackup.sh" 34L, 1278C                                                                                                 34,1          All

