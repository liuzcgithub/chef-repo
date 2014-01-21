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

cp $SCRIPTS_DIR/plugin-cfg-template.xml $SCRIPTS_DIR/plugin-cfg.xml

sed -i s%_WebServerMerge_%webservermerge%g $SCRIPTS_DIR/plugin-cfg.xml

stopcount=$NUMBER_OF_CUSTOM_NODES
for (( i=0; i<$stopcount; i++ ))
do
        c_host_var=appnode$i
        eval c_host=\$$c_host_var
	ServerNodeName=`ssh root@$c_host  grep -m 1 NODE_NAME /etc/virtualimage.properties |cut -d = -f2`
	echo "-------------- Servernodename is $ServerNodeName\n"
	webserverNN="_WebServer"$i"_Node_Name_"
	webserverHN="_WebServer"$i"_Host_Name_"	
	sed -i s%"$webserverNN"%$ServerNodeName%g $SCRIPTS_DIR/plugin-cfg.xml
	sed -i s%"$webserverHN"%$c_host%g $SCRIPTS_DIR/plugin-cfg.xml
done


