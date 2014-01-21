#!/bin/sh
#********************************************************************************
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2013. All Rights Reserved.
#  
# U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
#********************************************************************************

. /etc/virtualimage.properties

WAS_HOME=$WAS_PROFILE_ROOT

echo "As non-Root user [$WAS_USERNAME] stop the WAS server ....."

## OLD COMMAND ## $WAS_HOME/bin/stopServer.sh server1 -username $WAS_USERNAME -password $WAS_PASSWORD

#Stop WebSphere Application Server for Repo Tools operations
echo "------Stop WebSphere Server------"
WAS_HOME=$WAS_HOME WAS_USERNAME=$WAS_USERNAME WAS_PASSWORD=$WAS_PASSWORD su $WAS_USERNAME -c 'cd $WAS_HOME/bin;pwd;./stopServer.sh server1;if [ $? -ne 0 ]
then
echo "WebSphere Server failed to stop"
exit 1
fi'
if [ $? -ne 0 ]
then
echo "WebSphere Server failed to stop"
exit 1
fi

echo "WebSphere Server stopped"
exit 0