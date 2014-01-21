#!/bin/bash
#********************************************************************************
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2013. All Rights Reserved.
#  
# U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
#********************************************************************************

. /etc/virtualimage.properties

IHS_HOME=/opt/IBM/HTTPServer
PLUGIN_HOME=/opt/IBM/Plugins

echo "------------------extend the plugin key store password----------------"
$IHS_HOME/bin/gskcmd -keydb -changepw -db $PLUGIN_HOME/config/webserver1/plugin-key.kdb -pw WebAS -new_pw WebAS -expire 1200 -stash

echo "----------------- generate new plugin self-sign ceritificate named: webspherenewpluginkey ------"
echo "HOSTNAME is $HOSTNAME"
$IHS_HOME/bin/gskcmd -cert -create -db /opt/IBM/Plugins/config/webserver1/plugin-key.kdb -label webspherenewpluginkey -expire 365 -dn "CN=$HOSTNAME" -default_cert yes -pw WebAS



