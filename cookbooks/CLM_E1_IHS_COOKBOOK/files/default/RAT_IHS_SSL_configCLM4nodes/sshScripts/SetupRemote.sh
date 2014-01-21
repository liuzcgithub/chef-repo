#!/bin/sh
#********************************************************************************
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2013. All Rights Reserved.
#  
# U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
#********************************************************************************

echo "before virtual.properite in setRemote.sh"
. /etc/virtualimage.properties
echo "after virtual.properite in setRemote.sh"

#############################################
#       Authored: Jennifer Liu (yeliu@us.ibm.com)
#       Rational Core Team Automation
#
#       This script will install expect and setup ssh between dmgr and custom nodes
#Note: it hardcode for the Root password install directory
###########################################

ROOT_PASSWORD=aut0mat10n
#ROOT_PASSWORD=ec11ipse
echo "-------------- Setup SSH password is $ROOT_PASSWORD ---------------"

echo "Installing expect if it is not find on the system"
$SCRIPTS_DIR/sshScripts/install_expect.sh
stopcount=$NUMBER_OF_CUSTOM_NODES
echo "set up ssh on dmgr machines..."
for (( i=0; i<$stopcount; i++ ))
do
        c_host_var=appnode$i
        eval c_host=\$$c_host_var
        echo "\nSetting ssh for $c_host ...."
	$SCRIPTS_DIR/sshScripts/setupSSH -p $ROOT_PASSWORD root@$c_host
done

