#!/bin/sh
#********************************************************************************
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2013. All Rights Reserved.
#  
# U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
#********************************************************************************

. /etc/virtualimage.properties

pluginKeyStore=/opt/IBM/Plugins/config/webservermerge

echo "Download retrievesigner.jar from MSA storaget, this utility is from SVT team, if there is an issue using this jar file, we need contact SVT team"
cd /tmp/RAT_IHS_SSL_config/
java -jar $AUTO_PREP/MSA_Key/GetSecureFile.jar $MEDIA_SERVER/WAS/retrievesigner.jar $AUTO_PREP/MSA_Key/ratlauto.key false

stopcount=$NUMBER_OF_CUSTOM_NODES
for (( i=0; i<$stopcount; i++ ))
do
        c_host_var=appnode$i
        eval c_host=\$$c_host_var
	echo "Retrievesigner from $c_host"
	echo "------------------------------------"
	cd $pluginKeyStore
	java -jar /tmp/RAT_IHS_SSL_config/retrievesigner.jar $c_host 9043 plugin-key.kdb
 	
	echo "Restart WAS process on $c_host"
	echo "-------------------------------------"
        ssh root@$c_host "echo "y" | sh /tmp/WASCommon/WASScripts/RestartSingleWAS.sh" 
	ssh root@$c_host sh /tmp/WASCommon/UpdateFIPS_Each.sh
done

echo "Update httpd.conf and pluginp-cfg.xml file"
echo "--------------------------------"
sh /tmp/RAT_IHS_SSL_config/updateFIP_configFile.sh

echo "Enable FIPS on all WAS nodes"
echo "------------------------------"
for (( i=0; i<$stopcount; i++ ))
do
        c_host_var=appnode$i
        eval c_host=\$$c_host_var
	echo "enable FIPS on $c_host"
	echo "---------------------------------------"
	ssh root@$c_host /tmp/WASCommon/EnableWASFIPS.sh 
done

sh /tmp/RAT_IHS_SSL_config/RestartApplicationSrv.sh

echo "Copy webserver0.kdb file over"
echo "-----------------------------------"
scp root@$appnode0:/etc/virtualimage.properties get.properties
appnode0Cell=`grep CELL get.properties | cut -d "=" -f2`
appnodeProRoot=`grep WAS_PROFILE_ROOT get.properties | cut -d "=" -f2`
rm -f get.properties
scp root@$appnode0:$appnodeProRoot/config/cells/$appnode0Cell/nodes/${ihshost}-node/servers/webserver0/webserver0.kdb /opt/IBM/HTTPServer/conf

sh /tmp/RAT_IHS_SSL_config/RestartWebServer.sh
