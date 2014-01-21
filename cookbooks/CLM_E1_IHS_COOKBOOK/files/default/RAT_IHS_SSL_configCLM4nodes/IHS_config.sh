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

IHS_HOME=/opt/IBM/HTTPServer
PLUGIN_HOME=/opt/IBM/Plugins
chmod 755 $SCRIPTS_DIR/sshScripts/*
#set up ssh 
echo "-------------- Set up SSH remote access to app nodes ------------------"
$SCRIPTS_DIR/sshScripts/SetupRemote.sh


# Get the extracted cert from app servers
# scp root@$appnode1:/tmp/serverroot.cer /tmp/serverroot2.cer
stopcount=$NUMBER_OF_CUSTOM_NODES
for (( i=0; i<$stopcount; i++ ))
do
        c_host_var=appnode$i
        eval c_host=\$$c_host_var
        echo "\ncopy server root for $c_host ...."
	scp root@$c_host:/tmp/serverroot.cer /tmp/serverroot$i.cer
done

#enable SSL from httpd.conf
echo "----------------------Enable SSL from httpd.conf--------------"
sh $SCRIPTS_DIR/enableSSL.sh

#Setup SSL on the IHS server with a self-signed certificate
echo "-------------------- create ihsserverkey key store--------------------"
cd $IHS_HOME
$IHS_HOME/bin/gskcmd -keydb -create -db ihsserverkey.kdb -pw ec11ipse -expire 365 -stash -type cms
echo "------------------ Create self sign certificate ---------------"
$IHS_HOME/bin/gskcmd -cert -create -db ihsserverkey.kdb -label ihsserver -expire 365 -dn "CN=$ihshost" -default_cert yes  -pw ec11ipse

for (( i=0; i<$stopcount; i++ ))
do
	echo "---------------------- add server root $i certificate to plugin, SSL hand shake -------------------"
	$IHS_HOME/bin/gskcmd -cert -add -db /opt/IBM/Plugins/config/webserver1/plugin-key.kdb -label server-root$i -pw WebAS -file /tmp/serverroot$i.cer
done

echo "------------------------ make webservermerge log directory -----------------"
mkdir /opt/IBM/Plugins/logs/webservermerge

echo "------------------------ copy webserver1 directory to merge directory  -----"
cp -fr /opt/IBM/Plugins/config/webserver1 /opt/IBM/Plugins/config/webservermerge 
cp -f /opt/IBM/Plugins/config/webserver1/* /opt/IBM/Plugins/config/webservermerge 

echo "----------------- Merge Plugin-cfg.xml and put it on webservermerge directory ----------------------"
sh $SCRIPTS_DIR/MergePluginFile.sh
cp $SCRIPTS_DIR/plugin-cfg.xml /opt/IBM/Plugins/config/webservermerge/plugin-cfg.xml

echo "----------------- Restart webserver ---------------------------"
sh  $SCRIPTS_DIR/RestartWebServer.sh

echo "------------------ restart all application servers ---------------"
sh $SCRIPTS_DIR/RestartApplicationSrv.sh

