#!/bin/bash

if [[ ${DEFINED} == "" ]]; then
	echo "Only for including!"
	exit 1
fi

config_load_vars() {
	for CFILE in "${SCRIPT_DIR}/config"/*
	do
		VARNAME="$(basename "${CFILE}")"
		VARVALUE="$(cat "${CFILE}")"
		printf -v "${VARNAME}" '%s' "${VARVALUE}"
	done
}

check_config_file() {
	CFNAME="$1"
	if [[ ! -f "${SCRIPT_DIR}/config/${CFNAME}" ]]; then
		echo "Config file '${CFNAME}' is not exists!"
		exit 1
	fi
}

# Load config files
config_load_vars

# Check for config files
check_config_file "CONF_DOCKER_CON_NAME"
check_config_file "CONF_DOCKER_NET_NAME"
check_config_file "CONF_ENV_MYSQL_BASE"
check_config_file "CONF_ENV_MYSQL_HOST"
check_config_file "CONF_ENV_MYSQL_PASS"
check_config_file "CONF_ENV_MYSQL_USER"

is_docker_container_exists() {
	CON_NAME="$1"
	RET=`docker ps -a --no-trunc --format "| {{.Names}} |" | grep " ${CON_NAME} "`
	if [[ ${RET} != "" ]]; then
		printf -v "RESULT" '%s' "1"
	else
		printf -v "RESULT" '%s' "0"
	fi
}

is_docker_network_exists() {
	NET_NAME="$1"
	RET=`docker network ls | grep "bridge" | grep " ${NET_NAME} " | awk '{ print $2 }'`
	if [[ ${RET} != "" ]]; then
		printf -v "RESULT" '%s' "1"
	else
		printf -v "RESULT" '%s' "0"
	fi
}

get_docker_next_network_free_ip() {
	LAST_NET_IP=`docker network ls | grep -v "NAME" | grep -v "none" | \
	grep -v "host" | awk '{ print $2 }' | xargs -n 1 docker network inspect | \
	grep "\"Subnet\":" | awk '{ print $2 }' | sort | tail -n1`
	LAST_NET_IP=`echo "${LAST_NET_IP}" | sed -e 's/^"//' -e 's/",$//'`
	LAST_NET_IP=`echo "${LAST_NET_IP}" | sed -e 's/.[[:digit:]]\+$//'`
	LAST_NET_IP=`echo "${LAST_NET_IP}" | sed -e 's/.[[:digit:]]\+$//'`
	LAST_NET_IP=`echo "${LAST_NET_IP}" | sed -e 's/.[[:digit:]]\+$//'`
	IP_START_PO=`echo "${LAST_NET_IP}" | sed -e 's/.[[:digit:]]\+$//'`
	LAST_NET_IP=`echo "${LAST_NET_IP}" | sed -e 's/^[[:digit:]]\+.//'`
	LAST_NET_IP=$((${LAST_NET_IP}+1))
	NEW_NET_IP="${IP_START_PO}.${LAST_NET_IP}.0.0/16"
	printf -v "RESULT" '%s' "${NEW_NET_IP}"
}

make_docker_container_ip() {
	NET_NAME="$1"
	NEW_IP=`docker network ls | grep " ${NET_NAME} " | awk '{ print $2 }' | \
	xargs -n 1 docker network inspect | grep "\"Subnet\":" | awk '{ print $2 }' | \
	sed -e 's/^"//' -e 's/"$//' -e 's/\/[[:digit:]]\+$//'`
	NEW_IP=`echo "${NEW_IP}" | sed -e 's/.[[:digit:]]\+$//'`
	NEW_IP="${NEW_IP}.2"
	printf -v "RESULT" '%s' "${NEW_IP}"
}
