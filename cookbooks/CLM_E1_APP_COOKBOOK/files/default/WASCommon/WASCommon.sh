#!/bin/sh
. /etc/virtualimage.properties
#############################################################################
# Name: WASCommon.sh
#	Authored: Tanya Wolff (twolff@ca.ibm.com)
#
#    This script 
#	1. Replaces LDAPSecurity.properties with user chosen LDAP server
#	2. Updates custom properties
#	3. Enables LDAP security on WAS
#	4. Installs Performance Inspector
#############################################################################
#
chmod -R 775 .
#cp -fr /tmp/WASCommon/LDAP /tmp
 
WAS_SCRIPTS_DIR=/tmp/WASCommon
if [ "$WAS_USER_NAME" == "" ]; then
echo "WAS_USER_NAME=$WAS_USERNAME" >> /etc/virtualimage.properties
fi
#
if [ "$PROFILE_TYPE" == "dmgr" ]; then
	echo "----- setup SSH between dmgr and nodes"
	sshScripts/SetupRemote.sh $dmgrhost $appnode1 $appnode2
fi

# configure WAS server session properties
UpdateWASConfig.sh
# configure WAS security
enableLDAP.sh
