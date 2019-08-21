#!/bin/bash

#---------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------- step 0 ---------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------

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
echo "">/etc/hosts

# 把配置文件中的hosts写到/etc/hosts中
while read line
do
    echo $line
    echo $line >> /etc/hosts
done < /opt/install/conf/hosts

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

#分发hosts配置文件
for domain in $var_hosts ; do
    scphostnamefuc $domain
done

#分发ntp配置文件
for domain in $var_hosts ; do
    scpntpconffuc $domain
done

#检查各个节点的ntp服务状态
for domain in $var_hosts ; do
    checkntpstatus $domain
done
echo "---------------------------------------"

#所有节点关闭防火墙和selinux（重启生效)
for domain in $var_hosts ; do
    ssh_disable_firewalld $domain
done


rpm -qa | grep mariadb > log/mysqlenv.log
while read mysqlline
do
    echo $mysqlline
    rpm -e $mysqlline --nodeps
done < log/mysqlenv.log

systemctl status mysqld
if [ $? -ne 0 ]; then
    #失败
    echo "mysqld 服务没有安装！！！"
    mkdir -p soft/mysql/
    tar -xvf soft/mysql-5.7.23-1.el7.x86_64.rpm-bundle.tar -C soft/mysql/

    rpm -ivh soft/mysql/mysql-community-common-5.7.23-1.el7.x86_64.rpm
    rpm -ivh soft/mysql/mysql-community-libs-5.7.23-1.el7.x86_64.rpm
    rpm -ivh soft/mysql/mysql-community-client-5.7.23-1.el7.x86_64.rpm
    rpm -ivh soft/mysql/mysql-community-server-5.7.23-1.el7.x86_64.rpm

fi

systemctl start mysqld

if [ $? -ne 0 ]; then
    #失败
    echo "mysql 服务启动失败"
else
    #成功
    echo "mysql 服务已经启动成功"
fi


mysqltemppasswds=`awk '/root@localhost/{print}' /var/log/mysqld.log | cut -d ' ' -f 11`

echo $mysqltemppasswds

echo "SET PASSWORD  = PASSWORD($dbpwd);" | mysql -u root --password=$mysqltemppasswds -b --connect-expired-password

mysql -uroot -p$dbpwd < dbscript/mysql.sql

drop_db_func $dbpwd

create_db_func $dbpwd


#安装各个节点的java环境
rpm -qa | grep java > log/javaenv.log
pwd
while read jline
do
    echo $jline
    delete_java_env_func $jline
done < log/javaenv.log

rm -f script/ssh_delete_java_env_remote.sh
echo"#!/bin/bash" >> script/ssh_delete_java_env_remote.sh

for domain in $var_hosts ; do
    echo "ssh_delete_java_env_remote 1"

    ssh_delete_java_env_remote $domain
    echo "ssh_delete_java_env_remote 2"
done

sh script/ssh_delete_java_env_remote.sh

install_java_func

#todo 添加 ln -s /opt/java /usr/java

##配置各个节点的profile和分发java安装目录
for domain in $var_hosts ; do
    ssh_java_func $domain
    scp_profile_fuc $domain
done


master_host=`awk -F " " 'NR==1{print $2}' conf/hosts.cfg`

rm -f script/ssh_reboot_remote.sh
rm -f script/ssh_scm_start.sh
rm -f script/ssh_scm_stop.sh

echo "ssh $master_host\"/opt/cm-5.13.0/etc/init.d/cloudera-scm-server start\"" >> script/ssh_scm_start.sh

for domain in $var_hosts ; do
    generator_reboot_remote $domain
    generator_scm_start $domain
    generator_scm_stop $domain
done

echo "ssh $master_host\"/opt/cm-5.13.0/etc/init.d/cloudera-scm-server stop\"" >> script/ssh_scm_stop.sh

sh script/ssh_reboot_remote.sh