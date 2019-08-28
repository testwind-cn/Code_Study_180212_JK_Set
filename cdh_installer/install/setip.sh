#!/bin/bash


# 获取当期时间
THE_DATE=$(date '+%Y%m%d_%H%M%S')

THE_DIR="$(dirname $0)/"
cd ${THE_DIR}

# 添加日志
function func_log()
{
    res=$(date '+%Y-%m-%d %H:%M:%S')"\t( $? ):\t$1"
    echo -e ${res} >> ../log/${THE_DATE}/install.log
    echo -e ${res}
}


#载入外部函数
. ./fuctions.sh


func_continue

# 创建当前日志文件夹
mkdir -p ./log/${THE_DATE}


func_log "================================================================"

# 生成SSH Key
expect ./expect/auto_keygen.exp
func_log "生成SSH Key"



# 获取配置文件中的密码
OLD_PASSWDS=`awk -F " " 'NR==1{print $4}' ./conf/hosts.cfg`
func_log "获取配置文件中的旧密码: ${OLD_PASSWDS}"

PASSWDS=`awk -F " " 'NR==1{print $5}' ./conf/hosts.cfg`
func_log "获取配置文件中的新密码: ${PASSWDS}"


# 获取配置文件中的 Agent 主机
VAR_HOSTS=`awk -F " " '{print $3}' ./conf/hosts.cfg`
func_log "获取配置文件中的主机: ${VAR_HOSTS}"

# 获取配置文件中的 Master 主机
MASTER_HOST=`awk -F " " 'NR==1{print $3}' ./conf/hosts.cfg`
func_log "获取配置文件中的 Master 主机: ${MASTER_HOST}"


# 获取配置文件中的网关
GATEWAY=`awk -F " " 'NR==1{print $6}' ./conf/hosts.cfg`
func_log "获取配置文件中的网关: ${GATEWAY}"


# 获取配置文件中的 DNS
DNS_IP=`awk -F " " 'NR==1{print $7}' ./conf/hosts.cfg`
func_log "获取配置文件中的 DNS: ${DNS_IP}"

# 获取配置文件中的新旧 IP
OLD_NEW_IP=`awk -F " " -v OFS="," '{print $1,$2,$3}' ./conf/hosts.cfg`
func_log "获取配置文件中的 OLD_NEW_IP: ${OLD_NEW_IP}"



add_host=""
for pair_ip in ${OLD_NEW_IP}
do
    new_ip=$(echo ${pair_ip} | awk -F ',' -v OFS=',' '{print $2}')
    n_name=$(echo ${pair_ip} | awk -F ',' -v OFS=',' '{print $3}')
    if [[ -n ${new_ip} && -n ${n_name} ]]
    then
        if [[ -n ${add_host} ]]
        then
            add_host="${add_host}\\n"
        fi
        add_host="${add_host}${new_ip}     ${n_name}"
    fi
done


for pair_ip in ${OLD_NEW_IP}
do
    old_ip=$(echo "${pair_ip}" | awk -F "," -v OFS="," '{print $1}')
    new_ip=$(echo "${pair_ip}" | awk -F "," -v OFS="," '{print $2}')
    n_name=$(echo "${pair_ip}" | awk -F "," -v OFS="," '{print $3}')

    if [[ -n ${old_ip} && -n ${new_ip} && -n ${n_name} ]]
    then
        # 完成配置免密
        expect ./expect/ssh-copy-id.exp ${old_ip} ${OLD_PASSWDS}
        func_log "配置需求ssh免密 ${old_ip} , ${OLD_PASSWDS}"
        echo "完成配置免密"


        ssh ${old_ip} "sed  -i -e '\$a${add_host}'  /etc/hosts"

        # 完成密码修改
        ssh ${old_ip} "passwd <<EOF
${PASSWDS}
${PASSWDS}
EOF"
        echo "完成密码修改"


        # "完成设置 DNS"
        ssh ${old_ip} "nmcli con mod ens160 ipv4.dns '${GATEWAY} 114.114.114.114' ; systemctl restart network"
        echo "完成设置 DNS"


        # 修改网卡配置
        s_script="-e '/BOOTPROTO/aIPADDR=${new_ip}\nNETMASK=255.255.255.0\nGATEWAY=${GATEWAY}\nPREFIX=24'"
        ssh ${old_ip} "sed -i -r -e '/NETMASK|GATEWAY|PREFIX/d' ${s_script} -e 's/dhcp/static/g' /etc/sysconfig/network-scripts/ifcfg-ens160"
        echo "修改网卡配置  ${old_ip} ${new_ip}"


        # 修改机器名
        if [[ -n ${n_name} ]]
        then
            ssh ${old_ip} "hostnamectl set-hostname ${n_name}"
            echo "( $? ) 修改机器名 ssh ${old_ip} hostnamectl set-hostname ${n_name}"
        else
            echo "没有新机器名"
        fi

    else
        echo "空行跳过 Empty Line"
    fi
done







for pair_ip in ${OLD_NEW_IP}
do
    old_ip=$(echo "${pair_ip}" | awk -F "," -v OFS="," '{print $1}')
    new_ip=$(echo "${pair_ip}" | awk -F "," -v OFS="," '{print $2}')
    n_name=$(echo "${pair_ip}" | awk -F "," -v OFS="," '{print $3}')

    if [[ -n ${old_ip} && -n ${new_ip} && -n ${n_name} ]]
    then
        ssh ${old_ip} "systemctl restart network" &
        the_pid=$!
        echo "父脚本：启动子脚本..${the_pid}"
        sleep 5
        kill ${the_pid}

        echo "完成设置 IP ${old_ip} ${new_ip} ${n_name}"

    else
        echo "空行跳过 Empty Line"
    fi
done

# old_ip=10.2.206.236
# new_ip=10.2.206.18

