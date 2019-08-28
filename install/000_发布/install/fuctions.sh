#!/bin/bash


# 提供用户交互行 选择是否继续
function func_continue()
{
    read -p "是否继续：(y:继续，n:退出):"  continue
    case ${continue} in
        Y|y)
            echo " continue ..."
        ;;
        N|n)
            echo "exit ..."
            exit 1
        ;;
        *)
            echo "内容不匹配"
            func_continue
        ;;
    esac
}


# 分发/etc/hosts
function func_scphostname()
{
    if [[ -z $1 ]] ; then echo "ERROR 没有提供 HOST"; return 1 ;fi
    scp /etc/hosts $1:/etc/hosts
}


# 分发/etc/ntp.conf
function func_scpntpconf()
{
    if [[ -z $1 ]] ; then echo "ERROR 没有提供 HOST"; return 1 ;fi

    ssh $1 "systemctl start ntpd.service"
    echo $?
    if [[ $? -ne 0 ]]; then
        ssh $1 "yum install -y ntp"
        ssh $1 "chkconfig ntpd on"
        scp conf/ntp.conf $1:/etc/ntp.conf
        ssh $1 "systemctl start ntpd.service"
    else
        scp conf/ntp.conf $1:/etc/ntp.conf
    fi
}


function func_checkntpstatus()
{
   res=$(ssh $1 "date '+%Y-%m-%d %H:%M:%S'")
   echo ${res}
   # return ${res}
}


# 提供用户交互行 选择是否删除数据库继续
function func_drop_db()
{
    if [[ -z $1 ]] ; then echo "ERROR 没有提供 HOST"; return 1 ;fi

    read -p "是否删除数据库继续：(Y|y: 删除数据库，N|n: 不删除数据库):"  continue
    case ${continue} in
        Y|y)
            echo "删除数据库"
            ssh $1 "mysql -uroot -p$2 -e '"$(cat dbscript/droptable.sql)"'"
            return $?
        ;;
        N|n)
            echo "不删除数据库"
            return 1
        ;;
        *)
            echo "内容不匹配"
            func_drop_db $1 $2
            return $?
        ;;
    esac
}


# 创建数据库
function func_create_db()
{
    if [[ -z $1 ]] ; then echo "ERROR 没有提供 HOST"; return 1 ;fi

    ssh $1 "mysql -uroot -p$2 -e '"$(cat dbscript/createtable.sql)"'"
    ssh $1 "systemctl restart mysqld"
}


# 安装cm
function func_install_cm()
{
    remote_host="$1"
    cm_version="cm-5.13.0"
    cm_file="./soft/cloudera-manager-centos7-cm5.13.0_x86_64.tar.gz"
    rm_temp_path="/root/CDH_temp/"

    if [[ -z $1 ]] ; then echo "ERROR 没有提供 HOST"; return 1 ;fi
    if [[ -n $2 ]] ; then cm_version="$2"; fi
    if [[ -n $3 ]] ; then cm_file="$3"; fi
    if [[ -n $4 ]] ; then rm_temp_path="$4"; fi

    real_file=$(echo ${cm_file} | awk -F/ '{ print $NF }')

    ssh ${remote_host} "rm -rf /opt/${cm_version}"
    ssh ${remote_host} "mkdir -p ${rm_temp_path}"
    scp ${cm_file} ${remote_host}:${rm_temp_path}
    ssh ${remote_host} "tar -zxvf ${rm_temp_path}${real_file} -C /opt/"

#    tar -zxvf soft/cloudera-manager-centos7-cm5.13.0_x86_64.tar.gz -C /opt/
#    ls /opt/
}


# 安装Java环境配置
function func_install_java()
{
# $1    remote_host
# $2    remote_path
# $3    java_version
# $4    java_tar

#    rm -rf /opt/java
#    rm -rf /usr/java
#    mkdir -p /opt/java
#    mkdir -p /usr/java
#    cp /opt/jdk* /usr/java/

    remote_host="$1"
    remote_path="/root/CDH_temp/"
    java_version="jdk1.8.0_221"
    java_file="./soft/jdk-8u221-linux-x64.tar.gz"

    if [[ -z $1 ]] ; then echo "ERROR 没有提供 HOST"; return 1 ;fi
    if [[ -n $2 ]] ; then remote_path="$2"; fi
    if [[ -n $3 ]] ; then java_version="$3"; fi
    if [[ -n $4 ]] ; then java_file="$4"; fi

    real_file=$(echo ${java_file} | awk -F/ '{ print $NF }')

    java_home=`ssh ${remote_host} "awk '/JAVA_HOME=/{print}' /etc/profile"`

    if [[ -z "${java_home}" ]]
    then
        #失败
        ssh ${remote_host} "mkdir -p ${remote_path}"
        scp ${java_file} ${remote_host} :/root/CDH_temp/
        ssh ${remote_host} "rm -rf /opt/${java_version}"
        ssh ${remote_host} "tar -zxvf ${remote_path}${real_file} -C /opt/"

        ssh ${remote_host} 'echo -e "\n\n# ## set java env ##" >> /etc/profile'
        ssh ${remote_host} 'echo "export JAVA_HOME=/opt/'${java_version}'" >> /etc/profile'
        ssh ${remote_host} 'echo "JRE_HOME=$JAVA_HOME/jre" >>  /etc/profile'
        ssh ${remote_host} 'echo "export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar" >> /etc/profile'
        ssh ${remote_host} 'echo "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile'
        ssh ${remote_host} 'echo -e "# ## set java env ##\n\n" >> /etc/profile'
        ssh ${remote_host} "source /etc/profile"

        ssh ${remote_host} "rm -rf ${remote_path}"

        echo "JAVA_HOME 没有配置，重新安装配置"
        return 0
    else
        #成功
        echo "JAVA_HOME 已经配置，无须安装配置"
        return 0
    fi
}


# 分发/etc/profile
function func_scp_profile()
{
    scp /etc/profile $1:/etc/profile
    ssh $1 "source /etc/profile"
}

# 分发java安装文件
function func_ssh_java()
{
    ssh $1 "rm -rf /usr/java"
    ssh $1 "mkdir -p /usr/java"
    scp -r /opt/jdk* $1:/usr/java/
}


function func_delete_java_env()
{
    res="执行 JAVA 删除: "

    if [[ -z $1 ]] ; then echo "ERROR 没有提供 HOST"; return 1 ;fi

    all_java=$(ssh $1 "rpm -qa | grep java" | sed -n "/openjdk/p")

    for a_java in ${all_java}
    do
        ssh $1 "rpm -e ${a_java} --nodeps"
        echo "( $? ) ssh $1 \"rpm -e ${a_java} --nodeps\""
        res="${res}   :( $? ):ssh  $1 \"rpm -e ${a_java} --nodeps\""
    done
}


function func_install_mysql_driver()
{
    remote_host="$1"
    mysql_con="./soft/mysql-connector-java-5.1.44-bin.jar"
    cdh_version="cm-5.13.0"
    java_home="/opt/jdk1.8.0_221"

    if [[ -z $1 ]] ; then echo "ERROR 没有提供 HOST"; return 1 ;fi
    if [[ -n $2 ]] ; then mysql_con="$2"; fi
    if [[ -n $3 ]] ; then cdh_version="$3"; fi
    if [[ -n $4 ]] ; then java_home="/opt/$4"; fi

    scp ${mysql_con} ${remote_host}:/opt/${cdh_version}/share/cmf/lib/
    scp ${mysql_con} ${remote_host}:/usr/share/java/
    scp ${mysql_con} ${remote_host}:${java_home}/jre/lib/ext/

# check
#    ls  /opt/cm-5.13.0/share/cmf/lib/ | grep mysql-connector-java*
#    ls  /usr/share/java/ | grep mysql-connector-java*
#    ls  $JAVA_HOME/jre/lib/ext | grep mysql-connector-java*
}

function scp_mysql_driver_func() {
     scp -r /opt/cm-5.13.0/share/cmf/lib/ $1:/opt/cm-5.13.0/share/cmf/
     scp -r /usr/share/java/ $1:/usr/share/
     scp -r $JAVA_HOME/jre/lib/ext $1:/$JAVA_HOME/jre/lib/
}


function func_ssh_disable_firewalld() {
    echo "func_ssh_disable_firewalld"
    if [[ -z $1 ]] ; then echo "ERROR 没有提供 HOST"; return 1 ;fi

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
