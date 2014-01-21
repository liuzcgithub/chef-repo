#!/bin/sh
. /etc/virtualimage.properties

########################################################
#
#	Authored: Bradley Herrin (bcherrin@us.ibm.com)
# 	Rational Core Team Automation
#	This script preps images with Automation requirements
#
########################################################

IM_VERSION=163
VNC_RES=1024x768
VNCPWD=ec11ipse
CLMPERF=1
ORACLE=1
MEDIA_SERVER="https://rtpmsa.raleigh.ibm.com/msa/projects/i/iteimages/software/linux64_x86/RationalCoreAutomation"
AUTO_PREP=/tmp/AutomationPrep

if [ -d /doorsDwaRoot ]
then
ln -s /doorsDwaRoot /
rm -rf /doorsDwaRoot/lost+found
ls -la /doorsDwaRoot
chmod 777 /doorsDwaRoot
ls -la /doorsDwaRoot
fi

if [ -d /RPT ]
then
ln -s /RPT /tmp
rm -rf /RPT/lost+found
ls -la /RPT
chmod 777 /RPT
ls -la /RPT
fi

if [ -d /RPT_Schedule ]
then
ln -s /RPT_Schedule /tmp
rm -rf /RPT/lost+found
ls -la /RPT_Schedule
chmod 777 /RPT_Schedule
ls -la /RPT_Schedule
fi

if [ -d /JazzTeamServer ]
then
ln -s /JazzTeamServer /opt/IBM
rm -rf /JazzTeamServer/lost+found
ls -la /JazzTeamServer
chmod 777 /JazzTeamServer
ls -la /JazzTeamServer
fi

if [ -d /db2inst1 ]
then
ln -s /db2inst1 /db2fs
rm -rf /db2inst1/lost+found
ls -la /db2inst1
chmod 777 /db2inst1
ls -la /db2inst1
fi


echo "Begin Automation Prep...."
chmod 777 *
ls -la
cd $AUTO_PREP/MSA_Key
wget --no-check-certificate http://pokgsa.ibm.com//gsa/pokgsa/home/r/a/ratlauto/cloud/ratlauto.key
chmod 777 *

ls -la
cd $AUTO_PREP/INSTALL_TERMINAL
chmod 777 *
ls -la
cd $AUTO_PREP/JAVA
chmod 777 *
ls -la
./IBM_LAB_JAVA.sh
errorCode=`expr $? + $errorCode`
cd $AUTO_PREP/RATIONAL_IM_UPDATE
chmod 777 *
ls -la
cd $AUTO_PREP/RATIONAL_SVT_IM_KEYRING
java -jar $AUTO_PREP/MSA_Key/GetSecureFile.jar $MEDIA_SERVER/IM_Keyring/im.keyring $AUTO_PREP/MSA_Key/ratlauto.key false
java -jar $AUTO_PREP/MSA_Key/GetSecureFile.jar $MEDIA_SERVER/IM_Keyring/constellationCred.key $AUTO_PREP/MSA_Key/ratlauto.key false
java -jar $AUTO_PREP/MSA_Key/GetSecureFile.jar $MEDIA_SERVER/IM_Keyring/IM.Cred $AUTO_PREP/MSA_Key/ratlauto.key false
java -jar $AUTO_PREP/MSA_Key/GetSecureFile.jar $MEDIA_SERVER/IM_Keyring/password.txt $AUTO_PREP/MSA_Key/ratlauto.key false
chmod 777 *
ls -la
cd $AUTO_PREP/RATIONAL_SVT_PERF_NMON
java -jar $AUTO_PREP/MSA_Key/GetSecureFile.jar $MEDIA_SERVER/CLM/nmon-14g-1.fu2012.x86_64.rpm $AUTO_PREP/MSA_Key/ratlauto.key false
chmod 777 *
ls -la
cd $AUTO_PREP/RH_FIREWALL_DISABLE
chmod 777 *
ls -la
cd $AUTO_PREP/VNC_SETUP
chmod 777 *
ls -la
cd $AUTO_PREP/CLM_PERF_DATAGEN_PREP
chmod 777 *
ls -la
cd $AUTO_PREP/PERF_INSP
chmod 777 *
ls -la

################################################
# Changing default Redhat cpu soft lock up    
# http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1009996 
# https://access.redhat.com/site/articles/17187#
################################################
echo kernel.softlockup_thresh = 30 >> /etc/sysctl.conf 

export WAS_IMAGE=0
export DB2_IMAGE=0
echo "Determine Image Type..."
[ ! -d /db2home ] && export DB2_IMAGE=1
[ ! -d /opt/IBM/WebSphere ] && export WAS_IMAGE=1
errorCode=0

########################################################
#Check to see if image under evaluation is a DB2 Image #
########################################################
if [ $DB2_IMAGE -eq 0 ]
then
echo "This is a DB2 Image"
echo "Disable Red Hat Firewall"
cd $AUTO_PREP/RH_FIREWALL_DISABLE
./RAT_FW_DISABLE.sh
errorCode=`expr $? + $errorCode`
echo "Install Terminal"
cd $AUTO_PREP/INSTALL_TERMINAL
./installTerm.sh
errorCode=`expr $? + $errorCode`
echo "Install NMON Performance Tool"
cd $AUTO_PREP/RATIONAL_SVT_PERF_NMON
./Install_NMON.sh
errorCode=`expr $? + $errorCode`
echo "VNC Setup"
cd $AUTO_PREP/VNC_SETUP
./InstallVNCsetupService.sh
errorCode=`expr $? + $errorCode`
	version=`cat /etc/redhat-release`
	echo "Current Red Hat Release $version"
	echo $version | grep "6.4"
	if [ $? -ne 0 ]
	then
		yum -y --releasever=6.4 upgrade
	fi
	version=`cat /etc/redhat-release`
	echo "Current Red Hat Release $version"
fi 

########################################################
#Check to see if image under evaluation is a WAS Image #
########################################################
if [ $WAS_IMAGE -eq 0 ]
then
echo "This is a WAS Image"
echo "Disable Red Hat Firewall"
cd $AUTO_PREP/RH_FIREWALL_DISABLE
./RAT_FW_DISABLE.sh
errorCode=`expr $? + $errorCode`
echo "Install Terminal"
cd $AUTO_PREP/INSTALL_TERMINAL
./installTerm.sh
errorCode=`expr $? + $errorCode`
echo "Install NMON Performance Tool"
cd $AUTO_PREP/RATIONAL_SVT_PERF_NMON
java -jar $AUTO_PREP/MSA_Key/GetSecureFile.jar $MEDIA_SERVER/CLM/PI_Linux_1.1.zip $AUTO_PREP/MSA_Key/ratlauto.key false
chmod 777 *
./Install_NMON.sh
errorCode=`expr $? + $errorCode`
echo "Install Performance Inspector"
cd $AUTO_PREP/PERF_INSP
./perf_insp.sh
errorCode=`expr $? + $errorCode`
echo "VNC Setup"
cd $AUTO_PREP/VNC_SETUP
./InstallVNCsetupService.sh
errorCode=`expr $? + $errorCode`
echo "Place im.keyring"
cd $AUTO_PREP/RATIONAL_SVT_IM_KEYRING
mkdir /tmp/IM_Keyring
mv im.keyring /tmp/IM_Keyring
mv generate_keyring.sh /tmp/IM_Keyring
mv IM.Cred /tmp/IM_Keyring
mv password.txt /tmp/IM_Keyring
cd $AUTO_PREP/RATIONAL_SVT_IM_KEYRING
./SetJazzNetIDAndPassword.sh 
echo "Update Installation Manager"
cd $AUTO_PREP/RATIONAL_IM_UPDATE
./IM_UPDATE.sh
errorCode=`expr $? + $errorCode`
fi  

#########################################################
#Check to see if image under evaluation is a BASE Image #
#########################################################
if [ $DB2_IMAGE -ne 0 ] && [ $WAS_IMAGE -ne 0 ]
then
echo "This is a BASE Image"
echo "Disable Red Hat Firewall"
cd $AUTO_PREP/RH_FIREWALL_DISABLE
./RAT_FW_DISABLE.sh
errorCode=`expr $? + $errorCode`
echo "Install Terminal"
cd $AUTO_PREP/INSTALL_TERMINAL
./installTerm.sh
errorCode=`expr $? + $errorCode`
echo "Install NMON Performance Tool"
cd $AUTO_PREP/RATIONAL_SVT_PERF_NMON
./Install_NMON.sh
errorCode=`expr $? + $errorCode`
echo "VNC Setup"
cd $AUTO_PREP/VNC_SETUP
./InstallVNCsetupService.sh
errorCode=`expr $? + $errorCode`
echo "Place im.keyring"
cd $AUTO_PREP/RATIONAL_SVT_IM_KEYRING
mkdir /tmp/IM_Keyring
mv im.keyring /tmp/IM_Keyring

echo "Update Installation Manager"
if [ $CLMPERF -eq 1 ] && [ $ORACLE -eq 1 ]
then
cd $AUTO_PREP/RATIONAL_IM_UPDATE
sed -i s%'$WAS_USERNAME'%virtuser% $AUTO_PREP/RATIONAL_IM_UPDATE/IM_UPDATE.sh
./IM_UPDATE.sh
errorCode=`expr $? + $errorCode`
fi
if [ $CLMPERF -eq 0 ]
then
cd $AUTO_PREP/CLM_PERF_DATAGEN_PREP
./IM_ROOT.sh
./IM_UPDATE.sh
errorCode=`expr $? + $errorCode`
fi
fi 



exit $errorCode
