#!/bin/bash 


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $SCRIPT_DIR/../../ossim

cp -f ../ossim-GoCD/images/$1.png current_status.png
#git commit -a -m "auto-update from GoCD" 
#git push

popd
