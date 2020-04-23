#!/bin/bash

DEFINED="1"
SCRIPT_DIR="$(realpath "$0")"
SCRIPT_DIR=`echo "${SCRIPT_DIR}" | sed -e 's/\/[^\/]\+$//'`
. ${SCRIPT_DIR}/funcs.sh

docker stop ${CONF_DOCKER_CON_NAME}
docker rm ${CONF_DOCKER_CON_NAME}
docker network rm ${CONF_DOCKER_NET_NAME}
