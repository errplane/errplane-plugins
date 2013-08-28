#!/usr/bin/env bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 [staging|prod] version"
fi

version=$2
hosts="w1.apiv3 w2.apiv3"
dir="/data/configuration_server/shared/plugins/"
if [ "$1" == "staging" ]; then
    hosts="staging.apiv3"
    dir="/mnt/configuration_server/shared/plugins/"
fi

for host in `echo $hosts | tr ' ' '\n'`; do
    ssh $host "sudo -u errplane sh -c 'cd $dir && \
    wget https://s3.amazonaws.com/errplane-agent/plugins.$version.tar.gz && \
    echo -n $version > version'"
done
