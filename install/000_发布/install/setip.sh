#!/bin/bash

#载入外部函数
. fuctions.sh

# 生成SSH Key
expect ./expect/auto_keygen.exp
func_log "生成SSH Key"


# 获取配置文件中的密码
PASSWDS=`awk -F " " '{print $3}' ./conf/hosts.cfg`
func_log "获取配置文件中的密码: ${PASSWDS}"