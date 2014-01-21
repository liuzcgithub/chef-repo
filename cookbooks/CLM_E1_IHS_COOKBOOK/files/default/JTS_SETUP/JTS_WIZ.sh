#!/bin/sh
. /etc/virtualimage.properties
if [ ${CLM_TOPOLOGY} == "DISTRIBUTED_DB2" ]
then
	echo "This is an IHS host, WASCommon didn't run on this node, we need copy the update LDAP property file"
	mkdir /tmp/WASCommon
	scp -r root@$appnode0:/tmp/WASCommon/LDAP /tmp/WASCommon/LDAP
fi

if [ -e /tmp/WASCommon/LDAP/LDAPSecurity.properties ]
then
	echo "sourcing /tmp/WASCommon/LDAP/LDAPSecurity.properties"
	. /tmp/WASCommon/LDAP/LDAPSecurity.properties
else 
	echo "sourcing /tmp/LDAP/LDAPSecurity.properties"
	. /tmp/LDAP/LDAPSecurity.properties
fi

#############################################################################
#	Authored: Bradley Herrin (bcherrin@us.ibm.com)
#
#
#
#############################################################################

chmod 777 *
ls -la

if [ ${RUN_JTS_SCRIPTED_SETUP} == "N" ]
then
echo "User has selected to NOT run the automated scripted JTS Setup.  User will now be required to MANUALLY complete JTS Setup"
exit 0
fi

echo "CLM Topology: "$CLM_TOPOLOGY

if [ ${MTM_SAMPLE} == "Y" ]
then
echo "Deploy MTM Sample"
sed -i s%MTM=false%MTM=true% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%MTM=false%MTM=true% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%MTM=false%MTM=true% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%MTM=false%MTM=true% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%MTM=false%MTM=true% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%MTM=false%MTM=true% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%MTM=false%MTM=true% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%MTM=false%MTM=true% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%MTM=false%MTM=true% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%MTM=false%MTM=true% /tmp/JTS_SETUP/jts_wiz_rsadm_twoserver_db2.properties

fi

if [ ${CLM_TOPOLOGY} == "TWOSERVER" ]
then

echo "------String Sub JTS Wizard jts_wiz_twoserver_db2.properties------"
sed -i s%DB2_HOSTNAME_1%$DB2_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%DB2_HOSTNAME_2%$DB2_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%DB2_HOSTNAME_3%$DB2_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%DB2_HOSTNAME_4%$DB2_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%DB2_HOSTNAME_5%$DB2_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%DB2_HOSTNAME_6%$DB2_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%CLM_HOSTNAME_1%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%CLM_HOSTNAME_2%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%CLM_HOSTNAME_3%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%DB2INST1_PW_1%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%DB2INST1_PW_2%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%DB2INST1_PW_3%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%DB2INST1_PW_4%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%DB2INST1_PW_5%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%DB2INST1_PW_6%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%BASE_GROUP_DN%$jazz_ldap_baseGroupDN% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%BASE_USER_DN%$jazz_ldap_baseUserDN% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%REGISTRY_LOCATION%'ldap\://'$jazz_userrealm% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%REGISTRY_USERNAME%$jazz_userrole_RegistryUsername% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%REGISTRY_PASSWORD%$jazz_userrole_RegistryPassword% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%GROUP_MAPPING%$jazz_ldap_groupMapping% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%GROUP_NAME_ATTRIBUTE%$jazz_ldap_groupNameAttribute% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%MEMBERS_OF_GROUP%$jazz_ldap_membersOfGroup% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
sed -i s%USER_ATTRIBUTE_MAPPING%$jazz_ldap_userAttributesMapping% /tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties
echo "-----------------------"
echo " "
echo "------Remove plain text password from virtualimage.properties------"
sed -i s%db2inst1_password=$db2inst1_password%""% /etc/virtualimage.properties
echo "------Begin JTS Setup Wizard Automation & Install Money That Matters------"
jazz_ldap_primaryid=$jazz_ldap_primaryid jazz_ldap_primaryid_Password=$jazz_ldap_primaryid_Password su $WAS_USERNAME -c 'cd /opt/IBM/JazzTeamServer/server;./repotools-jts.sh -setup includeLifecycleProjectStep=true adminUserId=$jazz_ldap_primaryid adminPassword=$jazz_ldap_primaryid_Password parametersFile=/tmp/JTS_SETUP/jts_wiz_twoserver_db2.properties;if [ $? -ne 0 ]
then
exit 1
fi'
if [ $? -ne 0 ]
then
echo "JTS Setup Wizard Automation failed"
exit 1
fi
echo "------JTS Setup Wizard Complete------"
if [ ${IMPORT_LDAP_USERS} == "Y" ]
then
echo "Import All Users"
cd /opt/IBM/JazzTeamServer/server;
jazz_ldap_primaryid=$jazz_ldap_primaryid jazz_ldap_primaryid_Password=$jazz_ldap_primaryid_Password WAS_USERNAME=$WAS_USERNAME su $WAS_USERNAME -c './repotools-jts.sh -syncUsers repositoryURL=https://$HOSTNAME:9443/jts adminUserId=$jazz_ldap_primaryid adminPassword=$jazz_ldap_primaryid_Password logFile=repotools-jts_syncUsers.log'
sleep 300
fi
fi

if [ ${CLM_TOPOLOGY} == "FP_TWOSERVER" ]
then

echo "------String Sub JTS Wizard jts_wiz_twoserverfixpack_db2.properties------"
sed -i s%DB2_HOSTNAME_1%$DB2_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%DB2_HOSTNAME_2%$DB2_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%DB2_HOSTNAME_3%$DB2_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%DB2_HOSTNAME_4%$DB2_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%DB2_HOSTNAME_5%$DB2_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%DB2_HOSTNAME_6%$DB2_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%CLM_HOSTNAME_1%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%CLM_HOSTNAME_2%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%CLM_HOSTNAME_3%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%DB2INST1_PW_1%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%DB2INST1_PW_2%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%DB2INST1_PW_3%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%DB2INST1_PW_4%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%DB2INST1_PW_5%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%DB2INST1_PW_6%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%BASE_GROUP_DN%$jazz_ldap_baseGroupDN% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%BASE_USER_DN%$jazz_ldap_baseUserDN% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%REGISTRY_LOCATION%'ldap\://'$jazz_userrealm% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%REGISTRY_USERNAME%$jazz_userrole_RegistryUsername% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%REGISTRY_PASSWORD%$jazz_userrole_RegistryPassword% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%GROUP_MAPPING%$jazz_ldap_groupMapping% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%GROUP_NAME_ATTRIBUTE%$jazz_ldap_groupNameAttribute% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%MEMBERS_OF_GROUP%$jazz_ldap_membersOfGroup% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
sed -i s%USER_ATTRIBUTE_MAPPING%$jazz_ldap_userAttributesMapping% /tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties
echo "-----------------------"
echo " "
echo "------Remove plain text password from virtualimage.properties------"
sed -i s%db2inst1_password=$db2inst1_password%""% /etc/virtualimage.properties
echo "------Begin JTS Setup Wizard Automation & Install Money That Matters------"
jazz_ldap_primaryid=$jazz_ldap_primaryid jazz_ldap_primaryid_Password=$jazz_ldap_primaryid_Password su $WAS_USERNAME -c 'cd /opt/IBM/JazzTeamServer/server;./repotools-jts.sh -setup includeLifecycleProjectStep=true adminUserId=$jazz_ldap_primaryid adminPassword=$jazz_ldap_primaryid_Password parametersFile=/tmp/JTS_SETUP/jts_wiz_twoserverfixpack_db2.properties;if [ $? -ne 0 ]
then
exit 1
fi'
if [ $? -ne 0 ]
then
echo "JTS Setup Wizard Automation failed"
exit 1
fi
echo "------JTS Setup Wizard Complete------"
fi

if [ ${CLM_TOPOLOGY} == "SINGLESERVER_RSADM" ] && [ ${DB_TYPE} == "ORACLE" ]
then

echo "------String Sub JTS Wizard jts_wiz_rsadm_singleserver_oracle.properties------"
sed -i s%ORACLE_HOSTNAME_1%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties
sed -i s%ORACLE_HOSTNAME_2%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties
sed -i s%ORACLE_HOSTNAME_3%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties
sed -i s%ORACLE_HOSTNAME_4%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties
sed -i s%RSADM_HOSTNAME_1%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties
sed -i s%RSADM_HOSTNAME_2%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties
sed -i s%BASE_GROUP_DN%$jazz_ldap_baseGroupDN% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties
sed -i s%BASE_USER_DN%$jazz_ldap_baseUserDN% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties
sed -i s%REGISTRY_LOCATION%'ldap://'$jazz_userrealm% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties
sed -i s%REGISTRY_USERNAME%$jazz_userrole_RegistryUsername% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties
sed -i s%REGISTRY_PASSWORD%$jazz_userrole_RegistryPassword% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties
sed -i s%GROUP_MAPPING%$jazz_ldap_groupMapping% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties
sed -i s%GROUP_NAME_ATTRIBUTE%$jazz_ldap_groupNameAttribute% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties
sed -i s%MEMBERS_OF_GROUP%$jazz_ldap_membersOfGroup% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties
sed -i s%USER_ATTRIBUTE_MAPPING%$jazz_ldap_userAttributesMapping% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties
echo "-----------------------"
echo " "
echo "------Remove plain text password from virtualimage.properties------"
#sed -i s%dba_password=$dba_password%""% /etc/virtualimage.properties
echo "------Begin JTS Setup Wizard Automation & Install Money That Matters------"
scp /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_oracle.properties root@$JTS_HOSTNAME:/tmp/CLM/
ssh root@$JTS_HOSTNAME "cd /opt/IBM/JazzTeamServer/server;WAS_USERNAME=$WAS_USERNAME su $WAS_USERNAME -c './repotools-jts.sh -setup includeLifecycleProjectStep=true adminUserId=$jazz_ldap_primaryid adminPassword=$jazz_ldap_primaryid_Password parametersFile=/tmp/CLM/jts_wiz_rsadm_singleserver_oracle.properties;if [ $? -ne 0 ]
then
exit 1
fi';if [ $? -ne 0 ]
then
exit 1
fi"
if [ $? -ne 0 ]
then
echo "JTS Setup Wizard Automation failed"
exit 1
fi
echo "------JTS Setup Wizard Complete------"
fi


if [ ${CLM_TOPOLOGY} == "SINGLESERVER_RSADM" ] && [ ${DB_TYPE} == "DB2" ]
then

echo "------String Sub JTS Wizard jts_wiz_rsadm_singleserver_db2.properties------"
sed -i s%DB2_HOSTNAME_1%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%DB2_HOSTNAME_2%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%DB2_HOSTNAME_3%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%DB2_HOSTNAME_4%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%RSADM_HOSTNAME_1%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%RSADM_HOSTNAME_2%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%DB2INST1_PW_1%$dba_password% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%DB2INST1_PW_2%$dba_password% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%DB2INST1_PW_3%$dba_password% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%DB2INST1_PW_4%$dba_password% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%BASE_GROUP_DN%$jazz_ldap_baseGroupDN% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%BASE_USER_DN%$jazz_ldap_baseUserDN% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%REGISTRY_LOCATION%'ldap://'$jazz_userrealm% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%REGISTRY_USERNAME%$jazz_userrole_RegistryUsername% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%REGISTRY_PASSWORD%$jazz_userrole_RegistryPassword% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%GROUP_MAPPING%$jazz_ldap_groupMapping% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%GROUP_NAME_ATTRIBUTE%$jazz_ldap_groupNameAttribute% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%MEMBERS_OF_GROUP%$jazz_ldap_membersOfGroup% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
sed -i s%USER_ATTRIBUTE_MAPPING%$jazz_ldap_userAttributesMapping% /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties
echo "-----------------------"
echo " "
echo "------Remove plain text password from virtualimage.properties------"
sed -i s%dba_password=$dba_password%""% /etc/virtualimage.properties
echo "------Begin JTS Setup Wizard Automation & Install Money That Matters------"
scp /tmp/JTS_SETUP/jts_wiz_rsadm_singleserver_db2.properties root@$JTS_HOSTNAME:/tmp/CLM/
ssh root@$JTS_HOSTNAME "cd /opt/IBM/JazzTeamServer/server;WAS_USERNAME=$WAS_USERNAME su $WAS_USERNAME -c './repotools-jts.sh -setup includeLifecycleProjectStep=true adminUserId=$jazz_ldap_primaryid adminPassword=$jazz_ldap_primaryid_Password parametersFile=/tmp/CLM/jts_wiz_rsadm_singleserver_db2.properties;if [ $? -ne 0 ]
then
exit 1
fi';if [ $? -ne 0 ]
then
exit 1
fi"
if [ $? -ne 0 ]
then
echo "JTS Setup Wizard Automation failed"
exit 1
fi
echo "------JTS Setup Wizard Complete------"
fi


if [ ${CLM_TOPOLOGY} == "DISTRIBUTED_DB2" ]
then

echo "------String Sub JTS Wizard jts_wiz_distribute_db2.properties------"
export db2inst1_password=Rat10nal
sed -i s%DB2_HOSTNAME_1%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%DB2_HOSTNAME_2%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%DB2_HOSTNAME_3%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%DB2_HOSTNAME_4%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%DB2_HOSTNAME_5%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%DB2_HOSTNAME_6%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%CLM_HOSTNAME_1%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%CLM_HOSTNAME_2%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%CLM_HOSTNAME_3%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%DB2INST1_PW_1%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%DB2INST1_PW_2%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%DB2INST1_PW_3%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%DB2INST1_PW_4%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%DB2INST1_PW_5%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%DB2INST1_PW_6%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%BASE_GROUP_DN%$jazz_ldap_baseGroupDN% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%BASE_USER_DN%$jazz_ldap_baseUserDN% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%REGISTRY_LOCATION%'ldap\://'$jazz_userrealm% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%REGISTRY_USERNAME%$jazz_userrole_RegistryUsername% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%REGISTRY_PASSWORD%$jazz_userrole_RegistryPassword% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%GROUP_MAPPING%$jazz_ldap_groupMapping% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%GROUP_NAME_ATTRIBUTE%$jazz_ldap_groupNameAttribute% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%MEMBERS_OF_GROUP%$jazz_ldap_membersOfGroup% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
sed -i s%USER_ATTRIBUTE_MAPPING%$jazz_ldap_userAttributesMapping% /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties
echo "-----------------------"
echo " "
echo "------Remove plain text password from virtualimage.properties------"
sed -i s%db2inst1_password=$db2inst1_password%""% /etc/virtualimage.properties
echo "------Begin JTS Setup Wizard Automation & Install Money That Matters------"
scp /tmp/JTS_SETUP/jts_wiz_distribute_db2_403.properties root@$appnode0:/tmp/CLM/
ssh root@$appnode0 "sed -i s%com.ibm.team.repository.ws.allow.admin.access=false%""% /opt/IBM/JazzTeamServer/server/conf/jts/teamserver.properties;cd /opt/IBM/WebSphere/Profiles/DefaultAppSrv01/bin/;WAS_USERNAME=$WAS_USERNAME su $WAS_USERNAME -c './stopServer.sh server1;./startServer.sh server1';chmod -R 777 /tmp/CLM;ls -la /tmp/CLM;"
ssh root@$appnode0 "cd /opt/IBM/JazzTeamServer/server;WAS_USERNAME=$WAS_USERNAME su $WAS_USERNAME -c './repotools-jts.sh -setup includeLifecycleProjectStep=true adminUserId=$jazz_ldap_primaryid adminPassword=$jazz_ldap_primaryid_Password parametersFile=/tmp/CLM/jts_wiz_distribute_db2_403.properties;if [ $? -ne 0 ]
then
exit 1
fi';if [ $? -ne 0 ]
then
exit 1
fi"
if [ $? -ne 0 ]
then
echo "JTS Setup Wizard Automation failed"
exit 1
fi
echo "------JTS Setup Wizard Complete------"
if [ ${IMPORT_LDAP_USERS} == "Y" ]
then
echo "Import All Users"
ssh root@$appnode0 "cd /opt/IBM/JazzTeamServer/server;jazz_ldap_primaryid=$jazz_ldap_primaryid jazz_ldap_primaryid_Password=$jazz_ldap_primaryid_Password WAS_USERNAME=$WAS_USERNAME su $WAS_USERNAME -c './repotools-jts.sh -syncUsers repositoryURL=https://$HOSTNAME:9443/jts adminUserId=$jazz_ldap_primaryid adminPassword=$jazz_ldap_primaryid_Password logFile=repotools-jts_syncUsers.log'"
sleep 300
fi
fi


if [ ${CLM_TOPOLOGY} == "DISTRIBUTED_DB2_402" ]
then

echo "------String Sub JTS Wizard jts_wiz_distribute_db2.properties------"
export db2inst1_password=Rat10nal
sed -i s%DB2_HOSTNAME_1%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%DB2_HOSTNAME_2%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%DB2_HOSTNAME_3%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%DB2_HOSTNAME_4%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%DB2_HOSTNAME_5%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%DB2_HOSTNAME_6%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%CLM_HOSTNAME_1%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%CLM_HOSTNAME_2%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%CLM_HOSTNAME_3%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%DB2INST1_PW_1%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%DB2INST1_PW_2%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%DB2INST1_PW_3%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%DB2INST1_PW_4%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%DB2INST1_PW_5%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%DB2INST1_PW_6%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%BASE_GROUP_DN%$jazz_ldap_baseGroupDN% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%BASE_USER_DN%$jazz_ldap_baseUserDN% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%REGISTRY_LOCATION%'ldap\://'$jazz_userrealm% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%REGISTRY_USERNAME%$jazz_userrole_RegistryUsername% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%REGISTRY_PASSWORD%$jazz_userrole_RegistryPassword% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%GROUP_MAPPING%$jazz_ldap_groupMapping% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%GROUP_NAME_ATTRIBUTE%$jazz_ldap_groupNameAttribute% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%MEMBERS_OF_GROUP%$jazz_ldap_membersOfGroup% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
sed -i s%USER_ATTRIBUTE_MAPPING%$jazz_ldap_userAttributesMapping% /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties
echo "-----------------------"
echo " "
echo "------Remove plain text password from virtualimage.properties------"
sed -i s%db2inst1_password=$db2inst1_password%""% /etc/virtualimage.properties
echo "------Begin JTS Setup Wizard Automation & Install Money That Matters------"
scp /tmp/JTS_SETUP/jts_wiz_distribute_db2_402.properties root@$appnode0:/tmp/CLM/
ssh root@$appnode0 "sed -i s%com.ibm.team.repository.ws.allow.admin.access=false%""% /opt/IBM/JazzTeamServer/server/conf/jts/teamserver.properties;cd /opt/IBM/WebSphere/Profiles/DefaultAppSrv01/bin/;WAS_USERNAME=$WAS_USERNAME su $WAS_USERNAME -c './stopServer.sh server1;./startServer.sh server1';chmod -R 777 /tmp/CLM;ls -la /tmp/CLM;"
ssh root@$appnode0 "cd /opt/IBM/JazzTeamServer/server;WAS_USERNAME=$WAS_USERNAME su $WAS_USERNAME -c './repotools-jts.sh -setup includeLifecycleProjectStep=true adminUserId=$jazz_ldap_primaryid adminPassword=$jazz_ldap_primaryid_Password parametersFile=/tmp/CLM/jts_wiz_distribute_db2_402.properties;if [ $? -ne 0 ]
then
exit 1
fi';if [ $? -ne 0 ]
then
exit 1
fi"
if [ $? -ne 0 ]
then
echo "JTS Setup Wizard Automation failed"
exit 1
fi
echo "------JTS Setup Wizard Complete------"
fi


if [ ${CLM_TOPOLOGY} == "DISTRIBUTED_FP_DB2" ]
then

echo "------String Sub JTS Wizard jts_wiz_distribute_db2.properties------"
export db2inst1_password=Rat10nal
sed -i s%DB2_HOSTNAME_1%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%DB2_HOSTNAME_2%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%DB2_HOSTNAME_3%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%DB2_HOSTNAME_4%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%DB2_HOSTNAME_5%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%DB2_HOSTNAME_6%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%CLM_HOSTNAME_1%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%CLM_HOSTNAME_2%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%CLM_HOSTNAME_3%$HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%DB2INST1_PW_1%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%DB2INST1_PW_2%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%DB2INST1_PW_3%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%DB2INST1_PW_4%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%DB2INST1_PW_5%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%DB2INST1_PW_6%$db2inst1_password% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%BASE_GROUP_DN%$jazz_ldap_baseGroupDN% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%BASE_USER_DN%$jazz_ldap_baseUserDN% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%REGISTRY_LOCATION%'ldap\://'$jazz_userrealm% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%REGISTRY_USERNAME%$jazz_userrole_RegistryUsername% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%REGISTRY_PASSWORD%$jazz_userrole_RegistryPassword% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%GROUP_MAPPING%$jazz_ldap_groupMapping% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%GROUP_NAME_ATTRIBUTE%$jazz_ldap_groupNameAttribute% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%MEMBERS_OF_GROUP%$jazz_ldap_membersOfGroup% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
sed -i s%USER_ATTRIBUTE_MAPPING%$jazz_ldap_userAttributesMapping% /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties
echo "-----------------------"
echo " "
echo "------Remove plain text password from virtualimage.properties------"
sed -i s%db2inst1_password=$db2inst1_password%""% /etc/virtualimage.properties
echo "------Begin JTS Setup Wizard Automation & Install Money That Matters------"
scp /tmp/JTS_SETUP/jts_wiz_distributefixpack_db2.properties root@$appnode0:/tmp/CLM/
ssh root@$appnode0 "sed -i s%com.ibm.team.repository.ws.allow.admin.access=false%""% /opt/IBM/JazzTeamServer/server/conf/jts/teamserver.properties;cd /tmp/;./stopappnode0.sh;sleep 30;./startappnode0.sh;chmod -R 777 /tmp/CLM;ls -la /tmp/CLM;"
ssh root@$appnode0 "cd /opt/IBM/JazzTeamServer/server;WAS_USERNAME=$WAS_USERNAME su $WAS_USERNAME -c './repotools-jts.sh -setup includeLifecycleProjectStep=true adminUserId=$jazz_ldap_primaryid adminPassword=$jazz_ldap_primaryid_Password parametersFile=/tmp/CLM/jts_wiz_distributefixpack_db2.properties;if [ $? -ne 0 ]
then
exit 1
fi';if [ $? -ne 0 ]
then
exit 1
fi"
if [ $? -ne 0 ]
then
echo "JTS Setup Wizard Automation failed"
exit 1
fi
echo "------JTS Setup Wizard Complete------"
fi

if [ ${CLM_TOPOLOGY} == "DISTRIBUTED_ORACLE" ]
then

echo "------String Sub JTS Wizard jts_wiz_distribute_oracle.properties------"
sed -i s%DB_HOSTNAME_1%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%DB_HOSTNAME_2%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%DB_HOSTNAME_3%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%DB_HOSTNAME_4%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%DB_HOSTNAME_5%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%DB_HOSTNAME_6%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%CLM_HOSTNAME_1%$dmgrhost% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%CLM_HOSTNAME_2%$dmgrhost% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%CLM_HOSTNAME_3%$dmgrhost% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%BASE_GROUP_DN%$jazz_ldap_baseGroupDN% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%BASE_USER_DN%$jazz_ldap_baseUserDN% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%REGISTRY_LOCATION%$jazz_userrealm% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%REGISTRY_USERNAME%$jazz_userrole_RegistryUsername% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%REGISTRY_PASSWORD%$jazz_userrole_RegistryPassword% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%GROUP_MAPPING%$jazz_ldap_groupMapping% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%GROUP_NAME_ATTRIBUTE%$jazz_ldap_groupNameAttribute% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%MEMBERS_OF_GROUP%$jazz_ldap_membersOfGroup% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
sed -i s%USER_ATTRIBUTE_MAPPING%$jazz_ldap_userAttributesMapping% /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties
echo "-----------------------"
echo " "
echo "------Begin JTS Setup Wizard Automation & Install Money That Matters------"
scp /tmp/JTS_SETUP/jts_wiz_distribute_oracle.properties root@$appnode0:/tmp/CLM/
ssh root@$appnode0 "sed -i s%com.ibm.team.repository.ws.allow.admin.access=false%""% /opt/IBM/JazzTeamServer/server/conf/jts/teamserver.properties;cd /tmp/;./stopappnode0.sh;sleep 30;./startappnode0.sh;chmod -R 777 /tmp/CLM;ls -la /tmp/CLM;"
ssh root@$appnode0 "cd /opt/IBM/JazzTeamServer/server;WAS_USERNAME=$WAS_USERNAME su $WAS_USERNAME -c './repotools-jts.sh -setup includeLifecycleProjectStep=true adminUserId=$jazz_ldap_primaryid adminPassword=$jazz_ldap_primaryid_Password parametersFile=/tmp/CLM/jts_wiz_distribute_oracle.properties;if [ $? -ne 0 ]
then
exit 1
fi';if [ $? -ne 0 ]
then
exit 1
fi"
if [ $? -ne 0 ]
then
echo "JTS Setup Wizard Automation failed"
exit 1
fi
echo "------JTS Setup Wizard Complete------"
fi

if [ ${CLM_TOPOLOGY} == "DISTRIBUTED_FP_ORACLE" ]
then

echo "------String Sub JTS Wizard ts_wiz_distributefixpack_oracle.properties------"
sed -i s%DB_HOSTNAME_1%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%DB_HOSTNAME_2%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%DB_HOSTNAME_3%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%DB_HOSTNAME_4%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%DB_HOSTNAME_5%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%DB_HOSTNAME_6%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%CLM_HOSTNAME_1%$dmgrhost% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%CLM_HOSTNAME_2%$dmgrhost% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%CLM_HOSTNAME_3%$dmgrhost% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%BASE_GROUP_DN%$jazz_ldap_baseGroupDN% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%BASE_USER_DN%$jazz_ldap_baseUserDN% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%REGISTRY_LOCATION%$jazz_userrealm% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%REGISTRY_USERNAME%$jazz_userrole_RegistryUsername% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%REGISTRY_PASSWORD%$jazz_userrole_RegistryPassword% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%GROUP_MAPPING%$jazz_ldap_groupMapping% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%GROUP_NAME_ATTRIBUTE%$jazz_ldap_groupNameAttribute% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%MEMBERS_OF_GROUP%$jazz_ldap_membersOfGroup% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
sed -i s%USER_ATTRIBUTE_MAPPING%$jazz_ldap_userAttributesMapping% /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties
echo "-----------------------"
echo " "
echo "------Begin JTS Setup Wizard Automation & Install Money That Matters------"
scp /tmp/JTS_SETUP/jts_wiz_distributefixpack_oracle.properties root@$appnode0:/tmp/CLM/
ssh root@$appnode0 "sed -i s%com.ibm.team.repository.ws.allow.admin.access=false%""% /opt/IBM/JazzTeamServer/server/conf/jts/teamserver.properties;cd /tmp/;./stopappnode0.sh;sleep 30;./startappnode0.sh;chmod -R 777 /tmp/CLM;ls -la /tmp/CLM;"
ssh root@$appnode0 "cd /opt/IBM/JazzTeamServer/server;WAS_USERNAME=$WAS_USERNAME su $WAS_USERNAME -c './repotools-jts.sh -setup includeLifecycleProjectStep=true adminUserId=$jazz_ldap_primaryid adminPassword=$jazz_ldap_primaryid_Password parametersFile=/tmp/CLM/jts_wiz_distributefixpack_oracle.properties;if [ $? -ne 0 ]
then
exit 1
fi';if [ $? -ne 0 ]
then
exit 1
fi"
if [ $? -ne 0 ]
then
echo "JTS Setup Wizard Automation failed"
exit 1
fi
echo "------JTS Setup Wizard Complete------"
fi


if [ ${CLM_TOPOLOGY} == "CLUSTER_ORACLE" ]
then

echo "------String Sub JTS Wizard jts_wiz_cluster_oracle.properties------"
sed -i s%DB_HOSTNAME_1%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%DB_HOSTNAME_2%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%DB_HOSTNAME_3%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%DB_HOSTNAME_4%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%DB_HOSTNAME_5%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%DB_HOSTNAME_6%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%CLM_HOSTNAME_1%$dmgrhost% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%CLM_HOSTNAME_2%$dmgrhost% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%CLM_HOSTNAME_3%$dmgrhost% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%BASE_GROUP_DN%$jazz_ldap_baseGroupDN% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%BASE_USER_DN%$jazz_ldap_baseUserDN% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%REGISTRY_LOCATION%'ldap\://'$jazz_userrealm% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%REGISTRY_USERNAME%$jazz_userrole_RegistryUsername% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%REGISTRY_PASSWORD%$jazz_userrole_RegistryPassword% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%GROUP_MAPPING%$jazz_ldap_groupMapping% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%GROUP_NAME_ATTRIBUTE%$jazz_ldap_groupNameAttribute% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%MEMBERS_OF_GROUP%$jazz_ldap_membersOfGroup% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
sed -i s%USER_ATTRIBUTE_MAPPING%$jazz_ldap_userAttributesMapping% /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties
echo "-----------------------"
echo " "
echo "------Begin JTS Setup Wizard Automation & Install Money That Matters------"
scp /tmp/JTS_SETUP/jts_wiz_cluster_oracle.properties root@$appnode2:/tmp/CLM
ssh root@$appnode2 "sed -i s%com.ibm.team.repository.ws.allow.admin.access=false%""% /opt/IBM/JazzTeamServer/server/conf/jts/teamserver.properties;cd /opt/IBM/WebSphere/Profiles/DefaultCustom01/bin;WAS_USERNAME=$WAS_USERNAME jazz_ldap_primaryid=$jazz_ldap_primaryid jazz_ldap_primaryid_Password=$jazz_ldap_primaryid_Password su $WAS_USERNAME -c './stopServer.sh AppNode2 -username $jazz_ldap_primaryid -password $jazz_ldap_primaryid_Password;./startServer.sh AppNode2';chmod -R 777 /tmp/CLM;ls -la /tmp/CLM;"
ssh root@$appnode2 "cd /opt/IBM/JazzTeamServer/server;WAS_USERNAME=$WAS_USERNAME jazz_ldap_primaryid=$jazz_ldap_primaryid jazz_ldap_primaryid_Password=$jazz_ldap_primaryid_Password su $WAS_USERNAME -c './repotools-jts.sh -setup includeLifecycleProjectStep=true adminUserId=$jazz_ldap_primaryid adminPassword=$jazz_ldap_primaryid_Password parametersFile=/tmp/CLM/jts_wiz_cluster_oracle.properties;if [ $? -ne 0 ]
then
exit 1
fi';if [ $? -ne 0 ]
then
exit 1
fi"
if [ $? -ne 0 ]
then
echo "JTS Setup Wizard Automation failed"
exit 1
fi
echo "------JTS Setup Wizard Complete------"
if [ ${IMPORT_LDAP_USERS} == "Y" ]
then
echo "Import All Users"
ssh root@$appnode2 "cd /opt/IBM/JazzTeamServer/server;jazz_ldap_primaryid=$jazz_ldap_primaryid jazz_ldap_primaryid_Password=$jazz_ldap_primaryid_Password WAS_USERNAME=$WAS_USERNAME su $WAS_USERNAME -c './repotools-jts.sh -syncUsers repositoryURL=https://$dmgrhost:1025/jts adminUserId=$jazz_ldap_primaryid adminPassword=$jazz_ldap_primaryid_Password logFile=repotools-jts_syncUsers.log'"
sleep 300
fi
fi

if [ ${CLM_TOPOLOGY} == "CLUSTER_FP_ORACLE" ]
then

echo "------String Sub JTS Wizard jts_wiz_clusterfixpack_oracle.properties------"
sed -i s%DB_HOSTNAME_1%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%DB_HOSTNAME_2%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%DB_HOSTNAME_3%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%DB_HOSTNAME_4%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%DB_HOSTNAME_5%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%DB_HOSTNAME_6%$DB_HOSTNAME% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%CLM_HOSTNAME_1%$dmgrhost% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%CLM_HOSTNAME_2%$dmgrhost% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%CLM_HOSTNAME_3%$dmgrhost% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%BASE_GROUP_DN%$jazz_ldap_baseGroupDN% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%BASE_USER_DN%$jazz_ldap_baseUserDN% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%REGISTRY_LOCATION%'ldap\://'$jazz_userrealm% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%REGISTRY_USERNAME%$jazz_userrole_RegistryUsername% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%REGISTRY_PASSWORD%$jazz_userrole_RegistryPassword% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%GROUP_MAPPING%$jazz_ldap_groupMapping% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%GROUP_NAME_ATTRIBUTE%$jazz_ldap_groupNameAttribute% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%MEMBERS_OF_GROUP%$jazz_ldap_membersOfGroup% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
sed -i s%USER_ATTRIBUTE_MAPPING%$jazz_ldap_userAttributesMapping% /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties
echo "-----------------------"
echo " "
echo "------Begin JTS Setup Wizard Automation & Install Money That Matters------"
scp /tmp/JTS_SETUP/jts_wiz_clusterfixpack_oracle.properties root@$appnode2:/tmp/
ssh root@$appnode2 "sed -i s%com.ibm.team.repository.ws.allow.admin.access=false%""% /opt/IBM/JazzTeamServer/server/conf/jts/teamserver.properties;cd /opt/IBM/WebSphere/Profiles/DefaultCustom01/bin;WAS_USERNAME=$WAS_USERNAME jazz_ldap_primaryid=$jazz_ldap_primaryid jazz_ldap_primaryid_Password=$jazz_ldap_primaryid_Password su $WAS_USERNAME -c './stopServer.sh AppNode2 -username $jazz_ldap_primaryid -password $jazz_ldap_primaryid_Password;./startServer.sh AppNode2';chmod -R 777 /tmp/;ls -la /tmp/;"
ssh root@$appnode2 "cd /opt/IBM/JazzTeamServer/server;WAS_USERNAME=$WAS_USERNAME jazz_ldap_primaryid=$jazz_ldap_primaryid jazz_ldap_primaryid_Password=$jazz_ldap_primaryid_Password su $WAS_USERNAME -c './repotools-jts.sh -setup includeLifecycleProjectStep=true adminUserId=$jazz_ldap_primaryid adminPassword=$jazz_ldap_primaryid_Password parametersFile=/tmp/jts_wiz_clusterfixpack_oracle.properties;if [ $? -ne 0 ]
then
exit 1
fi';if [ $? -ne 0 ]
then
exit 1
fi"
if [ $? -ne 0 ]
then
echo "JTS Setup Wizard Automation failed"
exit 1
fi
echo "------JTS Setup Wizard Complete------"
fi

exit 0
