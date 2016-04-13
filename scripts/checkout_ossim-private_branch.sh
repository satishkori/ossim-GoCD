#!/bin/bash

if [ "$#" -eq 1 ]; then
   BRANCH=$1
   echo "checkout_ossim-private_branch: ${BRANCH}"
   pushd ../../ossim-private
   command="git checkout $BRANCH"
   echo $command
   eval $command
   popd
fi
exit 0
