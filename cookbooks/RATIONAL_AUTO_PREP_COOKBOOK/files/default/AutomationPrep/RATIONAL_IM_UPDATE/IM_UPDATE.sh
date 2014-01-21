#!/bin/sh
. /etc/virtualimage.properties

########################################################
#
#	Authored: Bradley Herrin (bcherrin@us.ibm.com)
# 	Rational Core Team Automation
#	This script updates IM versions to IM 1.5.2
#
########################################################


echo "Enter IM Directory"


if [ -d /opt/IBM/WebSphere/AppServer/InstallationManager ]
then
export IMDIR="/opt/IBM/WebSphere/AppServer/InstallationManager"
echo "Updating WebSphere 7 Image Installation Manager"
cd /opt/IBM/WebSphere/AppServer/InstallationManager/eclipse
echo "Launching IM Update"
sed -i s%_IM_VERSION_%$IM_VERSION% /tmp/AutomationPrep/RATIONAL_IM_UPDATE/imUpdate.xml
sed -i s%_INSTALL_LOC_%$IMDIR% /tmp/AutomationPrep/RATIONAL_IM_UPDATE/imUpdate.xml
sed -i s%_ECLIPSE_LOC_%$IMDIR% /tmp/AutomationPrep/RATIONAL_IM_UPDATE/imUpdate.xml
su -c './IBMIM --launcher.ini silent-install.ini -input /tmp/AutomationPrep/RATIONAL_IM_UPDATE/imUpdate.xml -keyring /tmp/IM_Keyring/im.keyring -acceptLicense' -- $WAS_USERNAME
fi

if [ -d /opt/IBM/InstallationManager ]
then
export IMDIR="/opt/IBM/InstallationManager"
echo "Updating WebSphere 8 Image or Base Image Installation Manager"
cd /opt/IBM/InstallationManager/eclipse
echo "Launching IM Update"
sed -i s%_IM_VERSION_%$IM_VERSION% /tmp/AutomationPrep/RATIONAL_IM_UPDATE/imUpdate.xml
sed -i s%_INSTALL_LOC_%$IMDIR% /tmp/AutomationPrep/RATIONAL_IM_UPDATE/imUpdate.xml
sed -i s%_ECLIPSE_LOC_%$IMDIR% /tmp/AutomationPrep/RATIONAL_IM_UPDATE/imUpdate.xml
# For IM 1.6.3 above, we need use -secureStorageFile
su -c './IBMIM --launcher.ini silent-install.ini -input /tmp/AutomationPrep/RATIONAL_IM_UPDATE/imUpdate.xml  -secureStorageFile /tmp/IM_Keyring/IM.Cred -masterPasswordFile /tmp/IM_Keyring/password.txt -acceptLicense' -- $WAS_USERNAME
fi

exit 0

