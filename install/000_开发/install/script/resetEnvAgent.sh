#!/bin/bash
installDir="/opt/cloudera"
installcmDir="/opt/cm-5.13.0"
echo "$installDir"
if [ -d "$installDir" ]
then
	echo "start remove the diretory $installDir"
	rm -rf $installDir
	echo "removing has been done"
else
	echo "there is not this diretory $installDir"
fi

if [ -d "$installcmDir" ]
then
        echo "start remove the diretory $installcmDir"
	rm -rf $installcmDir
	echo "removing has been done"
else
        echo "there is not this diretory $installDir"
fi
