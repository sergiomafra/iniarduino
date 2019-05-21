#!/bin/bash

## CHECK IF ARDUINO IS CONNECTED TO PC
TTYACM0=$(sudo find /dev -name ttyACM0)
if test -z $TTYACM0; then
	echo "Arduino not found..."
	exit
else
	echo "Arduino connected!"
fi

## CHECK AND ADD, IF NOT ALREADY PART OF, USER TO DIALOUT AND TTY GROUPS
WHOAMI=$(whoami)
echo "Checking if $WHOAMI is part of dialout and tty groups"
if [ $WHOAMI == "root" ]; then
	echo "You can not be logged in as root."
	exit
else
	UGROUPS=$(groups $WHOAMI | grep -Eo "(dialout|tty)")
	if [[ $UGROUPS != *"dialout"* ]]; then
		sudo usermod -aG dialout $WHOAMI
		echo "$WHOAMI added to dialout group"
	else
		echo "$WHOAMI already on dialout group"
	fi
	if [[ $UGROUPS != *"tty"* ]]; then
		sudo usermod -aG dialout $WHOAMI
		echo "$WHOAMI added to tty group"
	else
		echo "$WHOAMI already on tty group"
	fi
fi

## CORRECT PERMISSIONS for /dev/ttyACM0
echo "Password required to change permissions of /dev/ttyACM0"
sudo chmod a+rw /dev/ttyACM0
echo "Permissions to /dev/ttyACM0 changed to a+rw"

## RELOAD UDEV RULES
echo "Reloading UDEV Rules"
sudo udevadm trigger
echo "UDEV Rules reloaded without the need to restart"

## SUCCESS MESSAGE
echo "All Done!"
