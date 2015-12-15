#!/bin/bash 


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $SCRIPT_DIR/../images

cp -f $1.png current_pipeline_status.png
git commit -a -m "auto-update from GoCD" 
git push

popd
