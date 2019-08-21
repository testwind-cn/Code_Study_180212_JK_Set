#!/bin/bash
installDir="/opt/cloudera"
installcmDir="/opt/cm-5.13.0"
echo "$installDir"
if [ -d "$installDir" ]
then
	echo "start remove the diretory $installDir"
	read -n1 -p "Do you want to continue [Y/N]?" answer
	case $answer in
	Y | y )
		rm -rf $installDir
		echo "removing has been done"
		;;
	N | n )
		echo "Don't remove this diretory";;
	* )
		echo "error choic";;
	esac
else
	echo "there is not this diretory $installDir"
fi

if [ -d "$installcmDir" ]
then
        echo "start remove the diretory $installcmDir"
        read -n1 -p "Do you want to continue [Y/N]?" answer
        case $answer in
        Y | y )
                rm -rf $installcmDir
                echo "removing has been done"
                ;;
        N | n )
                echo "Don't remove this diretory";;
        * )
                echo "error choic";;
        esac
else
        echo "there is not this diretory $installDir"
fi

if [ ! -d "/home/appadm/log" ]
then
	mkdir /home/appadm/log
fi

mysql -uroot -pRisk@2018 -e "source /home/appadm/dropTable.sql"
