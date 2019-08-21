#!/bin/bash
dbpwd=Risk@2018
#载入外部函数
. ./fuctions.sh
echo ""
echo ""
echo "----------------------------------------"
echo "|           cdh 自动化安装程序         |"
echo "----------------------------------------"
echo ""
echo ""
echo "hosts 配置内容如下是否要写入/etc/hosts 中: "
echo ""
echo "----------------------------------------------------------------"
while read line
do
        echo $line
done < /opt/install/conf/hosts

echo "----------------------------------------------------------------"
echo ""
echo ""

continuefunc

# 清空/etc/hosts

# 把配置文件中的hosts写到/etc/hosts中

expect auto_keygen.exp

# 获取配置文件中的密码
passwds=`awk -F " " '{print $3}' conf/hosts.cfg`

# 获取配置文件中的主机
var_hosts=`awk -F " " '{print $2}' conf/hosts.cfg`

# 配置需求ssh免密
for domain in $var_hosts ; do
    echo $domain
    echo $passwds
    expect ssh-copy-id.exp $domain $passwds
done

