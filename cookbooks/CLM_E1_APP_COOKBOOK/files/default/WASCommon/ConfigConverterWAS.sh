#!/bin/bash

echo "---Installing Xvfb---"
cd /tmp/AutomationPrep
export FTP3USER=ite@us.ibm.com
export FTP3PASS=aut0mat0r
export FTP3URL=ftp3.linux.ibm.com
wget -qO- --no-check-certificate https://rtp.rhn.linux.ibm.com/pub/bootstrap/bootstrap-rtp.sh | /bin/bash
rhnreg_ks --force --username=$FTP3USER --password=$FTP3PASS
rhn-channel --add --channel=rhel-x86_64-server-optional-6 -username=$FTP3USER -password=$FTP3PASS
yum -y install xorg-x11-server-Xvfb-1.10.6-1.el6.x86_64
./ibm-yum.sh -y install xorg-x11-server-Xvfb-1.10.6-1.el6.x86_64

if [ $? -ne 0 ]
then
echo "Failed to install Xvfb"
exit 1
fi

echo "---Starting Xvfb on port :3---"
Xvfb :3 -screen 0 800x600x24 & 

echo "---Setting DISPLAY---"
DISPLAY=:3.0
export DISPLAY

echo "---Adding DISPLAY to startNode.sh---"
sed -i "s%Bootstrap values ...%ADDED FOR CONVERTER CLUSTERING SUPPORT\nDISPLAY=:3.0\nexport DISPLAY\n\n# Bootstrap values ...%" /opt/IBM/WebSphere/AppServer/bin/start*.sh

