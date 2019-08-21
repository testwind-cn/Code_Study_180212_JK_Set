#!/bin/bash

# 提供用户交互行 选择是否继续
function continuefunc()
{
	read -p "是否继续：(y:继续，n:退出):"  continue
    case $continue in
    Y|y)
            echo " continue ...."
    ;;
    N|n)
            echo "exit ..."
            exit 1
    ;;
    *)
            echo "内容不匹配"
            continuefunc
    ;;
    esac
}


# 分发/etc/hosts
function scphostnamefuc()
{
    scp /etc/hosts $1:/etc/hosts
}

# 分发/etc/ntp.conf
function scpntpconffuc()
{
    ssh $1 "systemctl start ntpd.service"
    echo $?
    if [ $? -ne 0 ]; then
        ssh $1 "yum install -y ntp"
        ssh $1 "chkconfig ntpd on"
        scp conf/ntp.conf $1://etc/ntp.conf
        ssh $1 "systemctl start ntpd.service"
    else
        scp conf/ntp.conf $1://etc/ntp.conf
    fi
}

function checkntpstatus()
{
   echo "---------------------------------------"
   echo $1 "checkntpstatus"
   ssh $1 "date '+%Y-%m-%d %H:%M:%S'"

}


# 提供用户交互行 选择是否删除数据库继续
function drop_db_func()
{

	read -p "是否删除数据库继续：(Y|y: 删除数据库，N|n: 不删除数据库):"  continue
    case $continue in
    Y|y)
            echo " drop database  ...."
            mysql -uroot -p$1 < dbscript/droptable.sql
    ;;
    N|n)
            echo "Don't drop database  ..."

    ;;
    *)
            echo "内容不匹配"
            drop_db_func
    ;;
    esac
}

function create_db_func()
{
    mysql -uroot -p$1 < dbscript/createtable.sql

    systemctl restart mysqld
}


# 安装cm
function install_cm_func()
{
    rm -rf /opt/cm-5.13.0
    tar -zxvf soft/cloudera-manager-centos7-cm5.13.0_x86_64.tar.gz -C /opt/
#    ls /opt/
}


#安装Java环境配置
function install_java_func()
{
    tar -zxvf soft/jdk-8u144-linux-x64.tar.gz -C /opt/
#    rm -rf /opt/java
    rm -rf /usr/java
#    mkdir -p /opt/java
    mkdir -p /usr/java
    cp /opt/jdk* /usr/java/

    javahome=`awk '/JAVA_HOME=/{print}' /etc/profile`

    if [ -z "$javahome" ]; then
        #失败
        echo "JAVA_HOME没有配置"

        echo "## set java env ##" >>  /etc/profile
        echo "JAVA_HOME=/usr/java/jdk1.8.0_144" >>  /etc/profile
        echo "export JAVA_HOME" >>  /etc/profile
        source /etc/profile
        echo "export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar" >>  /etc/profile
        echo "PATH=$JAVA_HOME/bin:$PATH" >>  /etc/profile
        echo "export PATH" >>  /etc/profile
        source /etc/profile
    else
        #成功
        echo "JAVA_HOME已经配置"
    fi

}


# 分发/etc/profile
function scp_profile_fuc()
{
    scp /etc/profile $1:/etc/profile
    ssh $1 "source /etc/profile"

}

# 分发java安装文件
function ssh_java_func()
{
    ssh $1 "rm -rf /usr/java"
    ssh $1 "mkdir -p /usr/java"
    scp -r /opt/jdk* $1:/usr/java/
}


function delete_java_env_func()
{
     name=`echo $1 | awk '/openjdk/{print $1}'`
     echo $name

     echo "delete_java_env_func"

     if [ -n "$name" ];then
        rpm -e $name --nodeps
        echo "rpm -e $name --nodeps;" >> log/deletejavaenv.log
        echo "-n $name"
    fi
}

function ssh_delete_java_env_remote()
{
    remetenode=$1
#    deletescripts=`awk -F ";" '{print}' log/deletejavaenv.log`
#    echo $deletescripts
#    for script in $deletescripts ; do
#        echo "ssh $remetenode $script"
##        ssh $remetenode "$script"
#    done
    cat log/deletejavaenv.log | while read script
    do
        echo \"$script\"
        echo "ssh $remetenode \"$script\"" >> script/ssh_delete_java_env_remote.sh
#        ssh $remetenode \"$script\"
    done
}


function install_mysql_driver_func()
{
    tar -zvxf soft/mysql-connector-java-5.1.44.tar.gz -C soft/mysql-connector/
    cp soft/mysql-connector/mysql-connector-java-5.1.44/mysql-connector-java-5.1.44-bin.jar /opt/cm-5.13.0/share/cmf/lib/
    cp soft/mysql-connector/mysql-connector-java-5.1.44/mysql-connector-java-5.1.44-bin.jar	/usr/share/java/
    cp soft/mysql-connector/mysql-connector-java-5.1.44/mysql-connector-java-5.1.44-bin.jar $JAVA_HOME/jre/lib/ext

#check
    ls  /opt/cm-5.13.0/share/cmf/lib/ | grep mysql-connector-java*
    ls  /usr/share/java/ | grep mysql-connector-java*
    ls  $JAVA_HOME/jre/lib/ext | grep mysql-connector-java*
}

function scp_mysql_driver_func() {
     scp -r /opt/cm-5.13.0/share/cmf/lib/ $1:/opt/cm-5.13.0/share/cmf/
     scp -r /usr/share/java/ $1:/usr/share/
     scp -r $JAVA_HOME/jre/lib/ext $1:/$JAVA_HOME/jre/lib/
}

function ssh_disable_firewalld() {

    ssh $1 "systemctl stop firewalld.service"
    ssh $1 "systemctl disable firewalld.service"
    ssh $1 "firewall-cmd --state"
    ssh $1 "sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config"

}


function generator_reboot_remote() {
    echo "ssh $1 \"reboot\"" >> script/ssh_reboot_remote.sh
}

function generator_scm_start() {
     echo "ssh $1  \"/opt/cm-5.13.0/etc/init.d/cloudera-scm-agent start\"" >> script/ssh_scm_start.sh
}

function generator_scm_stop() {
     echo "ssh $1 \"/opt/cm-5.13.0/etc/init.d/cloudera-scm-agent stop\"" >> script/ssh_scm_stop.sh
}
