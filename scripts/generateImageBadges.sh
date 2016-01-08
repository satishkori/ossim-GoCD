#!/bin/bash
pushd `dirname $0` >/dev/null
export SCRIPT_DIR=`pwd -P`
popd >/dev/null

pushd $SCRIPT_DIR/.. >/dev/null
export ROOT_DIR=$PWD
popd

FAIL_COLOR=C24737
PASS_COLOR=3E841D
INPROGRESS_COLOR=E0D754
wget https://img.shields.io/badge/build-failed-${FAIL_COLOR}.svg -O $ROOT_DIR/images/build-failed.svg
wget https://img.shields.io/badge/build-passed-${PASS_COLOR}.svg -O $ROOT_DIR/images/build-passed.svg
wget https://img.shields.io/badge/test-failed-${FAIL_COLOR}.svg -O $ROOT_DIR/images/test-failed.svg
wget https://img.shields.io/badge/test-passed-${PASS_COLOR}.svg -O $ROOT_DIR/images/test-passed.svg
wget https://img.shields.io/badge/all-passed-${PASS_COLOR}.svg -O $ROOT_DIR/images/all-passed.svg
wget https://img.shields.io/badge/build-started-${INPROGRESS_COLOR}.svg -O $ROOT_DIR/images/build-started.svg
wget https://img.shields.io/badge/test-started-${INPROGRESS_COLOR}.svg -O $ROOT_DIR/images/test-started.svg
