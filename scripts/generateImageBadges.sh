#!/bin/bash
#
# Genreated using this site API:
#
#    http://shields.io
# 
# scroll to the bottom of the page to look at different styling
# and color API's 
#
pushd `dirname $0` >/dev/null
export SCRIPT_DIR=`pwd -P`
popd >/dev/null

pushd $SCRIPT_DIR/.. >/dev/null
export ROOT_DIR=$PWD
popd

FAIL_COLOR=C24737
PASS_COLOR=3E841D
INPROGRESS_COLOR=E0D754
wget "http://img.shields.io/badge/build-failed-${FAIL_COLOR}.svg?style=plastic" -O $ROOT_DIR/images/build-failed.svg
wget "http://img.shields.io/badge/build-passed-${PASS_COLOR}.svg?style=plastic" -O $ROOT_DIR/images/build-passed.svg
wget "http://img.shields.io/badge/test-failed-${FAIL_COLOR}.svg?style=plastic" -O $ROOT_DIR/images/test-failed.svg
wget "http://img.shields.io/badge/test-passed-${PASS_COLOR}.svg?style=plastic" -O $ROOT_DIR/images/test-passed.svg
wget "http://img.shields.io/badge/all-passed-${PASS_COLOR}.svg?style=plastic" -O $ROOT_DIR/images/all-passed.svg
wget "http://img.shields.io/badge/build-started-${INPROGRESS_COLOR}.svg?style=plastic" -O $ROOT_DIR/images/build-started.svg
wget "http://img.shields.io/badge/test-started-${INPROGRESS_COLOR}.svg?style=plastic" -O $ROOT_DIR/images/test-started.svg
wget "http://img.shields.io/badge/-canceled-${FAIL_COLOR}.svg?style=plastic" -O $ROOT_DIR/images/all-canceled.svg
