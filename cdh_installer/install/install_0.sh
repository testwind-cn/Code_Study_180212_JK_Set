#!/bin/bash

# ---------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------- step 0 ---------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------

VERBOSE=1

# 定义变量
# 定义 Mysql 密码
MYSQL_PWD="Risk@2018"
RM_TEMP_PATH="/root/install_cdh_temp/"

PACKAGE_FILES=("../soft/packages/host/" "../soft/packages/net-tools/" "../soft/packages/ntp/" "../soft/packages/ntp/" "../soft/packages/perl/" "../soft/packages/psmisc/" "../soft/packages/wget/")

PACKAGES="../soft/packages"

NTP_FILE="../soft/packages/ntp/"
PSMIC_FILE="../soft/packages/psmisc/"
NET_TOOLS_FILE="../soft/packages/net-tools/"
PERL_FILE="../soft/packages/perl/"
MYSQL_FILE="../soft/mysql/"

MYSQL_CON="../soft/mysql-connector/mysql-connector-java-5.1.44-bin.jar"

# # 不用了
# MYSQL_FILE_1="./soft/mysql-5.7.23-1.el7.x86_64.rpm-bundle.tar"
# MYSQL_RPM=()
# MYSQL_RPM[0]="mysql-community-common-5.7.23-1.el7.x86_64.rpm"
# MYSQL_RPM[1]="mysql-community-libs-5.7.23-1.el7.x86_64.rpm"
# MYSQL_RPM[2]="mysql-community-client-5.7.23-1.el7.x86_64.rpm"
# MYSQL_RPM[3]="mysql-community-server-5.7.23-1.el7.x86_64.rpm"
# # 不用了


JAVA_VERSION="jdk1.8.0_221"
JAVA_FILE="../soft/jdk-8u221-linux-x64.tar.gz"


CM_VERSION="cm-5.13.0"
CM_FILE="../soft/cm/cloudera-manager-centos7-cm5.13.0_x86_64.tar.gz"

CDH_REPO_PATH="/opt/cloudera/parcel-repo/"
CDH_REPO_FILE="../soft/cdh/"

# # 不用了
# CDH_REPO_FILE_1=()
# CDH_REPO_FILE_1[0]="./soft/CDH-5.11.0-1.cdh5.11.0.p0.34-el7.parcel"
# CDH_REPO_FILE_1[1]="./soft/CDH-5.11.0-1.cdh5.11.0.p0.34-el7.parcel.sha"
# CDH_REPO_FILE_1[2]="./soft/manifest.json"
# # 不用了


# 获取当期时间
THE_DATE=$(date '+%Y%m%d_%H%M%S')

# 获取历史目录、主程序目录
LAST_DIR=$(pwd)
THE_DIR="$(dirname $0)/"
cd ${THE_DIR}
THE_DIR=$(pwd)

# 创建当前日志文件夹
mkdir -p ${THE_DIR}/log/${THE_DATE}

THE_SKIP_ALL="N"

# 载入外部函数
source ./fuctions.sh

func_log "" 0 1
func_log "" 0 1
func_log "----------------------------------------" 0 1
func_log "|           CDH 自动化安装程序         |" 0 1
func_log "----------------------------------------" 0 1
func_log "" 0 1
func_log "" 0 1
func_log "hosts.cfg 配置内容如下: " 0 1
func_log "" 0 1
func_log "----------------------------------------------------------------" 0 1

while read line || [[ -n ${line} ]]
do
    func_log "${line}" 0 1
done < ./conf/hosts.cfg

func_log "----------------------------------------------------------------" 0 1
func_log "" 0 1
func_log "" 0 1

func_continue "\n\n\n\n是否继续安装？\n"



# 获取配置文件中的密码
OLD_PASSWDS=$(awk -F " " 'NR==1{print $4}' ./conf/hosts.cfg)
func_log "获取配置文件中的旧密码: ${OLD_PASSWDS}" 0 1

PASSWDS=$(awk -F " " 'NR==1{print $5}' ./conf/hosts.cfg)
func_log "获取配置文件中的新密码: ${PASSWDS}" 0 1


# 获取配置文件中的 Agent 主机
VAR_HOSTS=($(awk -F " " '{print $3}' ./conf/hosts.cfg))
func_log "获取配置文件中的主机: ${VAR_HOSTS[*]}" 0 1

# 获取配置文件中的 Master 主机
MASTER_HOST=$(awk -F " " 'NR==1{print $3}' ./conf/hosts.cfg)
func_log "获取配置文件中的 Master 主机: ${MASTER_HOST}" 0 1


# 获取配置文件中的网关
GATEWAY=$(awk -F " " 'NR==1{print $6}' ./conf/hosts.cfg)
func_log "获取配置文件中的网关: ${GATEWAY}" 0 1


# 获取配置文件中的 DNS
DNS_IP=$(awk -F " " 'NR==1{print $7}' ./conf/hosts.cfg)
func_log "获取配置文件中的 DNS: ${DNS_IP}" 0 1

# 获取配置文件中的新旧 IP
OLD_NEW_IP=($(awk -F " " -v OFS="," '{print $1,$2,$3}' ./conf/hosts.cfg))
func_log "获取配置文件中的 OLD_NEW_IP: ${OLD_NEW_IP[*]}" 0 1



func_install_key "${VAR_HOSTS[*]}" ${PASSWDS}


func_install_host_file "${OLD_NEW_IP[*]}"




# func_continue '\n\n\n在所有节点安装各个软件包 ？\n'
func_install_packages_hosts ${PACKAGES} "${VAR_HOSTS[*]}" ${RM_TEMP_PATH}



# 完成分发ntp配置文件
func_scpntpconf ${NTP_FILE} ${RM_TEMP_PATH} "${VAR_HOSTS[*]}"




# 检查各个节点的ntp服务状态
func_checkntpstatus "${VAR_HOSTS[*]}"




# 所有节点关闭防火墙和selinux（重启生效)
func_ssh_disable_firewalld "${VAR_HOSTS[*]}"


# 删除 MariaDb
func_uninstall_rpm_hosts "mariadb" ${MASTER_HOST}



# 检查是否安装了 MySQL
func_check_mysql_status ${MASTER_HOST}


# 安装 MySQL
func_install_mysql ${MASTER_HOST}


# 启动 MySQL
func_start_mysql ${MASTER_HOST}


# 修改 MySQL
func_modify_mysql ${MYSQL_PWD} ${MASTER_HOST}



# 提供用户交互行 选择是否删除数据库继续
func_drop_db ${MYSQL_PWD} ${MASTER_HOST}


# 创建数据库
func_create_db ${MYSQL_PWD} ${MASTER_HOST}


# 安装各个节点的java环境
func_install_java ${JAVA_VERSION} ${JAVA_FILE} "${VAR_HOSTS[*]}" ${RM_TEMP_PATH}



#for domain in ${VAR_HOSTS}
#do
#    ssh ${domain} "reboot"
#done



# TODO 添加 ln -s /opt/java /usr/java



# 安装 CM 到各个节点
func_continue '\n\n\n安装 CM 到各个节点 ？\n'
if [[ $? == 0 ]]
then
    for domain in ${VAR_HOSTS[*]}
    do
        func_install_cm ${CM_VERSION} ${CM_FILE} ${domain} ${RM_TEMP_PATH}
        func_log "分发 CM 到各个节点 func_install_cm ${CM_VERSION} ${CM_FILE} ${domain} ${RM_TEMP_PATH}" $?
    done
else
    func_log "不安装 CM" 1
fi


# 安装 CM 到各个节点
func_continue '\n\n\n在所有节点创建 cloudera-scm 用户 ？\n'
if [[ $? == 0 ]]
then
    for domain in ${VAR_HOSTS[*]} ; do
        # 在所有节点创建 cloudera-scm 用户
        ssh ${domain} "useradd --system --home=/opt/cm-5.13.0/run/cloudera-scm-server/ --no-create-home --shell=/bin/false cloudera-scm ;
chown cloudera-scm:cloudera-scm /opt -R ;
mkdir -p /var/lib/cloudera-scm-server ;
mkdir -p /var/log/cloudera-scm-agent ;
chown cloudera-scm:cloudera-scm /var/log/cloudera-scm-agent -R ;
chown cloudera-scm:cloudera-scm /var/lib/cloudera-scm-server -R "
        func_log "在 ${domain}节点创建 cloudera-scm 用户"
    done
fi

# SCP 安装 mysql driver
func_continue '\n\n\nSCP 安装 mysql driver？\n'
if [[ $? == 0 ]]
then
    for domain in ${VAR_HOSTS[*]}
    do
        func_install_mysql_driver  ${MYSQL_CON} ${CM_VERSION} ${JAVA_VERSION} ${domain}
        func_log "SCP 安装 mysql driver: func_install_mysql_driver ${MYSQL_CON} ${CM_VERSION} ${JAVA_VERSION} ${domain}" $?
    done
else
    func_log "不安装 mysql driver" 1
fi



# 获取配置文件中的主机
# MASTER_HOST=$(awk -F " " 'NR==1{print $2}' ./conf/hosts.cfg)


# 配置各节点 CM Agent的config.ini 文件
func_config_cm_ini ${CM_VERSION} ${MYSQL_PWD} ${MASTER_HOST} "${VAR_HOSTS[*]}"



# 在主节点初始化 CM 的数据库
func_config_cm_db ${CM_VERSION} ${MYSQL_PWD} ${MASTER_HOST}



# 复制 CDH 安装包
func_continue '\n\n\n复制 CDH 安装包？\n'
#for a_file in ${CDH_REPO_FILE}
#do
#    scp "${a_file}*" ${MASTER_HOST}:${CDH_REPO_PATH}
#    func_log "scp \"${a_file}*\" ${MASTER_HOST}:${CDH_REPO_PATH}"
#done
if [[ $? == 0 ]]
then
    ssh ${MASTER_HOST} "mkdir -p /root/mnt/cd ;
    mount /dev/cdrom /root/mnt/cd ;
    cp -u /root/mnt/cd/cdh/* ${CDH_REPO_PATH} "
fi



func_continue "启动服务"

# MASTER_HOST='cdh-nn1'
# VAR_HOSTS=(cdh-nn1 cdh-nn2 cdh-dn1 cdh-dn2 cdh-dn3 cdh-dn4)

for domain in ${VAR_HOSTS[*]}
do
    ssh ${domain} "source /etc/profile ; /opt/${CM_VERSION}/etc/init.d/cloudera-scm-agent start"
done

ssh ${MASTER_HOST} "source /etc/profile ; /opt/${CM_VERSION}/etc/init.d/cloudera-scm-server start"

read -p "终止？" aaa
#


for domain in ${VAR_HOSTS[*]}
do
    ssh ${domain} "source /etc/profile ; /opt/${CM_VERSION}/etc/init.d/cloudera-scm-agent stop"
done

ssh ${MASTER_HOST} "source /etc/profile ; /opt/${CM_VERSION}/etc/init.d/cloudera-scm-server stop"


for domain in ${VAR_HOSTS[*]}
do
    ssh ${domain} "reboot"
done


#rm -f script/ssh_reboot_remote.sh
#rm -f script/ssh_scm_start.sh
#rm -f script/ssh_scm_stop.sh

echo "ssh ${MASTER_HOST} '/opt/${CM_VERSION}/etc/init.d/cloudera-scm-server start'" >> script/ssh_scm_start.sh

# MASTER_HOST='cdh-nn1'

for domain in ${VAR_HOSTS[*]}
do
    echo "ssh ${domain} reboot" >> script/ssh_reboot_remote.sh
    echo "ssh ${domain} /opt/${CM_VERSION}/etc/init.d/cloudera-scm-agent start" >> script/ssh_scm_start.sh
    echo "ssh ${domain} /opt/${CM_VERSION}/etc/init.d/cloudera-scm-agent stop" >> script/ssh_scm_stop.sh
done

echo "ssh ${MASTER_HOST} '/opt/${CM_VERSION}/etc/init.d/cloudera-scm-server stop'" >> script/ssh_scm_stop.sh

func_continue

sh script/ssh_reboot_remote.sh



sh script/ssh_scm_start.sh

