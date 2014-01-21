#!/bin/sh
. /etc/virtualimage.properties
#############################################################################
# Name: UpdateWASConfig.sh
#	Authored: Tanya Wolff (twolff@ca.ibm.com)
#
#    This script 
#	1. Update JVM properties
#	2. Update Session Management properties
#############################################################################
WASCOMMON=/tmp/WASCommon
echo "WASCOMMON=$WASCOMMON"
echo "WAS_PROFILE_ROOT=$WAS_PROFILE_ROOT"
echo "WAS_USER_NAME=$WAS_USER_NAME"

echo "----- Add Xvfb"
$WASCOMMON/ConfigConverterWAS.sh

echo "----- Modify the JVM properties based on RAM size"
$WASCOMMON/SetCorrectHeapSize.sh
if [ $? -ne 0 ]; then
	echo "Heapsize not set in was.properties. Exiting"
	exit 1
fi
su - $WAS_USER_NAME -c "$WAS_PROFILE_ROOT/bin/wsadmin.sh -lang jython -f $WASCOMMON/SetJvmProps.py $WASCOMMON $PROFILE_TYPE" 
if [ $? -ne 0 ]
	then
	echo "WAS JVM settings NOT updated"
	exit 1
fi
if [ "$PROFILE_TYPE" == "dmgr" ]; then
	echo "---- Add host aliases"
	su - $WAS_USER_NAME -c "$WAS_PROFILE_ROOT/bin/wsadmin.sh -lang jython -f $WASCOMMON/AddHostAlias.py $dmgrhost"
	if [ $? -ne 0 ]
		then
		echo "Host Alias settings NOT updated"
		exit 1
	fi
	echo "----- Update ORB settings for cluster deployment manager"
	su - $WAS_USER_NAME -c "$WAS_PROFILE_ROOT/bin/wsadmin.sh -lang jython -f $WASCOMMON/UpdateORB.py" 
	if [ $? -ne 0 ]
		then
		echo "ORB settings NOT updated"
		exit 1
	fi
fi

echo "----- Update WAS Session Management settings"
su - $WAS_USER_NAME -c "$WAS_PROFILE_ROOT/bin/wsadmin.sh -lang jython -f $WASCOMMON/SetSMProps.py"
if [ $? -ne 0 ]
	then
	echo "WAS Session Management settings NOT updated"
	exit 1
fi
echo " "
echo "----- Start WAS After WAS Config"
if [ "$PROFILE_TYPE" == "dmgr" ]; then
        $WASCOMMON/WASScripts/RestartWASCluster.sh
else
	$WASCOMMON/WASScripts/RestartSingleWAS.sh
fi

echo "----- WAS settings updated"
exit 0
