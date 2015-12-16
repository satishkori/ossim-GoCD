#!/bin/bash 

AGENT=$1
STATUS=$2
echo
echo "upload_badge.sh: AGENT=<$AGENT>, STATUS=<$STATUS>"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $SCRIPT_DIR/../images
CMD="scp -vp $STATUS.png okramer@omar.ossim.org:$AGENT_status.png"
echo "command: $CMD"
$CMD
echo
popd

