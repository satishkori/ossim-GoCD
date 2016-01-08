#!/bin/bash
RESOURCE=$1
BRANCH=$2
STATUS=$3
STAGE=$4
echo
echo "upload_badge.sh: RESOURCE=<$RESOURCE>, STATUS=<$STATUS>"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $SCRIPT_DIR/../images
if [ -z "$STAGE" ]; then
CMD="scp -v ${STATUS}.svg go@omar.ossim.org:~/status/${RESOURCE}_${BRANCH}_status.svg"
else
CMD="scp -v ${STAGE}-${STATUS}.svg go@omar.ossim.org:~/status/${RESOURCE}_${BRANCH}_status.svg"
fi   
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


