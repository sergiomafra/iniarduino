#!/bin/bash

BASE_PATH=$(pwd)
INIARD_PATH="${BASE_PATH}/iniarduino.sh"
INIARD_CMD_PATH="/usr/local/bin/iniarduino"
WHOAMI=$(whoami)

sudo cp $INIARD_PATH $INIARD_CMD_PATH
sudo chmod 0755 $INIARD_CMD_PATH
sudo chown ${WHOAMI}: $INIARD_CMD_PATH
