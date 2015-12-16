#!/bin/bash 

AGENT=$1
STATUS=$2

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $SCRIPT_DIR/../images
scp -vp $STATUS.png okramer@omar.ossim.org:$AGENT_status.png
popd
