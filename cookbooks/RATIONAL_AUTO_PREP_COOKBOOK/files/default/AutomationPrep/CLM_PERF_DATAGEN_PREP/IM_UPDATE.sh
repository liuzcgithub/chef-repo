#!/bin/sh
. /etc/virtualimage.properties

########################################################
#
#	Authored: Bradley Herrin (bcherrin@us.ibm.com)
# 	Rational Core Team Automation
#	This script updates IM versions to IM 1.5.2
#
########################################################



export IMDIR="/opt/IBM/InstallationManager"
echo "Updating Base Image Installation Manager"
cd /opt/IBM/InstallationManager/eclipse
echo "Launching IM Update"
sed -i s%_IM_VERSION_%$IM_VERSION% /tmp/AutomationPrep/CLM_PERF_DATAGEN_PREP/imUpdate.xml
sed -i s%_INSTALL_LOC_%$IMDIR% /tmp/AutomationPrep/CLM_PERF_DATAGEN_PREP/imUpdate.xml
sed -i s%_ECLIPSE_LOC_%$IMDIR% /tmp/AutomationPrep/CLM_PERF_DATAGEN_PREP/imUpdate.xml
./IBMIM --launcher.ini silent-install.ini -input /tmp/AutomationPrep/CLM_PERF_DATAGEN_PREP/imUpdate.xml -keyring /tmp/IM_Keyring/im.keyring -acceptLicense -accessRights admin


exit 0

