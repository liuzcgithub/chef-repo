#!/bin/sh
. /etc/virtualimage.properties
#********************************************************************************
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2013. All Rights Reserved.
#  
# U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
#********************************************************************************

#############################################
#       This script restart WAS processes except dmgr
#Note: it hardcode for the WAS_HOME, WASAdmin and WASPassword
###########################################



IHS_HOME="/opt/IBM/HTTPServer"

adminUser=clmadmin
adminPassword=ec11ipse

$IHS_HOME/bin/adminctl stop
$IHS_HOME/bin/apachectl stop
echo "sleep 30 seconds to wait all processes completed...."
sleep 30
$IHS_HOME/bin/adminctl start
$IHS_HOME/bin/apachectl start

