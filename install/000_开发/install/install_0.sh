#!/bin/bash

# ---------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------- step 0 ---------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------

# 定义变量
# 定义 Mysql 密码
MYSQL_PWD="Risk@2018"
RM_TEMP_PATH="/root/CDH_temp/"

JAVA_VERSION="jdk1.8.0_221"
JAVA_FILE="./soft/jdk-8u221-linux-x64.tar.gz"

MYSQL_FILE="./soft/mysql-5.7.23-1.el7.x86_64.rpm-bundle.tar"
MYSQL_RPM[0]="mysql-community-common-5.7.23-1.el7.x86_64.rpm"
MYSQL_RPM[1]="mysql-community-libs-5.7.23-1.el7.x86_64.rpm"
MYSQL_RPM[2]="mysql-community-client-5.7.23-1.el7.x86_64.rpm"
MYSQL_RPM[3]="mysql-community-server-5.7.23-1.el7.x86_64.rpm"

CM_VERSION="cm-5.13.0"
CM_FILE="./soft/cloudera-manager-centos7-cm5.13.0_x86_64.tar.gz"

CDH_REPO_PATH="/opt/cloudera/parcel-repo/"
CDH_REPO_FILE[0]="./soft/CDH-5.11.0-1.cdh5.11.0.p0.34-el7.parcel"
CDH_REPO_FILE[1]="./soft/CDH-5.11.0-1.cdh5.11.0.p0.34-el7.parcel.sha"
CDH_REPO_FILE[2]="./soft/manifest.json"

MYSQL_CON="./soft/mysql-connector-java-5.1.44-bin.jar"

# 获取当期时间
THE_DATE=$(date '+%Y%m%d_%H%M%S')

THE_DIR="$(dirname $0)/"
cd ${THE_DIR}


# 添加日志
function func_log()
{
    res=$(date '+%Y-%m-%d %H:%M:%S')"\t( $? ):\t$1"
    echo -e ${res} >> ./log/${THE_DATE}/install.log
    echo -e ${res}
}


#载入外部函数
. ./fuctions.sh


func_log ""
func_log ""
func_log "----------------------------------------"
func_log "|           CDH 自动化安装程序         |"
func_log "----------------------------------------"
func_log ""
func_log ""
func_log "hosts 配置内容如下是否要写入/etc/hosts 中: "
func_log ""
func_log "----------------------------------------------------------------"
while read line
do
    func_log ${line}
done < ./conf/hosts

func_log "----------------------------------------------------------------"
func_log ""
func_log ""

func_continue

# 创建当前日志文件夹
mkdir -p ./log/${THE_DATE}


# 清空/etc/hosts
echo "" > /etc/hosts
func_log "清空/etc/hosts"


# 把配置文件中的hosts写到/etc/hosts中
func_log "把配置文件中的hosts写到/etc/hosts中"
while read line
do
    func_log ${line}
    echo ${line} >> /etc/hosts
done < ./conf/hosts


# 生成SSH Key
expect ./expect/auto_keygen.exp
func_log "生成SSH Key"


# 获取配置文件中的密码
PASSWDS=`awk -F " " '{print $3}' ./conf/hosts.cfg`
func_log "获取配置文件中的密码: ${PASSWDS}"


# 获取配置文件中的主机
VAR_HOSTS=`awk -F " " '{print $2}' ./conf/hosts.cfg`
func_log "获取配置文件中的主机: ${VAR_HOSTS}"

# 获取配置文件中的主机
MASTER_HOST=`awk -F " " 'NR==1{print $2}' ./conf/hosts.cfg`

# 配置需求ssh免密
for domain in ${VAR_HOSTS}
do
    expect ./expect/ssh-copy-id.exp ${domain} ${PASSWDS}
    func_log "配置需求ssh免密 ${domain} , ${PASSWDS}"
done


# 分发hosts配置文件
for domain in ${VAR_HOSTS}
do
    func_scphostname ${domain}
    func_log "分发hosts配置文件 ${domain}"
done


# 分发ntp配置文件
for domain in ${VAR_HOSTS}
do
    func_scpntpconf ${domain}
done


# 检查各个节点的ntp服务状态
for domain in ${VAR_HOSTS}
do
    func_checkntpstatus ${domain}
    func_log "检查各个节点的ntp服务状态:\t"${domain}"\t$?"
done


# 所有节点关闭防火墙和selinux（重启生效)
for domain in ${VAR_HOSTS}
do
    func_ssh_disable_firewalld ${domain}
    func_log "所有节点关闭防火墙和selinux（重启生效):\t"${domain}
done


# 删除 MariaDb
rpm -qa | grep mariadb > ./log/${THE_DATE}/mysqlenv.txt
while read line
do
    echo ${line}
    rpm -e ${line} --nodeps
    func_log "删除 MariaDb:\t"${line}
done < ./log/${THE_DATE}/mysqlenv.txt


# 检查是否安装了 MySQL
func_log "检查是否安装了 MySQL"
res=$(ssh ${MASTER_HOST} 'systemctl status mysqld ; echo $?')

if [[ ${res} -ne 0 ]]
then
    # 失败
    func_log "mysqld 服务没有安装！！！"

    ssh ${MASTER_HOST} "mkdir -p ${RM_TEMP_PATH}"
    func_log "创建文件夹: ssh ${MASTER_HOST} \"mkdir -p ${RM_TEMP_PATH}\""

    scp ${MYSQL_FILE} ${MASTER_HOST}:${RM_TEMP_PATH}
    func_log "复制: scp ${MYSQL_FILE} ${MASTER_HOST}:${RM_TEMP_PATH}"

    ssh ${MASTER_HOST} "tar -xvf ${RM_TEMP_PATH}${MYSQL_FILE} -C ${RM_TEMP_PATH}"
    func_log "解压: ssh ${MASTER_HOST} \"tar -xvf ${RM_TEMP_PATH}${MYSQL_FILE} -C ${RM_TEMP_PATH}\""

    for a_rpm in ${MYSQL_RPM}
    do
        ssh ${MASTER_HOST} "rpm -ivh ${RM_TEMP_PATH}${a_rpm}"
        func_log "安装: ssh ${MASTER_HOST} \"rpm -ivh ${RM_TEMP_PATH}${a_rpm}\""
    done
fi


# 检查 MySQL 是否启动
func_log "检查 MySQL 是否启动"
res=$(ssh ${MASTER_HOST} 'systemctl start mysqld > /dev/null 2>&1 ; echo $?')
if [[ ${res} -ne 0 ]]
then
    # 失败
    func_log "mysql 服务启动失败"
else
    # 成功
    func_log "mysql 服务已经启动成功"
fi


# Mysql 命令行参数:  -O, --set-variable=name  //设置变量用法是--set-variable=var_name=var_value


# 查询 MYSQL 临时密码
MYSQL_TEMP_PWD=$(ssh ${MASTER_HOST} "awk '/temporary password/{print}' /var/log/mysqld.log | cut -d ' ' -f 11")
func_log "查询MYSQL 临时密码:\t${MYSQL_TEMP_PWD}"


# 修改 MYSQL 密码
ssh ${MASTER_HOST} "mysql -u root --password=${MYSQL_TEMP_PWD} -b --connect-expired-password -e 'SET PASSWORD=PASSWORD("${MYSQL_PWD}");"
func_log "修改 MYSQL 密码:\t${MYSQL_TEMP_PWD}:\tSET PASSWORD=PASSWORD(${MYSQL_PWD});"


# 授权 root 权限
ssh ${MASTER_HOST} "mysql -uroot -p${MYSQL_PWD} -e '"$(sed 's/${MYSQL_PWD}/'${MYSQL_PWD}'/g' dbscript/mysql.sql)"'"
func_log "授权 root 权限:\n"$(sed 's/${MYSQL_PWD}/'${MYSQL_PWD}'/g' dbscript/mysql.sql)


# 提供用户交互行 选择是否删除数据库继续
func_drop_db ${MASTER_HOST} ${MYSQL_PWD}
func_log "\t提供用户交互行 选择是否删除数据库继续"


# 创建数据库
func_create_db ${MASTER_HOST} ${MYSQL_PWD}
func_log "\t创建数据库"


# 安装各个节点的java环境
for domain in ${VAR_HOSTS}
do
    func_delete_java_env ${domain}
    func_log " :${domain} 删除 JAVA 完成"

    func_install_java ${domain} ${RM_TEMP_PATH} ${JAVA_VERSION} ${JAVA_FILE}
    func_log " :${domain} 安装 JAVA 完成"
done




for domain in ${VAR_HOSTS}
do
    ssh ${domain} "reboot"
done

func_continue

# TODO 添加 ln -s /opt/java /usr/java



# 安装 CM 到各个节点
for domain in ${VAR_HOSTS}
do
    func_install_cm ${domain} ${CM_VERSION} ${CM_FILE} ${RM_TEMP_PATH}
    func_log "分发 CM 到各个节点 func_install_cm ${domain} ${CM_VERSION} ${CM_FILE} ${RM_TEMP_PATH}"
done


# SCP 安装 mysql driver
# func_install_mysql_driver
for domain in ${VAR_HOSTS}
do
    func_install_mysql_driver ${domain} ${MYSQL_CON} ${CM_VERSION} ${JAVA_VERSION}
    func_log "SCP 安装 mysql driver: func_install_mysql_driver ${domain} ${MYSQL_CON} ${CM_VERSION} ${JAVA_VERSION}"
done


# 获取配置文件中的主机
MASTER_HOST=`awk -F " " 'NR==1{print $2}' ./conf/hosts.cfg`


# 配置各节点 CM Agent的config.ini 文件
for domain in ${VAR_HOSTS}
do
    ssh ${domain} "sed -i 's/^server_host=localhost/server_host="${MASTER_HOST}"/g' /opt/${CM_VERSION}/etc/cloudera-scm-agent/config.ini"
    func_log "配置 ${domain} 节点 CM Agent的config.ini 文件 server_host=${MASTER_HOST}"
done


# 在主节点初始化 CM 的数据库
ssh ${MASTER_HOST} "sh /opt/${CM_VERSION}/share/cmf/schema/scm_prepare_database.sh mysql -uroot -p${MYSQL_PWD} scm scm"
func_log "在主节点初始化 CM 的数据库: ssh ${MASTER_HOST} \"sh /opt/${CM_VERSION}/share/cmf/schema/scm_prepare_database.sh mysql -uroot -p${MYSQL_PWD} scm scm\""


# 复制 CDH 安装包
for a_file in ${CDH_REPO_FILE}
do
    scp ${a_file} ${MASTER_HOST}:${CDH_REPO_PATH}
    func_log "scp ${a_file} ${MASTER_HOST}:${CDH_REPO_PATH}"
done


# 在所有节点创建 cloudera-scm 用户
for domain in ${VAR_HOSTS} ; do
    ssh ${domain} "useradd --system --home=/opt/cm-5.13.0/run/cloudera-scm-server/ --no-create-home --shell=/bin/false cloudera-scm"
    ssh ${domain} "chown cloudera-scm.cloudera-scm /opt -R"
    ssh ${domain} "chown cloudera-scm.cloudera-scm /var/log/cloudera-scm-agent -R"
    func_log "在 ${domain}节点创建 cloudera-scm 用户"
done



#

rm -f script/ssh_reboot_remote.sh
rm -f script/ssh_scm_start.sh
rm -f script/ssh_scm_stop.sh

echo "ssh ${MASTER_HOST} '/opt/${CM_VERSION}/etc/init.d/cloudera-scm-server start'" >> script/ssh_scm_start.sh

for domain in ${VAR_HOSTS}
do
    echo "ssh ${domain} reboot" >> script/ssh_reboot_remote.sh
    echo "ssh ${domain} /opt/${CM_VERSION}/etc/init.d/cloudera-scm-agent start" >> script/ssh_scm_start.sh
    echo "ssh ${domain} /opt/${CM_VERSION}/etc/init.d/cloudera-scm-agent stop" >> script/ssh_scm_stop.sh
done

echo "ssh ${MASTER_HOST} '/opt/${CM_VERSION}/etc/init.d/cloudera-scm-server stop'" >> script/ssh_scm_stop.sh

func_continue

sh script/ssh_reboot_remote.sh

func_continue

sh script/ssh_scm_start.sh

