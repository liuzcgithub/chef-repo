#!/bin/sh
#********************************************************************************
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2013. All Rights Reserved.
#  
# U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
#********************************************************************************

IHS_HOME=/opt/IBM/HTTPServer
httpConfFile=/opt/IBM/HTTPServer/conf/httpd.conf
sed -i s%WebSpherePluginConfig%#WebSpherePluginConfig% $httpConfFile
echo "WebSpherePluginConfig /opt/IBM/Plugins/config/webservermerge/plugin-cfg.xml" >> $httpConfFile
echo "LoadModule ibm_ssl_module modules/mod_ibm_ssl.so" >> $httpConfFile
echo "Listen 9443" >> $httpConfFile

echo "<VirtualHost *:9443>"  >> $httpConfFile
echo "SSLEnable" >> $httpConfFile
echo "</VirtualHost>" >> $httpConfFile
echo "KeyFile /opt/IBM/HTTPServer/ihsserverkey.kdb" >> $httpConfFile
echo "SSLDisable" >> $httpConfFile
echo "SetEnv websphere-nocanon 1" >> $httpConfFile

