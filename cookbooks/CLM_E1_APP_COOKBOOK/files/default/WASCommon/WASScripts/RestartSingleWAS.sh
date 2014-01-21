#!/bin/sh
. /etc/virtualimage.properties
#############################################################################
# Name: Restart WAS
#
# Authored: Tanya Wolff (twolff@ca.ibm.com)
#
# Inputs - taken from 'environment'
#        - optional arguments: username password
#          Use these arguments after disabling admin security on WAS.
#	   You need to restart the server by passing in the old creds
#  	   to stop the server, then no creds to start the server.
#
#############################################################################
if [ "$1" -a "$2" ]; then creds="-username $1 -password $2"; fi
su - $WAS_USER_NAME -c "$WAS_PROFILE_ROOT/bin/stopServer.sh server1 $creds"
sleep 30
su - $WAS_USER_NAME -c "$WAS_PROFILE_ROOT/bin/startServer.sh server1"
if [ $? -ne 0 ]
then
echo "WebSphere Server failed to start"
exit 1
fi
echo "WebSphere Server restarted."
exit 0
