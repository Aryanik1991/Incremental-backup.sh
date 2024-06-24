## My Project
This script is an extension of the first task (cloud-backup.sh), which focuses on incremental backup. Incremental backup is a type of data backup strategy that focuses on saving only the data that has changed since the last backup operation, whether it was a full, differential, or previous incremental backup. This method is designed to be efficient in terms of time and storage space, making it an attractive option for organizations and individuals who need to regularly update their backup sets without the overhead of repeatedly copying all data.
## How can you use the project

 * First you have to create a bucket in AWS S3, create a user and assign the AmazonS3FullAccess policy to the user.
 * You need generate a Key for the user, then you have Access Key ID and Secret Access Key.
 * Open terminal on your system and add that key with ‘AWS configure’.
 * Enter the path, the script check snapshot file if some file modify then it take backup that changed from last backup, and updatet snapshot file.
 * You can use cron to run your backup script at specific intervals, such as daily or hourly.
