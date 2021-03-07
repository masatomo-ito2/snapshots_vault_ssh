#! /bin/bash

set  -x
exec > >(tee /tmp/tf-user-data.log|logger -t _bootstrap ) 2>&1

logger() {
    DT=$(date '+%Y/%m/%d %H:%M:%S')
    echo "$DT $0: $1"
}

logger "running"

echo set -o vi >> /home/ubuntu/.bashrc

