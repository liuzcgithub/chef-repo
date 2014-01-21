#!/bin/sh
. /etc/virtualimage.properties
#############################################
#       Authored: Jennifer Liu (yeliu@us.ibm.com)
#       Rational Core Team Automation
#       This script restarts WAS processes
#	Updated: Tanya Wolff after moving to WASCommon
###########################################
WASCOMMON=/tmp/WASCommon
$WASCOMMON/WASScripts/stopWASCluster_IHS.sh
$WASCOMMON/WASScripts/startWASCluster_IHS.sh
 
