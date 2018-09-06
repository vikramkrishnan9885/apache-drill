#!/bin/bash

if [[ -z "${FILENAME_TO_ENABLE}" ]]; then
    filename=$1
else
    filename="${FILENAME_TO_ENABLE}"
fi


sudo update-rc.d -f $filename defaults
sudo update-rc.d -f $filename enable