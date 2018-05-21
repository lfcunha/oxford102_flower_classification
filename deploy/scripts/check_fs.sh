#!/usr/bin/env bash

device_name=$1

file -s ${device_name} | grep -q '"${device_name}: data"' &> /dev/null

RESULT=$?

if [ $RESULT -eq 0 ]; then
  echo fs exists
else
  echo creating fs
  sh ./mkfs.sh ${device_name}
fi
