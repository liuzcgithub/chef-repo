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

echo "As non-Root user [$WAS_USERNAME] start the WAS server ....."

## OLD COMMAND ## $WAS_HOME/bin/startServer.sh server1

#Start WebSphere Application Server for Repo Tools operations
echo "------Start WebSphere Server------"
WAS_HOME=$WAS_HOME su $WAS_USERNAME -c 'cd $WAS_HOME/bin;pwd;./startServer.sh server1;if [ $? -ne 0 ]
then
echo "WebSphere Server failed to start"
exit 1
fi'
if [ $? -ne 0 ]
then
echo "WebSphere Server failed to start"
exit 1
fi

echo "WebSphere Server started"
exit 0