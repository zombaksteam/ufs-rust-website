#!/bin/bash

DEFINED="1"
SCRIPT_DIR="$(realpath "$0")"
SCRIPT_DIR=`echo "${SCRIPT_DIR}" | sed -e 's/\/[^\/]\+$//'`
. ${SCRIPT_DIR}/funcs.sh

is_docker_container_exists "${CONF_DOCKER_CON_NAME}"
if [[ ${RESULT} == "1" ]]; then
	echo "Container with name '${CONF_DOCKER_CON_NAME}' is already exists!"
	exit 1
fi

# Check docker network
is_docker_network_exists "${CONF_DOCKER_NET_NAME}"
if [[ ${RESULT} == "0" ]]; then
	echo "Ok, docker network '${CONF_DOCKER_NET_NAME}' is not exists, will try to create new one..."
	get_docker_next_network_free_ip
	# Try to create new docker network
	docker network create --subnet=${RESULT} ${CONF_DOCKER_NET_NAME}
	if [[ $? != 0 ]]; then
		echo "Error, can't create new docker network with ip '${RESULT}' and name '${CONF_DOCKER_NET_NAME}'!"
		exit 1
	fi
fi

# Check docker network again
is_docker_network_exists "${CONF_DOCKER_NET_NAME}"
if [[ ${RESULT} == "0" ]]; then
	echo "Docker network '${CONF_DOCKER_NET_NAME}' is not exists!"
	exit 1
fi

# Make container IP
make_docker_container_ip "${CONF_DOCKER_NET_NAME}"
CONTAINER_IP="${RESULT}"

# Check for directory
if [[ -d "${SCRIPT_DIR}/src" ]]; then
	echo "Error, src directory is already exists!"
	exit 1
fi

# Pull fresh code
mkdir "${SCRIPT_DIR}/src"
if [[ $? != 0 ]]; then
	echo "Error, can't create src directory!"
	exit 1
fi

git clone https://github.com/zombaksteam/ufs-rust-website.git "${SCRIPT_DIR}/src"
if [[ $? != 0 ]]; then
	echo "Error, can't clone site repo!"
	exit 1
fi

# Make a new build
cd "${SCRIPT_DIR}/src" && make build && cd "${SCRIPT_DIR}"
if [[ $? != 0 ]]; then
	echo "Error, can't build docker image!"
	exit 1
fi

# Remove src files
rm -R "${SCRIPT_DIR}/src"

# Create new container
docker run \
	--name ${CONF_DOCKER_CON_NAME} \
	--net ${CONF_DOCKER_NET_NAME} \
	--ip ${CONTAINER_IP} \
	-e MYSQL_USER="${CONF_ENV_MYSQL_USER}" \
	-e MYSQL_PASS="${CONF_ENV_MYSQL_PASS}" \
	-e MYSQL_BASE="${CONF_ENV_MYSQL_BASE}" \
	-e MYSQL_HOST="${CONF_ENV_MYSQL_HOST}" \
	-v /etc/timezone:/etc/timezone:ro \
	-d -it ufs-web-server:latest
