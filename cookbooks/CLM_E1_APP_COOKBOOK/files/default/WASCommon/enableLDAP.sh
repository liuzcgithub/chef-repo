#!/bin/sh
. /etc/virtualimage.properties
#############################################################################
# Name: EnableLDAP.sh
#	Authored: Tanya Wolff (twolff@ca.ibm.com)
#
#    This script 
#	1. sets up soap properties for ldap primary id
#	2. configures WAS for LDAP
#	3. restarts WAS
#############################################################################
WASScripts=/tmp/WASCommon/WASScripts
LDAPScripts=/tmp/WASCommon/LDAP

echo "WAS_USER_NAME=$WAS_USER_NAME"
echo "WAS_PROFILE_ROOT=$WAS_PROFILE_ROOT"
echo "LDAPPROP=$LDAPPROP"

echo "----- Set appropriate LDAP script according to env"
if [ "$LDAPPROP" ]; then
  if [ -e "$LDAPScripts/${LDAPPROP}_LDAPSecurity.properties" ]; then
    echo "----- Substituting LDAPSecurity.properties for $LDAPPROP"
    cp -f $LDAPScripts/${LDAPPROP}_LDAPSecurity.properties $LDAPScripts/LDAPSecurity.properties
  else
    echo "Warning: ${LDAPPROP}_LDAPSecurity.properties not found. Using default"
  fi
fi

. $LDAPScripts/LDAPSecurity.properties
echo "jazz_ldap_primaryid=$jazz_ldap_primaryid"

echo "----- enable LDAP and sync nodes ---------------------------"

# double quote so WAS_PROFILE_ROOT will be interpreted from root's env
su -c "$WAS_PROFILE_ROOT/bin/wsadmin.sh -lang jython -f /tmp/WASCommon/enableLDAP.py $LDAPPROP $PROFILE_TYPE" - $WAS_USER_NAME
if [ $? -ne 0 ]; then
echo "Could not set LDAP for $LDAPPROP. Login to the WAS console, disable administrative security, restart the server, then run this script again."
exit 1
fi

# Set the credentials so WAS_USER_NAME can start/stop WAS

# Note if WAS_USER_NAME is different than the owner of WAS/bin files,
# Then they need to set credentials to be able to execute wsadmin
# in their java user.home directory which overrides soap.client.props
# SOAPPROPS=~${WAS_USERNAME}/wsadmin.properties

# If manually adding passwords in soap.client.props, then encrypt password with
# $WAS_PROFILE_ROOT/bin/PropFilePasswordEncoder.sh $SOAPPROPS com.ibm.SOAP.loginPassword
echo "----- Setting up soap properties for $jazz_ldap_primaryid"
SOAPPROPS="$WAS_PROFILE_ROOT/properties/soap.client.props"
echo "SOAPPROPS=$SOAPPROPS"
if [ -e $SOAPPROPS ]; then
sed -i s/^.*com.ibm.SOAP.securityEnabled=.*$/com.ibm.SOAP.securityEnabled=true/ $SOAPPROPS
sed -i s/^.*com.ibm.SOAP.loginUserid=.*$/com.ibm.SOAP.loginUserid=$jazz_ldap_primaryid/ $SOAPPROPS
sed -i s/^.*com.ibm.SOAP.loginPassword=.*$/com.ibm.SOAP.loginPassword=$jazz_ldap_primaryid_Password/ $SOAPPROPS
else
echo com.ibm.SOAP.securityEnabled=true > $SOAPPROPS
echo com.ibm.SOAP.loginUserid=$jazz_ldap_primaryid >> $SOAPPROPS
echo com.ibm.SOAP.loginPassword=$jazz_ldap_primaryid_Password >> $SOAPPROPS
fi
$WAS_PROFILE_ROOT/bin/PropFilePasswordEncoder.sh $SOAPPROPS com.ibm.SOAP.loginPassword

if [ "$PROFILE_TYPE" == "dmgr" ]; then
	echo "----- Setting up soap properties for Appnodes"
	# we copy dmgr SOAPPROPS to appnodes soapprops"
	ssh root@$appnode1 "su - clmadmin -c 'cp /opt/IBM/WebSphere/Profiles/DefaultCustom01/properties/soap.client.props /opt/IBM/WebSphere/Profiles/DefaultCustom01/properties/soap.client.props.bak'"
	ssh root@$appnode2 "su - clmadmin -c 'cp /opt/IBM/WebSphere/Profiles/DefaultCustom01/properties/soap.client.props /opt/IBM/WebSphere/Profiles/DefaultCustom01/properties/soap.client.props.bak'"
	scp $SOAPPROPS clmadmin@$appnode1:/opt/IBM/WebSphere/Profiles/DefaultCustom01/properties/soap.client.props"
	scp $SOAPPROPS clmadmin@$appnode2:/opt/IBM/WebSphere/Profiles/DefaultCustom01/properties/soap.client.props"
	echo "----- Setting up soap properties for Proxy01 profile"
	SOAPPROPS="$PROFILE_ROOT/Proxy01/properties/soap.client.props"
	echo "SOAPPROPS=$SOAPPROPS"
	if [ -e $SOAPPROPS ]; then
	sed -i s/^.*com.ibm.SOAP.securityEnabled=.*$/com.ibm.SOAP.securityEnabled=true/ $SOAPPROPS
	sed -i s/^.*com.ibm.SOAP.loginUserid=.*$/com.ibm.SOAP.loginUserid=$jazz_ldap_primaryid/ $SOAPPROPS
	sed -i s/^.*com.ibm.SOAP.loginPassword=.*$/com.ibm.SOAP.loginPassword=$jazz_ldap_primaryid_Password/ $SOAPPROPS
	else
	echo com.ibm.SOAP.securityEnabled=true > $SOAPPROPS
	echo com.ibm.SOAP.loginUserid=$jazz_ldap_primaryid >> $SOAPPROPS
	echo com.ibm.SOAP.loginPassword=$jazz_ldap_primaryid_Password >> $SOAPPROPS
	fi
	$PROFILE_ROOT/Proxy01/bin/PropFilePasswordEncoder.sh $SOAPPROPS com.ibm.SOAP.loginPassword
fi

echo "----- Stopping WAS After LDAP enabled --------------------------------"
if [ "$PROFILE_TYPE" == "dmgr" ]; then
	$WASScripts/stopWASCluster.sh
	if [ $? -ne 0 ]; then
	echo "Error: Server didn't stop." 
	exit 1
	fi
else
	$WASScripts/StopSingleWAS.sh
	if [ $? -ne 0 ]; then
	echo "Error: Server didn't stop. Try restarting using the old admin's credentials for the stopServer action only. "
	echo "Eg: /tmp/WASCommon/WASScripts/RestartSingleWAS.sh old_ldap_user old_ldap_pw"
	exit 1
	fi
fi
echo "-----Start WAS After LDAP enabled --------------------------------"
if [ "$PROFILE_TYPE" == "dmgr" ]; then
	$WASScripts/startWASCluster.sh
else
	$WASScripts/StartSingleWAS.sh
fi

