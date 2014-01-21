#!/bin/sh
. /etc/virtualimage.properties

#############################################################################
# Name: StartSingleWAS.sh
#	Authored: Jennifer Liu (yeliu@us.ibm.com)
#
# Updated for SSE nonRoot: Kenneth Thomson (kenneth.thomson@uk.ibm.com)	
#	
#############################################################################

WAS_SCRIPTS_DIR=/tmp/WASCommon/WASScripts
WAS_HOME=$WAS_PROFILE_ROOT
echo "WAS_HOME=$WAS_PROFILE_ROOT"

# from this scripts parameters
echo "SCRIPTS_DIR=$SCRIPTS_DIR"
echo "COMPONENT=$COMPONENT"

# if WAS_USER_NAME doesn't exist, then WASCommon wasn't run
if [ -z "$WAS_USER_NAME" ]; then 
WAS_USER_NAME=$WAS_USERNAME
fi
echo "WAS_USER_NAME=$WAS_USER_NAME"

cd $WAS_HOME/bin

#install apps on WAS
echo "Install CLM application ($COMPONENT) to WAS appserver....."
su - $WAS_USER_NAME -c "$WAS_HOME/bin/wsadmin.sh -lang jython -f $SCRIPTS_DIR/InstallCLMapps.py ${COMPONENT}"
if [ $? -ne 0 ]
then
echo "CLM Application Deployment failed"
exit 1
fi
echo "CLM Application deployment succeeded"
echo "-----------------------"
echo " "


#If WASCommon installed
if [ -e "$WAS_SCRIPTS_DIR" ]; then
  echo "------Restart WebSphere Server------"
  $WAS_SCRIPTS_DIR/RestartSingleWAS.sh
  if [ $? -ne 0 ]; then
    exit 1
  fi
  echo "Apps deployed and WebSphere Server restarted"
  exit 0
fi



echo "------Restart (Stop) WebSphere Server------"
su - $WAS_USER_NAME -c "$WAS_HOME/bin/stopServer.sh server1"
if [ $? -ne 0 ]
then
echo "WebSphere Server failed to stop"
exit 1
fi
echo "WebSphere Server stopped"
echo "-----------------------"
echo " "

echo "------Restart (Start) WebSphere Server------"
su - $WAS_USER_NAME -c "$WAS_HOME/bin/startServer.sh server1"
if [ $? -ne 0 ]
then
echo "WebSphere Server failed to start"
exit 1
fi

echo "Apps deployed and WebSphere Server restarted"
exit 0

