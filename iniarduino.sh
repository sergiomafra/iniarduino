#!/bin/bash

## CHECK IF ARDUINO IS CONNECTED TO PC
TTYACM0=$(sudo find /dev -name ttyACM0)
TTYUSB0=$(sudo find /dev -name ttyUSB0)
if test $TTYACM0; then
	echo "Arduino connected!"
	echo
	DEV=0
elif test $TTYUSB0; then
	echo "Arduino connected!"
	echo
	DEV=1
else
	echo "Arduino not found!"
	exit
fi

## CHECK AND ADD, IF NOT ALREADY PART OF, USER TO DIALOUT AND TTY GROUPS
WHOAMI=$(whoami)
echo "Checking if $WHOAMI is part of dialout and tty groups..."
if [ $WHOAMI == "root" ]; then
	echo "- You can not be logged in as root."
	exit
else
	UGROUPS=$(groups $WHOAMI | grep -Eo "(dialout|tty)")
	if [[ $UGROUPS != *"dialout"* ]]; then
		sudo usermod -aG dialout $WHOAMI
		echo "- $WHOAMI added to dialout group."
	else
		echo "- $WHOAMI already on dialout group."
	fi
	if [[ $UGROUPS != *"tty"* ]]; then
		sudo usermod -aG dialout $WHOAMI
		echo "- $WHOAMI added to tty group."
	else
		echo "- $WHOAMI already on tty group."
	fi
fi

echo

## CORRECT PERMISSIONS FOR DEVICE
if [ $DEV == 0 ]; then
	sudo chmod a+rw /dev/ttyACM0
	echo "Permissions to /dev/ttyACM0 changed to a+rw."
else
	sudo chmod a+rw /dev/ttyUSB0
	echo "Permissions to /dev/ttyUSB0 changed to a+rw."
fi

echo

## RELOAD UDEV RULES
echo "Reloading UDEV Rules..."
sudo udevadm trigger
echo "UDEV Rules reloaded without the need to restart."

echo

## SUCCESS MESSAGE
echo "All Done!"
