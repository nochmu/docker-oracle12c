#!/bin/sh
#
#
#

IMAGE=oracle/database:12.2.0.1-ee
ORACLE_SID=CDB
ORACLE_PDB=PDB
ORACLE_PWD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)

# print and execute the command line
function execv {
    echo "$@"
    "$@"
}

function show_help {
    echo "Creates a new database container"
    echo "Usage: $0 <container-suffix>"
}
 
function crt_container {
    container_name=oracle12c_$1
    execv docker run -d  --name $container_name \
     -p 1521 -p 5500 \
     -e ORACLE_SID=$ORACLE_SID -e ORACLE_PDB=$ORACLE_PDB \
     -e ORACLE_PWD=$ORACLE_PWD \
     -v ${container_name}_data:/opt/oracle/oradata \
     $IMAGE
}

function show_container_info {
    echo "Name:     ${container_name}"    
    echo "Port:     1521/tcp -> $(docker port $container_name 1521)"
    echo "          5500/tcp -> $(docker port $container_name 5500)"
    echo "SID:      ${ORACLE_SID}"
    echo "PDB:      ${ORACLE_PDB}"
    echo "Password: ${ORACLE_PWD}"
    echo "Volumes:  ${container_name}_data:/opt/oracle/oradata"
}

if [ -z "$1" ]   # empty arguments? 
then
	show_help
else 
	crt_container $1 && 
	show_container_info
fi
