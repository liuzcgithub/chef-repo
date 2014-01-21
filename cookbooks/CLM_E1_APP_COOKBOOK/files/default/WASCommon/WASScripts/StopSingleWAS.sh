#!/bin/sh
. /etc/virtualimage.properties

#############################################################################
# Name: StopSingleWAS.sh
#	Authored: unknown
#
# Updated for SSE nonRoot: Kenneth Thomson (kenneth.thomson@uk.ibm.com)	
#	
#############################################################################
echo "As non-Root user [$WAS_USER_NAME] stop the WAS server ....."

#Stop WebSphere Application Server for Repo Tools operations
echo "----- Stop WebSphere Server -----"
su - $WAS_USER_NAME -c "$WAS_PROFILE_ROOT/bin/stopServer.sh server1"
if [ $? -ne 0 ]
then
echo 'WebSphere Server failed to stop'
exit 1
fi

echo "WebSphere Server stopped"
exit 0
