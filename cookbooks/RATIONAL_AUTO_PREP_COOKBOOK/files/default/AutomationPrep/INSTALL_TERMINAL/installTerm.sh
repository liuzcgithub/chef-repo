#!/bin/bash

cd /tmp/AutomationPrep
export FTP3USER=ite@us.ibm.com
export FTP3PASS=aut0mat0r
export FTP3URL=ftp3.linux.ibm.com
wget -qO- --no-check-certificate https://rtp.rhn.linux.ibm.com/pub/bootstrap/bootstrap-rtp.sh | /bin/bash
rhnreg_ks --force --username=$FTP3USER --password=$FTP3PASS
rhn-channel --add --channel=rhel-x86_64-server-optional-6 -username=$FTP3USER -password=$FTP3PASS
./ibm-yum.sh -y install gnome-terminal
