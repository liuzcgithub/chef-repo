#!/bin/sh

#Force VNC root access and add xterm shortcut to root Desktop
user=`whoami`  

if [ $user = root ]; then

	su -c "vncserver :2" root < /root/vncsetup/password.txt	
	echo "Installing terminal and adding application icon..."
	yum -y install gnome-terminal 
fi
