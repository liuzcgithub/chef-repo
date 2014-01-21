#!/bin/bash
mkdir /root/vncsetup
mv /tmp/AutomationPrep/VNC_SETUP/VNCroot.sh /root/vncsetup/VNCroot.sh
mv /tmp/AutomationPrep/VNC_SETUP/password.txt /root/vncsetup/password.txt
chmod 777 * /root/vncsetup/VNCroot.sh

mv /tmp/AutomationPrep/VNC_SETUP/vncsetup /etc/init.d/
chmod 777 * /etc/init.d/vncsetup
`chkconfig --add vncsetup`

sh /root/vncsetup/VNCroot.sh

