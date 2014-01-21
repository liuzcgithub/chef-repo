#!/bin/sh
. /etc/virtualimage.properties
#############################################################################
# Name: UpdateWASConfig.sh
#############################################################################
WASCOMMON=/tmp/WASCommon
echo "WASCOMMON=$WASCOMMON"
echo "WAS_PROFILE_ROOT=$WAS_PROFILE_ROOT"
echo "WAS_USER_NAME=$WAS_USER_NAME"

su - $WAS_USER_NAME -c "$WAS_PROFILE_ROOT/bin/wsadmin.sh -lang jython -f $WASCOMMON/BeforeConvertCert.py" 
if [ $? -ne 0 ]
	then
	echo "Failed to set some properties"
	exit 1
fi
exit 0
