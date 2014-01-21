#!/bin/bash
export ihshost=$ihshost
export WebserverName="webserver3"

echo "Create WebServer" $WebserverName

command="AdminTask.createWebServerByHostName('[-webserverName $WebserverName -templateName IHS -webPort 80 -serviceName -webInstallRoot /opt/IBM/HTTPServer -webProtocol HTTP -configurationFile -errorLogfile -accessLogfile -pluginInstallRoot /opt/IBM/Plugins -webAppMapping ALL -hostName $ihshost -platform linux -adminPort 8008 -adminUserID $WAS_USER_NAME -adminPasswd $WAS_PASSWORD -adminProtocol HTTP]')"

#/opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -lang jython -c "$command"
su -c "WebserverName=$WebserverName ihshost=$ihshost /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -lang jython -f /tmp/Create_WebServer/CreateWebServer.py" -- $WAS_USER_NAME


