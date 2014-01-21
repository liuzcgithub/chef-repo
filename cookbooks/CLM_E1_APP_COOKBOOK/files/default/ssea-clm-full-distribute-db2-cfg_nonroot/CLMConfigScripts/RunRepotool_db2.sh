#!/bin/sh
. /etc/virtualimage.properties
if [ -e /tmp/WASCommon/LDAP/LDAPSecurity.properties ]
then
        echo "sourcing /tmp/WASCommon/LDAP/LDAPSecurity.properties"
        . /tmp/WASCommon/LDAP/LDAPSecurity.properties
else
        echo "sourcing /tmp/LDAP/LDAPSecurity.properties"
        . /tmp/LDAP/LDAPSecurity.properties
fi

#############################################################################
# Name: RunRepotool_db2.sh
#	Authored: unknown
#
# Updated for SSE nonRoot: Kenneth Thomson (kenneth.thomson@uk.ibm.com)	
#	
# Inputs - taken from 'environment'
# <Database hostname> == $DB_HOSTNAME
# <Dmgr hostname> == $ihshost
# <where script is found> == $SCRIPTS_DIR
# <CLM part to install {ccm, qm, rm, jts}> == $COMPONENT
#
#############################################################################

CLM_SCRIPTS_DIR=/tmp/CLM

echo "------Server Info------"
echo "DB2 Host Name: " $DB_HOSTNAME
echo "IHS Server FQDN: " $ihshost
echo "COMPONENT is: $COMPONENT"
if [ -z "$WAS_USER_NAME" ]; then
WAS_USER_NAME=$WAS_USERNAME
fi
echo "WAS_USER_NAME=$WAS_USER_NAME"

cp -f $SCRIPTS_DIR/CLMConfigScripts/db2_teamserver_template.properties $CLM_SCRIPTS_DIR/teamserver.properties

echo "------------ String sub for common properties -------------"
sed -i s%_MOD_DB_HOSTNAME_%$DB_HOSTNAME% $CLM_SCRIPTS_DIR/teamserver.properties
sed -i s%_WEB_SERVER_HOSTNAME_%$ihshost% $CLM_SCRIPTS_DIR/teamserver.properties
sed -i s%_DW_DB_HOSTNAME_%$DB_HOSTNAME% $CLM_SCRIPTS_DIR/teamserver.properties
sed -i s%_MOD_DB_PORT_%50001% $CLM_SCRIPTS_DIR/teamserver.properties

echo "--------------------jazz_ldap_baseGroupDN is $jazz_ldap_baseGroupDN "
echo "----------------- string sub for LDAP property file ------------------"
sed -i s%BASE_GROUP_DN%$jazz_ldap_baseGroupDN% 	$CLM_SCRIPTS_DIR/teamserver.properties
sed -i s%BASE_USER_DN%$jazz_ldap_baseUserDN% $CLM_SCRIPTS_DIR/teamserver.properties
sed -i s%REGISTRY_LOCATION%'ldap://'$jazz_userrealm% $CLM_SCRIPTS_DIR/teamserver.properties
sed -i s%REGISTRY_USERNAME%$jazz_userrole_RegistryUsername% $CLM_SCRIPTS_DIR/teamserver.properties
sed -i s%REGISTRY_PASSWORD%$jazz_userrole_RegistryPassword% $CLM_SCRIPTS_DIR/teamserver.properties
sed -i s%GROUP_MAPPING%$jazz_ldap_groupMapping% $CLM_SCRIPTS_DIR/teamserver.properties
sed -i s%MEMBERS_OF_GROUP%$jazz_ldap_membersOfGroup% $CLM_SCRIPTS_DIR/teamserver.properties
sed -i s%FIND_GROUPS_QUERY%$jazz_ldap_findGroupsForUserQuery% $CLM_SCRIPTS_DIR/teamserver.properties


echo "disable cluster"
echo " " >> $CLM_SCRIPTS_DIR/teamserver.properties
echo "com.ibm.team.repository.cluster.isInCluster=false" >>  $CLM_SCRIPTS_DIR/teamserver.properties

echo "------String Sub component ($COMPONENT) teamserver.properties------"
cp -f $CLM_SCRIPTS_DIR/teamserver.properties $CLM_SCRIPTS_DIR/$COMPONENT_teamserver.properties
sed -i s%_CLM_COMPONENT_%$COMPONENT% $CLM_SCRIPTS_DIR/$COMPONENT_teamserver.properties

echo "------Copy teamserver.properties files to /server/conf/<app>------"
su $WAS_USER_NAME -c "cp -f $CLM_SCRIPTS_DIR/$COMPONENT_teamserver.properties /opt/IBM/JazzTeamServer/server/conf/$COMPONENT/teamserver.properties" 
if [ $? -ne 0 ]
then
echo "Failed to copy teamserver.properties files to /server/conf/<app>"
exit 1
fi
#ls -l "/opt/IBM/JazzTeamServer/server/conf/$COMPONENT/teamserver.properties"
echo "-----------------------"
echo " "

if [ "$COMPONENT" = "jts" ]
then
	echo " " >> /opt/IBM/JazzTeamServer/server/conf/admin/admin.properties
	echo "com.ibm.team.repository.cluster.isInCluster=false" >> /opt/IBM/JazzTeamServer/server/conf/admin/admin.properties
fi

if [ "$COMPONENT" = "rm" ]
then
	echo "disable cluster"
	echo " " >>  /opt/IBM/JazzTeamServer/server/conf/rm/fronting.properties
	echo "com.ibm.team.repository.cluster.isInCluster=false" >>   /opt/IBM/JazzTeamServer/server/conf/rm/fronting.properties
fi

if [ "$COMPONENT" != "rm" ]
then
	echo "------Run Repo Tools for $COMPONENT Tables------"
	COMPONENT=$COMPONENT su $WAS_USERNAME -c 'cd /opt/IBM/JazzTeamServer/server;./repotools-$COMPONENT.sh -createTables teamserver.properties="/opt/IBM/JazzTeamServer/server/conf/$COMPONENT/teamserver.properties" logFile=repotools_$COMPONENT.log'
	if [ $? -ne 0 ]
	then
	echo "Repo Tools Failed to Create $COMPONENT Tables"
	exit 1
	fi
	echo "-----------------------"
	echo " "
fi


if [ "$COMPONENT" = "jts" ]
then
	#Create DW Tables
	echo "------Run Repo Tools for Data WareHouse Tables------"
	su $WAS_USER_NAME -c 'cd /opt/IBM/JazzTeamServer/server;./repotools-jts.sh -createWarehouse teamserver.properties="/opt/IBM/JazzTeamServer/server/conf/jts/teamserver.properties" logFile=repotools_dw.log'
	if [ $? -ne 0 ]
	then
	echo "Repo Tools Failed to Create Data WareHouse Tables"
	exit 1
	fi
	echo "-----------------------"
	echo " "
fi

echo "Repo Tools - Table creation successful"
exit 0
