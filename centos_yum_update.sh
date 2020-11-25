#!/bin/bash

echo 'Start updating...'
date=`date +%F`
log_file="/var/log/reposync/reposync_$date.log"

exec > $log_file
echo "`date +%F_%T` started reposync -np"

reposync -np /mirror --allow-path-traversal

if [ $? -eq 0 ];then

for element in `ls -F /mirror | grep '/$'` # only list folder
do
	if ! [[ $element =~ script ]];then # exclude script folder
        
	dir_or_file="/mirror/"$element
	DATETIME=`date +%F_%T`

	echo -e "\n$DATETIME updating: $dir_or_file" # echo in a new line
        createrepo -po $dir_or_file $dir_or_file
        createrepo --update $dir_or_file
        
	fi
done

DATETIME=`date +%F_%T`
echo "SUCESS: $DATETIME yum update successful"
cat $log_file | mail -s "RepoSync succeeded $date" billy.zhou@csisolar.com

else

echo "ERROR: $DATETIME yum update failed"
cat $log_file | mail -s "Reposync failed $date" billy.zhou@csisolar.com

fi

