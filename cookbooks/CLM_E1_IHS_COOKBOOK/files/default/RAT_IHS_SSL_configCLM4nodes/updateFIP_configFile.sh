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
pluginConfFile=/opt/IBM/Plugins/config/webservermerge/plugin-cfg.xml

cp $httpConfFile ${httpConfFile}_bak
cp $pluginConfFile ${pluginConfFile}_bak

sed -i s%"^<VirtualHost \*:9443>"%% $httpConfFile
sed -i s%"^SSLEnable"%% $httpConfFile
sed -i s%"^</VirtualHost>"%% $httpConfFile
sed -i s%"^SSLDisable"%% $httpConfFile
sed -i s%"KeyFile \"/opt/IBM/HTTPServer/conf/webserver0.kdb\""%% $httpConfFile

echo "" >>  $httpConfFile
echo "<VirtualHost *:9443>"  >> $httpConfFile
echo "SSLEnable" >> $httpConfFile
echo "SSLProtocolEnable TLSv12" >> $httpConfFile
echo "SSLServerCert selfSigned" >> $httpConfFile
echo "SSLFIPSEnable" >> $httpConfFile
echo "SSLProtocolDisable SSLv2 SSLv3 TLSv1 TLSv11" >> $httpConfFile
echo "KeyFile /opt/IBM/HTTPServer/conf/webserver0.kdb" >> $httpConfFile
echo "</VirtualHost>" >> $httpConfFile

sed -i s%"FIPSEnable=\"false\""%"FIPSEnable=\"true\" StrictSecurity=\"true\" "% $pluginConfFile
