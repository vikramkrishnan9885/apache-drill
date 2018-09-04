#!/bin/bash

filename=$1

sudo update-rc.d -f $filename defaults
sudo update-rc.d -f $filename enable