#!/bin/sh

#. /tmp/WASCommon/LDAP/LDAPSecurity.properties
. /etc/virtualimage.properties

########################################################
#
#       Authored: Jennifer Liu (yeliu@us.ibm.com)
#       Rational Core Team Automation
#       This script configures:
#
#	Updated: Tanya Wolff
#	Removed credentials passing on command line since they are
#	configured in soap.client.props
########################################################


#WAS_PROFILE_ROOT="/opt/IBM/WebSphere/Profiles/DefaultDmgr01"

#adminUser=$jazz_ldap_primaryid
#adminPass=$jazz_ldap_primaryid_Password

echo "------------------Getting the environment variables----------------------"
echo "dmgrhost = $dmgrhost"
echo "appnode1 = $appnode1"
echo "appnode2 = $appnode2"
echo "Dmgr profile home = $WAS_PROFILE_ROOT"
echo "-------------------------------------------------------------------------"

BaseDir=$(dirname $0)
echo "Stopping application server on $appnode1 ....."
ssh root@$appnode1 "su - $WAS_USER_NAME -c '/opt/IBM/WebSphere/AppServer/bin/stopServer.sh AppNode1'"

echo "Stopping application server on $appnode2 ....."
ssh root@$appnode2 "su - $WAS_USER_NAME -c '/opt/IBM/WebSphere/AppServer/bin/stopServer.sh AppNode2'"


echo "Stopping nodeagent on $appnode1 ...."
ssh root@$appnode1 "su - $WAS_USER_NAME -c '/opt/IBM/WebSphere/AppServer/bin/stopServer.sh nodeagent'"

echo "Stopping nodeagent on $appnode2 ...."
ssh root@$appnode2 "su - $WAS_USER_NAME -c '/opt/IBM/WebSphere/AppServer/bin/stopServer.sh nodeagent'"

echo "As workaround, AppNode2 couldn't stop cleanly...."
scp $BaseDir/CleanStopWASAppnode2.sh root@$appnode2:/tmp
ssh root@$appnode2 "su - $WAS_USER_NAME -c '/tmp/CleanStopWASAppnode2.sh'"

echo "stopping dmgr ...."
su - $WAS_USER_NAME -c "$WAS_PROFILE_ROOT/bin/stopServer.sh dmgr"
echo "pause 60 seconds..."
sleep 60

