#!/bin/bash



# 添加日志
function func_log()
{
    local func_log_last_res=$?

    local is_verbose=$3
    local func_log_res=""

    if [[ ${VERBOSE} ]]
    then
        is_verbose=${VERBOSE}
    fi

    func_log_res=$(date '+%Y-%m-%d %H:%M:%S')"\t( $2 ):\t$1"

    echo -e "${func_log_res}" >> ${THE_DIR}/log/${THE_DATE}/install.log

    if [[ ${is_verbose} ]]
    then
        echo -e "( $2 ):\t$1"
    fi

    return ${func_log_last_res}
#    pwd
#    echo "${THE_DIR}/log/${THE_DATE}/install.log"
}


# 提供用户交互行 选择是否继续
function func_continue()
{
    func_log "$1" 0 1

    if [[ ${THE_SKIP_ALL} = 'A'  ||  ${THE_SKIP_ALL} = 'a' ]]
    then
        func_log "全部继续执行 go through ..." 0 1
        return 0
    fi

    while :
    do
        read -p "是否继续：(y:继续，n|x:退出，s:跳过，a:全部继续，回车继续):"  input_s

        if [[ -z ${input_s} ]]
        then
            input_s='Y'
        fi

        case ${input_s} in
            Y|y)
                func_log "继续执行 continue ..." 0 1
                return 0
            ;;
            A|a)
                func_log "全部继续执行 go through ..." 0 1
                THE_SKIP_ALL='A'
                return 0
            ;;
            S|s)
                func_log "跳过 skip ..." 1 1
                return 1
            ;;
            N|n|X|x)
                func_log "程序退出 exit ..." 4 1
                exit 4
            ;;
            *)
                func_log "内容不匹配" 0 1
            ;;
        esac
    done

}

function func_get_name()
{
    if [[ -z $1 ]] ; then func_log "参数不足!! " 1; return 1 ;fi

    local res=0
    local folder=$(echo $1 | sed -e 's/\/$//')
    res=$?
    echo ${folder}
    return ${res}
}


function func_get_short_name()
{
    if [[ -z $1 ]] ; then func_log "参数不足!! " 1; return 1 ;fi

    local res=0
    local folder=$(func_get_name $1)
    local s_folder=$(echo ${folder} | awk -F/ '{ print $NF }')
    res=$?
    echo ${s_folder}
    return ${res}
}


# 分发/etc/hosts
function func_install_host_file()
{
    local exec_cmd=""

    func_continue '\n\n\n\n是否开始清除重添加 Hosts 文件？\n'
    if [[ $? -ne 0 ]]
    then
        func_log "不重添加 Hosts 文件" 1 1
        return 1
    fi

    local host_list=($1)


    local add_host=""
    local del_host=""

    for pair_ip in ${host_list[*]}
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


            t_new_ip=$(echo ${new_ip} | sed 's/\./\\./g')
            t_n_name=$(echo ${n_name} | sed 's/\./\\./g')
            # t_new_ip = 10\.2\.206\.18
            # t_n_name = cdh\.nn1

            del_1="/^${t_new_ip}[\t ]/d"
            del_2="/[\t ][\t ]*${t_n_name}\$/d"

            del_host="${del_host} -e '${del_1}'  -e '${del_2}'"

            # sed -i -e "${del_1}" -e "${del_1}" /etc/hosts
            # 1、顶头是IP的，后面有空格或TAB
            # 2、末尾是机器名，前面有空格或TAB
        fi
    done




    exec_cmd="sed -i ${del_host} /etc/hosts ; sed -i -e '\$a\\${add_host}' /etc/hosts"

    # ### 如果加引号，就是传一个字符串参数，如果不加，就是传多个参数
    echo ${exec_cmd} | sh

    local res=$?

    func_log "echo ${exec_cmd} | sh" ${res}


    for pair_ip in ${host_list[*]}
    do
        new_ip=$(echo ${pair_ip} | awk -F ',' -v OFS=',' '{print $2}')
        n_name=$(echo ${pair_ip} | awk -F ',' -v OFS=',' '{print $3}')
        if [[ -n ${new_ip} && -n ${n_name} ]]
        then
            ssh ${new_ip} ${exec_cmd}

            echo -e "\n\n\n\n"
            ping -c 4 -w 4 ${n_name}
            func_continue '\n\n\n\n'" ($?) ${n_name}' 主机是否可以访问？\n"
        fi
    done

}

func_install_key()
{

    local host_list=($1)

    func_continue '\n\n\n\n是否开始设置 SSH Key 文件？\n'
    if [[ $? == 0 ]]
    then

        # 生成SSH Key
        expect ./expect/auto_keygen.exp
        func_log "生成SSH Key"

        for domain in ${host_list[*]}
        do
            # 完成配置免密
            expect ./expect/ssh-copy-id.exp ${domain} $2
            func_log "配置需求ssh免密 ${domain} , $2"
        done
        func_log "完成配置免密"
    fi
}


func_install_rpm()
{
    if [[ -z $1 ]] ; then func_log "参数不足!! 1"; return 1 ;fi

    local d_folder="/tmp/install_cdh_temp/"
    if [[ -n $3 ]] ; then d_folder="$3" ; fi

    local res=0
    local folder=$(func_get_name $1)
    local s_folder=$(func_get_short_name ${folder})

    local remote_hosts=($2)
    local d_folder=$(func_get_name ${d_folder})


    if [[ -z ${#remote_hosts[*]} ]]
    then
        rpm -ivh --replacepkgs --nodeps "${folder}/*.rpm"
        res=$?
        func_log "rpm -ivh --replacepkgs --nodeps \"${folder}/*.rpm\"" ${res}
    else
        for domain in ${remote_hosts[*]}
        do
            ssh ${domain} "mkdir -p ${d_folder}"
            scp -r ${folder} ${domain}:${d_folder}
            res=$?
            func_log "scp -r ${folder} ${domain}:${d_folder}" ${res}

            ssh ${domain} "rpm -ivh --replacepkgs --nodeps ${d_folder}/${s_folder}/*.rpm"
            res=$?
            func_log "ssh ${domain} \"rpm -ivh --replacepkgs --nodeps ${d_folder}/${s_folder}/*.rpm\""  ${res}
        done
    fi
}

func_install_rpm_hosts()
{
# 在本机，或者多台机器上安装1个包
    if [[ -z $1 ]] ; then func_log "参数不足!! "; return 1 ;fi

    func_continue "\n\n\n\n是否安装 $1 软件包？\n"

    if [[ $? -ne 0 ]]
    then
        func_log "不安装 $1" 1
        return 1
    fi

    func_install_rpm "$1" "$2" "$3"
}

func_install_packages_hosts()
{
# 在本机，或者多台机器上安装多个包
    if [[ -z $1 ]] ; then func_log "参数不足!! "; return 1 ;fi

    local remote_hosts=($2)

    # local folder="../soft/packages/"
    local folder="$1"
    local folder=$(func_get_name "${folder}")
    local folders=($(ls -d ${folder}/*/))


    func_continue "\n\n\n\n是否在 ${remote_hosts[*]} 安装 $1 下面的多个软件包？\n${folders[*]}"

    if [[ $? -ne 0 ]]
    then
        func_log "不安装 $1" 1
        return 1
    fi

    local a_pack=""

    if [[ -z ${#remote_hosts[*]} ]]
    then
        for a_pack in ${folders[*]}
        do
            func_install_rpm "${a_pack}"
        done
    else
        for domain in ${remote_hosts[*]}
        do
            for a_pack in ${folders[*]}
            do
                func_install_rpm "${a_pack}" "${domain}" $3
            done
        done
    fi
}

func_uninstall_rpm()
{
# 在本机，或者多台机器上删除包
    if [[ -z $1 ]] ; then func_log "参数不足!! "; return 1 ;fi

    local folder=$(func_get_short_name $1)
    local res=0
    local all_rpm=""
    local line=""
    local remote_hosts=($2)

    if [[ -z ${#remote_hosts[*]} ]]
    then
        rpm -qa | grep ${folder} |
        {
            all_rpm=""
            while read line
            do
                all_rpm="${all_rpm} ${line}"
            done

            func_log "准备在 本机 上，删除 ${folder}:\t ${all_rpm}" ${res}
            rpm -e --nodeps ${all_rpm}
            res=$?
            func_log "完成在 本机 上，删除 ${folder}:\t ${all_rpm}" ${res}
        }
    else
        for domain in ${remote_hosts[*]}
        do
            ssh ${domain} "rpm -qa | grep ${folder}" |
            {
                all_rpm=""
                while read line
                do
                    all_rpm="${all_rpm} ${line}"
                done

                func_log "准备在 ${domain} 上，删除 ${folder}:\t ${all_rpm}" ${res}
                ssh $2 "rpm -e --nodeps ${all_rpm} "
                res=$?
                func_log "完成在${domain} 上，删除 ${folder}:\t ${all_rpm}" ${res}
            }
        done
     fi

     return ${res}
}

func_uninstall_rpm_hosts()
{
# 在本机，或者多台机器上删除包
    if [[ -z $1 ]] ; then func_log "参数不足!! "; return 1 ;fi

    func_continue "\n\n\n\n是否删除 $1 ？\n"

    if [[ $? -ne 0 ]]
    then
        func_log "不删除 $1" 1
        return 1
    fi

    func_uninstall_rpm $1 $2
}




# 分发/etc/ntp.conf
function func_scpntpconf()
{
    func_continue '\n\n\n\n是否开始分发ntp配置文件？\n'
    if [[ $? -ne 0 ]]
    then
        func_log "不分发ntp配置文件" 1
        return 1
    fi

    if [[ -z $3 ]] ; then func_log "ERROR 没有提供 HOST"; return 1 ;fi

    host_list=($3)

    for domain in ${host_list[*]}
    do
        ssh ${domain} "systemctl start ntpd.service"
        if [[ $? -ne 0 ]]
        then
            # ssh $1 "yum install -y ntp"
            func_install_rpm $1 $2 ${domain}

            ssh ${domain} "chkconfig ntpd on"
            func_log "ssh ${domain} \"chkconfig ntpd on\""
        fi

        scp conf/ntp.conf ${domain}:/etc/ntp.conf
        func_log "scp conf/ntp.conf ${domain}:/etc/ntp.conf"

        ssh ${domain} "systemctl restart ntpd.service"
        func_log "ssh ${domain} \"systemctl start ntpd.service\""
    done

    func_log "完成分发ntp配置文件" 1
    return $?
}


function func_checkntpstatus()
{
    func_continue '\n\n\n\n是否检查各个节点的ntp服务状态？\n'
    if [[ $? -ne 0 ]]
    then
        func_log "不检查各个节点的ntp服务状态" 1
        return 1
    fi

    host_list=($1)

    for domain in ${host_list[*]}
    do
        res=$(ssh ${domain} "date '+%Y-%m-%d %H:%M:%S'")
        func_log '\n\n\n\n'"${domain} date ${res}" 1
    done

    return $?
}


function func_ssh_disable_firewalld() {

    func_continue '\n\n\n\n所有节点关闭防火墙和selinux（重启生效) ？\n'

    if [[ $? -ne 0 ]]
    then
        func_log "不关闭防火墙和selinux" 1
        return 1
    fi


    if [[ -z $1 ]] ; then echo "ERROR 没有提供 HOST"; return 1 ;fi

    host_list=($1)

    for domain in ${host_list[*]}
    do
        ssh ${domain} "systemctl stop firewalld.service ;
systemctl disable firewalld.service ;
firewall-cmd --state ;
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config "

        func_log "节点关闭防火墙:\t${domain}"
    done
}



func_check_mysql_status()
{
    func_continue "\n\n\n\n是否检查 MySQL 状态？\n"

    if [[ $? -ne 0 ]]
    then
        func_log "不检查 MySQL 状态 $1" 1
        return 2
    fi


    if [[ -z $1 ]]
    then
        systemctl status mysqld > /dev/null 2>&1
        res=$?

        if [[ ${res} -ne 0 ]]
            then
                # 失败
                func_log "本机 上 mysqld 服务没有安装！！！"
            else
                func_log "本机 上 mysqld 服务已经安装！！！"
            fi

    else

        host_list=($1)
        for domain in ${host_list[*]}
        do
            ssh ${domain} 'systemctl status mysqld  > /dev/null 2>&1'

            res=$?
            if [[ ${res} -ne 0 ]]
            then
                # 失败
                func_log "${domain} 上 mysqld 服务没有安装！！！"
            else
                func_log "${domain} 上 mysqld 服务已经安装！！！"
            fi
        done
    fi

    return ${res}
}

func_uninstall_mysql()
{
#    func_uninstall_rpm ${MYSQL_FILE} ${MASTER_HOST}
#    func_log "完成卸载      func_uninstall_rpm ${MYSQL_FILE} ${MASTER_HOST}"
#    func_uninstall_rpm ${PERL_FILE} ${MASTER_HOST}
#    func_log "完成卸载      func_uninstall_rpm ${PERL_FILE} ${MASTER_HOST}"
#    func_uninstall_rpm ${NET_TOOLS_FILE} ${MASTER_HOST}
#    func_log "完成卸载      func_uninstall_rpm ${NET_TOOLS_FILE} ${MASTER_HOST}"

    if [[ -z $1 ]]
    then
        systemctl stop mysqld > /dev/null 2>&1
#        yum remove perl -y
#        yum remove net-tools -y
        yum remove mysql-server -y
        yum remove mysql-common -y
        rm -rf /var/lib/mysql
    else
#    yum remove perl -y ;
#    yum remove net-tools -y ;

        ssh $1 "systemctl stop mysqld > /dev/null 2>&1 ;
yum remove mysql-server -y ;
yum remove mysql-common -y ;
rm -rf /var/lib/mysql"
    fi

    func_log "完成卸载 perl net-tools mysql"
}


func_install_mysql()
{
    local res=0
    local l_NET_TOOLS_FILE="../soft/packages/net-tools/"
    local l_PERL_FILE="../soft/packages/perl/"
    local l_MYSQL_FILE="../soft/packages/mysql/"
    local l_RM_TEMP_PATH="/tmp/install_cdh_temp/"

    if [[ -n ${NET_TOOLS_FILE} ]] ; then l_NET_TOOLS_FILE="${NET_TOOLS_FILE}" ; fi
    if [[ -n ${PERL_FILE} ]] ; then l_PERL_FILE="${PERL_FILE}" ; fi
    if [[ -n ${MYSQL_FILE} ]] ; then l_MYSQL_FILE="${MYSQL_FILE}" ; fi
    if [[ -n ${RM_TEMP_PATH} ]] ; then l_RM_TEMP_PATH="${RM_TEMP_PATH}" ; fi

    if [[ -z $1 ]]
    then
        systemctl status mysqld  > /dev/null 2>&1
        res=$?
    else
        ssh $1 'systemctl status mysqld  > /dev/null 2>&1'
        res=$?
    fi


    if [[ ${res} -ne 0 ]]
    then
        func_continue '\n\n\n开始安装 MySQL ?\n'
        res=$?
    else
        func_continue '\n\n\n卸载老版本，之后重新安装 MySQL ?\n'
        res=$?
        if [[ ${res} == 0 ]]
        then
            func_uninstall_mysql $1
        fi
    fi

    if [[ ${res} == 0 ]]
    then
#        func_install_rpm ${l_NET_TOOLS_FILE} $1 ${l_RM_TEMP_PATH}
#        func_install_rpm ${l_PERL_FILE} $1 ${l_RM_TEMP_PATH}
        func_install_rpm ${l_MYSQL_FILE} $1 ${l_RM_TEMP_PATH}
        func_log "安装 MySQL     func_install_rpm ${l_MYSQL_FILE} $1 ${l_RM_TEMP_PATH}"
    fi

}

func_start_mysql()
{
    local res=0

    func_continue '\n\n\n是否启动 MySQL ?\n'

    res=$?

    if [[ ${res} -ne 0 ]]
    then
        func_log "不启动 MySQL" ${res}
        return ${res}
    fi

    if [[ -z $1 ]]
    then
        systemctl start mysqld > /dev/null 2>&1
    else
        ssh $1 'systemctl start mysqld > /dev/null 2>&1'
    fi

    res=$?

    func_log "检查 MySQL 是否启动:  [ ${res} ] 'systemctl start mysqld > /dev/null 2>&1'" ${res}


    if [[ ${res} -eq 0 ]]
    then
        # 成功
        func_log "mysql 服务已经启动成功" ${res}
    else
        # 失败
        func_log "mysql 服务启动失败" ${res}
    fi

    return ${res}
}


func_get_mysql_passwd()
{
    local res=0

    if [[ -z $1 ]]
    then
        line=$(awk '/temporary password/{print}' /var/log/mysqld.log 2>/dev/null | sed -n '$p')

    else
        line=$(ssh $1 "awk '/temporary password/{print}' /var/log/mysqld.log 2>/dev/null | sed -n '\$p'" )
    fi

	res=$?

	line=$(echo ${line} | awk -F ' ' '{ print $11}')

	echo "${line}"

	return ${res}
}

func_change_mysql_passwd()
{
    local res=0
    local exec_cmd=""

    if [[ -z $2 ]] ; then func_log "参数不足!! "; return 1 ;fi

    exec_cmd="mysql -u root --password=\"$1\" -b --connect-expired-password -e \"SET PASSWORD=PASSWORD('$2');\""

    if [[ -z $3 ]]
    then
        echo ${exec_cmd} | sh

    else
        ssh $3 ${exec_cmd}
    fi

    res=$?
    if [[ ${res} == 0 ]]
    then
        func_log "密码修改成功"
    else
        func_log "密码修改失败"
    fi

    res=$?

    func_log "修改 MYSQL 密码:\t${exec_cmd}" ${res}

    return ${res}
}


func_set_mysql_root()
{
    local res=0
    local exec_cmd=""

    if [[ -z $1 ]] ; then func_log "参数不足!! "; return 1 ;fi

    exec_cmd="mysql -uroot -p$1 -e \"$(sed 's/${MYSQL_PWD}/'$1'/g' dbscript/mysql.sql)\""

    if [[ -z $2 ]]
    then
        echo ${exec_cmd} | sh
    else
        ssh $2 ${exec_cmd}
    fi

    res=$?

    func_log '授权 root 权限:\t func_set_mysql_root '"${exec_cmd}" ${res}

    if [[ ${res} == 0 ]]
    then
        func_log "授权成功" 0
    else
        func_log "授权失败" 1
    fi

    return ${res}
}

func_modify_mysql()
{
    if [[ -z $1 ]] ; then func_log "参数不足!! "; return 1 ;fi

    local res=0

    func_continue '\n\n\n是否修改 MySQL 默认密码、授权 root 权限 ?\n'

    res=$?

    if [[ ${res} -ne 0 ]]
    then
        func_log "跳过:\t修改 MySQL 默认密码、授权 root 权限" ${res}
        return ${res}
    fi

    local MYSQL_TEMP_PWD=""

    # Mysql 命令行参数:  -O, --set-variable=name  //设置变量用法是--set-variable=var_name=var_value
    # 查询 MYSQL 临时密码

    MYSQL_TEMP_PWD=$(func_get_mysql_passwd $2)

    res=$?

    func_log "查询MYSQL 临时密码:\t${MYSQL_TEMP_PWD}" ${res}

    # 修改 MYSQL 密码
    func_change_mysql_passwd ${MYSQL_TEMP_PWD} $1 $2


    # 授权 root 权限
    func_set_mysql_root $1 $2

    res=$?

    return ${res}
}


# 提供用户交互行 选择是否删除数据库继续
function func_drop_db()
{
    if [[ -z $1 ]] ; then func_log "参数不足!! "; return 1 ;fi

    local res=0

    func_continue '\n\n\n\n是否继续删除数据库：(y:继续删除，s:跳过不删除）\n'

    res=$?

    if [[ ${res} -ne 0 ]]
    then
        func_log "不删除数据库" ${res}
        return ${res}
    fi

    if [[ -z $2 ]]
    then
        mysql -uroot -p$1 -e "$(cat dbscript/droptable.sql)"
    else
        ssh $2 "mysql -uroot -p$1 -e \"$(cat dbscript/droptable.sql)\""
    fi
}


# 创建数据库
function func_create_db()
{
    if [[ -z $1 ]] ; then func_log "参数不足!! "; return 1 ;fi

    func_continue '\n\n\n\n是否继续创建数据库：(y:继续创建，s:跳过不创建）\n'

    res=$?

    if [[ ${res} -ne 0 ]]
    then
        func_log "不创建数据库" ${res}
        return ${res}
    fi

    if [[ -z $2 ]]
    then
        mysql -uroot -p$1 -e "$(cat dbscript/createtable.sql)"
        systemctl restart mysqld
        res=$?
    else
        ssh $2 "mysql -uroot -p$1 -e \"$(cat dbscript/createtable.sql)\""
        ssh $2 "systemctl restart mysqld"
        res=$?
    fi

    return ${res}
}







# 安装Java环境配置
function func_install_java_0()
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



    local remote_host=""
    local remote_path="/tmp/install_cdh_temp/"
    local java_version="jdk1.8.0_221"
    local java_file="./soft/jdk-8u221-linux-x64.tar.gz"

    if [[ -n $1 ]] ; then java_version="$1"; fi
    if [[ -n $2 ]] ; then java_file="$2"; fi
    if [[ -n $3 ]] ; then remote_host="$3" ;fi
    if [[ -n $4 ]] ; then remote_path="$4"; fi


    local real_file=$(func_get_short_name "${java_file}")

    local java_home=""

    if [[ ${#remote_path} -lt 6 ]]
    then
        func_log "文件夹太短" 4
        return 4
    fi

    if [[ -z "${remote_host}" ]]
    then
        java_home=$(awk '/JAVA_HOME=/{print}' /etc/profile)
    else
        java_home=$(ssh ${remote_host} "awk '/JAVA_HOME=/{print}' /etc/profile")
    fi

    if [[ -n "${java_home}" ]]
    then
        #成功
        func_log "JAVA_HOME 已经配置，无须安装配置" 0
        return 0
    fi


    local exec_cmd="rm -rf /opt/${java_version} ;
tar -zxvf ${remote_path}${real_file} -C /opt/ ;
echo -e \"\\n\\n# ## set java env ##\" >> /etc/profile ;
echo 'export JAVA_HOME=/opt/${java_version}' >> /etc/profile ;
echo 'export JRE_HOME=\$JAVA_HOME/jre' >>  /etc/profile ;
echo 'export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar' >> /etc/profile ;
echo 'export PATH=\$PATH:\$JAVA_HOME/bin' >> /etc/profile ;
echo -e \"# ## set java env ##\\n\\n\" >> /etc/profile ;
source /etc/profile ;
rm -rf ${remote_path} ;
mkdir -p /usr/java ;
ln -s /opt/${java_version} /usr/java/${java_version} "


    if [[ -n "${remote_host}" ]]
    then
        ssh ${remote_host} "mkdir -p ${remote_path}"
        scp ${java_file} ${remote_host}:${remote_path}

        ssh ${remote_host} ${exec_cmd}

        res=$?

        func_log "JAVA_HOME 没有配置，重新安装配置: ssh ${remote_host} ${exec_cmd}" ${res}
    else
        echo ${exec_cmd} | sh

        res=$?
        func_log "JAVA_HOME 没有配置，重新安装配置: echo ${exec_cmd} | sh" ${res}
    fi

    return ${res}
}

func_install_java()
{
    local res=0

    func_continue '\n\n\n开始安装 JAVA 环境 ？\n'

    res=$?

    if [[ ${res} -ne 0 ]]
    then
        func_log "不安装 JAVA" ${res}
        return ${res}
    fi


    host_list=($3)

    for domain in ${host_list[*]}
    do
        func_uninstall_rpm "openjdk"  ${domain}
        res=$?
        func_log " :${domain} 删除 openjdk 完成" ${res}

        func_install_java_0 $1 $2 ${domain} $4
        res=$?
        func_log " :${domain} 安装 JAVA 完成"  ${res}
    done
}



# 安装cm
function func_install_cm()
{
    local remote_host=""
    local cm_version="cm-5.13.0"
    local cm_file="../soft/cm/cloudera-manager-centos7-cm5.13.0_x86_64.tar.gz"
    local rm_temp_path="/tmp/install_cdh_temp/"
    local l_psmisc="../soft/packages/psmisc/"


    if [[ -n $1 ]] ; then cm_version="$1"; fi
    if [[ -n $2 ]] ; then cm_file="$2"; fi
    if [[ -n $3 ]] ; then remote_host="$3";fi
    if [[ -n $4 ]] ; then rm_temp_path="$4"; fi

    local real_file=$(func_get_short_name "${cm_file}")


    if [[ ${#rm_temp_path} -lt 6 ]]
    then
        func_log "文件夹太短" 4
        return 4
    fi

    local res=0

    # func_install_rpm ${l_psmisc} ${rm_temp_path} ${remote_host}


    local exec_cmd_1="rm -rf ${rm_temp_path} ;
rm -rf /opt/${cm_version} ;
mkdir -p ${rm_temp_path} ;
umount /opt/${cm_version}/run/cloudera-scm-agent/process "

    local exec_cmd_2="tar -zxvf ${rm_temp_path}${real_file} -C /opt/"

    local exec_cmd_iso="umount /root/mnt/cd ;
mkdir -p /root/mnt/cd ;
mount /dev/cdrom /root/mnt/cd ;
tar -zxvf /root/mnt/cd/cm/${real_file} -C /opt/ "


    local exec_cmd_local="rm -rf /opt/${cm_version} ;
umount /opt/${cm_version}/run/cloudera-scm-agent/process ;
tar -zxvf ${cm_file} -C /opt/"


    if [[ -z "${remote_host}" ]]
    then

        echo ${exec_cmd_local} | sh
        res=$?
        func_log "echo ${exec_cmd_local} | sh" ${res}

    else

        ssh ${remote_host} ${exec_cmd_1}
        res=$?
        func_log "ssh ${remote_host} ${exec_cmd_1}" ${res}


#       这里是从笔记本网络拷 tar 文件 过去
#        scp ${cm_file} ${remote_host}:${rm_temp_path}
#        res=$?
#        func_log "scp ${cm_file} ${remote_host}:${rm_temp_path}" ${res}

#        ssh ${remote_host} ${exec_cmd_2}
#        res=$?
#        func_log "ssh ${remote_host} ${exec_cmd_2}" ${res}
#       这里是从笔记本网络拷 tar 文件 过去


#       这里是从 DVD ISO 解压 tar 文件 过去
        ssh ${remote_host} ${exec_cmd_iso}
        res=$?
        func_log "ssh ${remote_host} ${exec_cmd_iso}" ${res}
#       这里是从 DVD ISO 解压 tar 文件 过去

     fi

     return ${res}

#    tar -zxvf soft/cloudera-manager-centos7-cm5.13.0_x86_64.tar.gz -C /opt/
#    ls /opt/
}


function func_config_cm_ini()
{
    local cm_version="cm-5.13.0"
    local mysql_pwd="Risk@2018"
    local remote_host=""
    local var_hosts=()

    local res


    if [[ -n $1 ]] ; then cm_version="$1"; fi
    if [[ -n $2 ]] ; then mysql_pwd="$2"; fi
    if [[ -n $3 ]] ; then remote_host="$3";fi
    if [[ -n $4 ]] ; then var_hosts=($4); fi

    func_continue '\n\n\n配置各节点 CM Agent的config.ini 文件？\n'

    res=$?

    if [[ ${res} -ne 0 ]]
    then
        func_log "不配置各节点 CM Agent的config.ini 文件" ${res}
        return ${res}
    fi

    if [[ -z ${remote_host} ]] ; then func_log "HOST 为空" 1; return 1;fi


    # 配置各节点 CM Agent的config.ini 文件
    for domain in ${var_hosts[*]}
    do
#        ssh ${domain} "sed -i 's/^server_host=10\\.2\\.206\\.18/server_host="${remote_host}"/g' /opt/${cm_version}/etc/cloudera-scm-agent/config.ini"
        ssh ${domain} "sed -i 's/^server_host=localhost/server_host=${remote_host}/g' /opt/${cm_version}/etc/cloudera-scm-agent/config.ini"
        func_log "配置 ${domain} 节点 CM Agent的config.ini 文件 server_host=${remote_host}"
    done

    res=$?

    return ${res}
}



function func_config_cm_db()
{
    local cm_version="cm-5.13.0"
    local mysql_pwd="Risk@2018"
    local remote_host=""

    local res

    if [[ -n $1 ]] ; then cm_version="$1"; fi
    if [[ -n $2 ]] ; then mysql_pwd="$2"; fi
    if [[ -n $3 ]] ; then remote_host="$3";fi

    func_continue '\n\n\n在主节点初始化 CM 的数据库？\n'

    res=$?

    if [[ ${res} -ne 0 ]]
    then
        func_log "不在主节点初始化 CM 的数据库" ${res}
        return ${res}
    fi


    if [[ -z ${remote_host} ]] ; then func_log "HOST 为空" 1; return 1;fi


    # 在主节点初始化 CM 的数据库
    local exec_cmd="source /etc/profile ;
sh /opt/${cm_version}/share/cmf/schema/scm_prepare_database.sh -v mysql -uroot --password='${mysql_pwd}' scm scm ${mysql_pwd}"
    ssh ${remote_host} "${exec_cmd}"

    res=$?
    func_log "在主节点初始化 CM 的数据库: ssh ${remote_host} \"${exec_cmd}\"" ${res}
    return ${res}
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


function func_install_mysql_driver()
{
    local remote_host=""
    local mysql_con="../soft/mysql-connector/mysql-connector-java-5.1.44-bin.jar"
    local cdh_version="cm-5.13.0"
    local java_home="/opt/jdk1.8.0_221"


    if [[ -n $1 ]] ; then mysql_con="$1"; fi
    if [[ -n $2 ]] ; then cdh_version="$2"; fi
    if [[ -n $3 ]] ; then java_home="/opt/$3"; fi
    if [[ -n $4 ]] ; then remote_host="$4"; fi

    local real_file=$(func_get_short_name "${mysql_con}")

    local exec_cmd="chown cloudera-scm:cloudera-scm /opt/${cdh_version}/share/cmf/common_jars/${real_file} ;
ln -f -s /opt/${cdh_version}/share/cmf/common_jars/${real_file} /opt/${cdh_version}/share/cmf/lib/mysql-connector-java.jar ;
mkdir -p /usr/share/java ;
ln -f -s /opt/${cdh_version}/share/cmf/common_jars/${real_file} /usr/share/java/mysql-connector-java.jar "



    if [[ -z "${remote_host}" ]]
    then
        cp -f ${mysql_con} /opt/${cdh_version}/share/cmf/common_jars/
        res=$?
        func_log "cp -f ${mysql_con} /opt/${cdh_version}/share/cmf/common_jars/" ${res}

        cp -f ${mysql_con} ${java_home}/jre/lib/ext/
        res=$?
        func_log "cp -f ${mysql_con} ${java_home}/jre/lib/ext/" ${res}

        echo ${exec_cmd} | sh
        res=$?
        func_log "echo ${exec_cmd} | sh" ${res}
    else
        scp ${mysql_con} ${remote_host}:/opt/${cdh_version}/share/cmf/common_jars/
        res=$?
        func_log "scp ${mysql_con} ${remote_host}:/opt/${cdh_version}/share/cmf/common_jars/" ${res}

        scp ${mysql_con} ${remote_host}:${java_home}/jre/lib/ext/
        res=$?
        func_log "scp ${mysql_con} ${remote_host}:${java_home}/jre/lib/ext/" ${res}

        ssh ${remote_host} ${exec_cmd}
        res=$?
        func_log "ssh ${remote_host} ${exec_cmd}" ${res}
     fi

     return ${res}


#    scp ${mysql_con} ${remote_host}:/usr/share/java/


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





function generator_reboot_remote() {
    echo "ssh $1 \"reboot\"" >> script/ssh_reboot_remote.sh
}

function generator_scm_start() {
     echo "ssh $1  \"/opt/cm-5.13.0/etc/init.d/cloudera-scm-agent start\"" >> script/ssh_scm_start.sh
}

function generator_scm_stop() {
     echo "ssh $1 \"/opt/cm-5.13.0/etc/init.d/cloudera-scm-agent stop\"" >> script/ssh_scm_stop.sh
}
