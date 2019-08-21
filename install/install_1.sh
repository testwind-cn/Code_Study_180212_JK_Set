#!/bin/bash

dbpwd=Risk@2018

. ./fuctions.sh

# 获取配置文件中的主机
var_hosts=`awk -F " " '{print $2}' conf/hosts.cfg`

#---------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------- step 1 ---------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------
#安装CM

install_cm_func

#安装本地mysql driver
install_mysql_driver_func

for domain in $var_hosts ; do
    scp_mysql_driver_func $domain
done

#配置主节点 CM Agent的config.ini 文件
master_host=`awk -F " " 'NR==1{print $2}' conf/hosts.cfg`
sed -i "s/^server_host=localhost/server_host=$master_host/g" /opt/cm-5.13.0/etc/cloudera-scm-agent/config.ini

#分发CM到各个节点

for domain in $var_hosts ; do
    if test $master_host != $domain
    then
        scp -r /opt/cm-5.13.0 $domain:/opt
    else
        echo "Master node is not needed to send the cm folder"
    fi
done


sh /opt/cm-5.13.0/share/cmf/schema/scm_prepare_database.sh mysql -uroot -p$dbpwd scm scm
#
cp -f soft/CDH-5.11.0-1.cdh5.11.0.p0.34-el7.parcel /opt/cloudera/parcel-repo/
cp -f soft/CDH-5.11.0-1.cdh5.11.0.p0.34-el7.parcel.sha1 /opt/cloudera/parcel-repo/CDH-5.13.0-1.cdh5.13.0.p0.29-el7.parcel.sha
cp -f soft/manifest.json /opt/cloudera/parcel-repo/




for domain in $var_hosts ; do
    ssh $domain "useradd --system --home=/opt/cm-5.13.0/run/cloudera-scm-server/ --no-create-home --shell=/bin/false cloudera-scm"
    ssh $domain "chown cloudera-scm.cloudera-scm /opt -R"
    ssh $domain "chown cloudera-scm.cloudera-scm /var/log/cloudera-scm-agent -R"
done


#lsof -i:7182

