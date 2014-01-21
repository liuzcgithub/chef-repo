#!/bin/sh

. /etc/virtualimage.properties
##########################################################
#       Authored: Jennifer Liu (yeliu@us.ibm.com)
#       Rational Core Team Automation
#       This script restart WAS processes
#	arguments: 
#	 "single" will start dmgr, both custom nodeagents, AppNode2 and Proxy01 nodeagent
#	 No arguments: starts everything (above + AppNode1)
#       Updated: Tanya Wolff
#       Removed credentials passing on command line since they are
#       configured in soap.client.props
########################################################

##########################################################
#WAS_PROFILE_ROOT="/opt/IBM/WebSphere/Profiles/DefaultDmgr01"

echo "starting dmgr ...."
su - $WAS_USER_NAME -c "$WAS_PROFILE_ROOT/bin/startServer.sh dmgr"

# start appnode2 nodeagent
echo "start appnode2 nodeagent ....."
ssh root@$appnode2 "su - $WAS_USER_NAME -c '/opt/IBM/WebSphere/AppServer/bin/startServer.sh nodeagent'"

echo "start appNode1 nodeagent......"
ssh root@$appnode1 "su - $WAS_USER_NAME -c '/opt/IBM/WebSphere/AppServer/bin/startServer.sh nodeagent'"

echo "start proxy nodeagent....."
su - $WAS_USER_NAME -c '/opt/IBM/WebSphere/Profiles/Proxy01/bin/startServer.sh nodeagent'

echo "sleep 60 seconds to wait for nodeagent start....."
sleep 60

echo "starting appnode2 server....."
ssh root@$appnode2 "su - $WAS_USER_NAME -c '/opt/IBM/WebSphere/AppServer/bin/startServer.sh AppNode2'"
if [ "$1" == "single" ]; then 
	echo "----- Skipping appnode1 server"
else

        echo "starting appnode1 server....."
        ssh root@$appnode1 "su - $WAS_USER_NAME -c '/opt/IBM/WebSphere/AppServer/bin/startServer.sh AppNode1'"
fi
echo "starting proxy server......"
su - $WAS_USER_NAME -c '/opt/IBM/WebSphere/Profiles/Proxy01/bin/startServer.sh proxy_1'
echo "pause 60 seconds..."
sleep 60

