#!/bin/bash
#
# update permissions and/or create required storage directories
#
#

if [ $# -ne 1 ]
then
    echo "Usage is: $0: <entrada storage directory path>"
    echo " example: $0 /mnt/c/development/comit/entrada/entrada-1x-me/www-root/core/storage"
    exit 1
fi


while read DIR_NAME
do
    FULL_DIR=$1$DIR_NAME
    if [ ! -d "$FULL_DIR" ]; then
        # create the directory, it doesn't exist
        mkdir $FULL_DIR
    fi
    # make sure the permissions are right
    chmod -R 777 $FULL_DIR
done < storage_directories.txt

# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/annualreports
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/app
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/app/public
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/cache
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/community-discussions
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/community-galleries
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/community-shares
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/eportfolio
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/event-files
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/exam-files
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/framework
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/framework/cache
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/framework/cache/data
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/framework/sessions
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/framework/views
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/logs
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/lor
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/msprs
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/resource-images
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/secure-access
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/syllabi
# chmod -R 777 /mnt/c/development/comit/entrada/medlearn-1x-me/www-root/core/storage/user-photos
