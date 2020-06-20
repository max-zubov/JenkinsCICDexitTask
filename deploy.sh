#!/bin/bash

//shell copyed from git repository

if [ -z "$1" ]
then 
    exit 0
fi

if [ -f /opt/1641-backup/$1 ]
then 
    cd /opt/1641-backup
    tar xzf $1
    ap=${1%.tar.gz}.war
    
    if [ -f /opt/1641-backup/$ap ]
    then 
        scp ./$ap wildfly@vm-b:/opt/wildfly-19/standalone/deployments/
        mv ./current/$ap ./old/
        mv ./$ap ./current
    fi
fi

