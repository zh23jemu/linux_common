#!/bin/bash

echo 'Updating Aliyum/Zabbix/OCS Source'
DATETIME=`date +%F_%T`

#exec > /var/log/reposync_$DATETIME.log
echo "START: $DATETIME started"

reposync -np /mirror

if [ $? -eq 0 ];then

for element in `ls -F /mirror | grep '/$'` # only list folder
do
	if ! [[ $element =~ script ]];then # exclude script folder
        
	dir_or_file="/mirror/"$element
	DATETIME=`date +%F_%T`

	echo -e "\n$DATETIME Updating: $dir_or_file" # echo in a new line
        createrepo --update $dir_or_file
        
	fi
done

DATETIME=`date +%F_%T`
echo "SUCESS: $DATETIME yum update successful"

else

echo "ERROR: $DATETIME yum update failed"

fi
