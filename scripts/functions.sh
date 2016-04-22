#!/bin/bash


##
# Example use: getOsInfo os major_version os_arch
#
function getOsInfo {
# Determine OS platform
#        UNAME=$(uname | tr "[:upper:]" "[:lower:]")
        local DISTRO=
        local majorVersion=
        local osArch=`uname -i`
        if [ -f /etc/redhat-release ] ; then
                DISTRO=`cat /etc/redhat-release | cut -d' ' -f1`
                majorVersion=`cat /etc/redhat-release | grep  -o "[0-9]*\.[0-9]*\.*[0-9]*" | cut -d'.' -f1`
        fi
        eval "$1=${DISTRO}"
        eval "$2=${majorVersion}"
        eval "$3=${osArch}"
}

##
# Example use: getTimeStamp TIMESTAMP
#
function getTimeStamp {
        eval $1=`date +%Y-%m-%d-%H%M`
}
