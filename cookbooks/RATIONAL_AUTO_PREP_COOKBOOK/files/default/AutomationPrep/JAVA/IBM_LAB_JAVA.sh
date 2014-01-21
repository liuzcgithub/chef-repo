#!/bin/sh

echo "installing java via yum"
export FTP3USER=ite@us.ibm.com
export FTP3PASS=aut0mat0r
export FTP3URL=ftp3.linux.ibm.com
#wget -qO- --no-check-certificate https://rtp.rhn.linux.ibm.com/pub/bootstrap/bootstrap-rtp.sh | /bin/bash
#rhnreg_ks --force --username=$FTP3USER --password=$FTP3PASS
cd /tmp/AutomationPrep
./ibm-yum.sh -y install java

java -version
which java


echo "System Path: $PATH"
echo "Show Java Version"
`java -version`
echo " "


echo "Set IBM JRE"

if [ -d /opt/IBM/WebSphere/AppServer/InstallationManager ]
then
echo " "
export IBMJRE=`ls /opt/IBM/WebSphere/AppServer/InstallationManager/eclipse/ | grep jre`
export PATH=/opt/IBM/WebSphere/AppServer/InstallationManager/eclipse/$IBMJRE/jre/bin:$PATH
echo "System Path: $PATH"
echo "Show Java Version"
`java -version`
echo PATH=/opt/IBM/WebSphere/AppServer/InstallationManager/eclipse/$IBMJRE/jre/bin:$PATH >> /root/.bashrc
echo export PATH >> /root/.bashrc
. /root/.bashrc
fi

if [ -d /opt/IBM/InstallationManager ]
then
echo " "
export IBMJRE=`ls /opt/IBM/InstallationManager/eclipse/ | grep jre`
export PATH=/opt/IBM/InstallationManager/eclipse/$IBMJRE/jre/bin:$PATH
echo "System Path: $PATH"
echo "Show Java Version"
`java -version`
echo PATH=/opt/IBM/InstallationManager/eclipse/$IBMJRE/jre/bin:$PATH >> /root/.bashrc
echo export PATH >> /root/.bashrc
. /root/.bashrc
fi

exit
