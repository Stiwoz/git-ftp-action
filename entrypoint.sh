#!/bin/sh -l

#set -e at the top of your script will make the script exit with an error whenever an error occurs (and is not explicitly handled)
set -eu

TEMP_SSH_PRIVATE_KEY_FILE='../private_key.pem'
TEMP_SFTP_FILE='../sftp'

# keep string format
printf "%s" "$4" >$TEMP_SSH_PRIVATE_KEY_FILE
# avoid missing permissions error to open
chmod 600 $TEMP_SSH_PRIVATE_KEY_FILE

echo '🏎 Deploying in batch to sftp'
# create a temporary file containing sftp commands
printf "%s" "put -r $5 $6" >$TEMP_SFTP_FILE
#-o StrictHostKeyChecking=no avoid Host key verification failed.
sftp -vvvv -b $TEMP_SFTP_FILE -P $3 $7 -o StrictHostKeyChecking=no -i $TEMP_SSH_PRIVATE_KEY_FILE $1@$2

echo '🏁 Deployment successful'
exit 0
