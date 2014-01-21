#!/bin/sh
. /etc/virtualimage.properties

#############################################
# 	Authored: Jennifer Liu (yeliu@us.ibm.com)
#       Rational Core Team Automation
#       
###########################################

echo "check the process ps -ef | grep AppNode2"
ps -ef | grep AppNode2

id=`ps -ef | grep AppNode2|grep java|awk -F" " '{print $2}'`
echo "The Appnode2 pid is $id, we need kill it"
kill -9 $id
echo "check to see if it killed the AppNode2 process"
ps -ef | grep AppNode2
echo "Completed Cleanup AppNode2 Process"

