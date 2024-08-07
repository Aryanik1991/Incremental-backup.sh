#!/bin/bash

#Get the path from the user
read -ep "Please enter a path to backup: " newpath
function back {
cat <<EOF
        $0 <path> --> path is required to create backup
EOF
}

if [ ${#newpath} -lt 1 ]; then
        back
        exit 1
fi
path=$(realpath $newpath)
echo $path
#Check the path
if [ ! -e $path ]; then
        echo "Error: $path does not exist"
        exit 1
elif [ ! -d $path ]; then
         echo "Error: $path is not a directory"
         exit 1
 fi
 #Check AWS CLI command
if ! command -v aws cli &>>/dev/null; then
        echo "AWS CLI is not install. Pleas install it."
        exit 1
fi

 #Define backup file name, compress it, and update snapshot file
 backup_new="$(dirname $path)/backup_$(basename $path)_$(date +%Y%m%d%H%M%S).tar.gz"
 backup_snap="$(dirname $path)/backup_$(basename $path).snap"
 tar -czf $backup_new --listed-incremental=$backup_snap -C $(dirname $path) $(basename $path)
 if [ $? -eq 0 ]; then
         echo "backup file created"
 else
         echo "backup file can not created"
         exit 1
fi
 #Define S3 bucket, Upload backup file, and snapshot file to the s3 bucket
s3_bucket="backuplogarya"
aws s3 cp $backup_new s3://$s3_bucket &>>/dev/null
aws s3 cp $backup_snap s3://$s3_bucket &>>/dev/null
if [ $? -eq 0 ]; then
        echo "Upload backup to s3://$s3_bucket/ completed"
else
        echo "Error: Upload backup failed to s3"
        exit 1
fi
#Delete local backup file
rm -rf $backup_new

if [ $? -eq 0 ]; then
        echo "Local backup file deleted"
else
        echo " Failed to delete local backup file"
fi
