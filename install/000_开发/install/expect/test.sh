#!/bin/bash

master_host=`awk -F " " 'NR==1{print $2}' conf/hosts.cfg`
var_hosts=`awk -F " " '{print $2}' conf/hosts.cfg`

for domain in $var_hosts ; do
if test $master_host != $domain 
then 
    echo "good" 
else 
    echo "bad" 
fi
done


num1="ru1noob"
num2="runoob"
if test $num1 = $num2
then
    echo '两个字符串相等!'
else
    echo '两个字符串不相等!'
fi
