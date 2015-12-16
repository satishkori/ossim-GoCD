#!/bin/bash 

AGENT=$1
STATUS=$2
echo
echo "upload_badge.sh: AGENT=<$AGENT>, STATUS=<$STATUS>"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $SCRIPT_DIR/../images
CMD="scp -vp $STATUS.png go@omar.ossim.org:${AGENT}_status.png"
echo "command: $CMD"
$CMD
if [ $? != 0 ]; then
  echo "upload_badge.sh: Error encountered running command <$CMD>."; echo
  popd
  exit 1
fi
echo
popd
exit 0


