#!/bin/sh
. /etc/virtualimage.properties

#############################################################################
# Name: StartSingleWAS.sh
#	Authored: unknown
#
# Updated for SSE nonRoot: Kenneth Thomson (kenneth.thomson@uk.ibm.com)	
#	
#############################################################################

echo "As non-Root user [$WAS_USER_NAME] start the WAS server ....."

#Start WebSphere Application Server for Repo Tools operations
echo "------Start WebSphere Server------"
su - $WAS_USER_NAME -c "$WAS_PROFILE_ROOT/bin/startServer.sh server1"
if [ $? -ne 0 ]
then
echo "WebSphere Server failed to start"
exit 1
fi

echo "WebSphere Server started"
exit 0
