#!/bin/sh
. /etc/virtualimage.properties
#############################################################################
# Name: config-clm-distributeserver.sh
#	Authored: unknown
#
# Updated for SSE nonRoot: Kenneth Thomson (kenneth.thomson@uk.ibm.com)	
# Updated for WASCommon: Tanya Wolff
# If /tmp/WASCommon doesn't exist, then $WAS_USERNAME is available only
# during deployment. 
# If /tmp/WASCommon exists, we use WAS_USER_NAME and WAS_SCRIPTS_DIR
#	
#############################################################################

WAS_HOME=$WAS_PROFILE_ROOT
WAS_SCRIPTS_DIR=/tmp/WASCommon/WASScripts

echo "------------------------- Stop WAS --------------------"
# actual schell script will be run as nonRoot user
if [ ! -d "$WAS_SCRIPTS_DIR" ]; then
echo "This pattern is missing WASCommon. Exiting."
exit 1
fi
sh $WAS_SCRIPTS_DIR/StopSingleWAS.sh
if [ $? -ne 0 ]
then
echo "WebSphere Server failed to stop"
exit 1
fi
echo "WebSphere Server stopped"


echo "----------------------- Run repo tool commands -------------------"
# actual schell script will be run as nonRoot user
sh $SCRIPTS_DIR/CLMConfigScripts/RunRepotool_db2.sh
if [ $? -ne 0 ]
then
echo "RunRepotools failed to create tables"
exit 1
fi
echo "RunRepotools created tables"


echo "--------------------- restart WAS -----------"
# actual schell script will be run as nonRoot user
sh $WAS_SCRIPTS_DIR/StartSingleWAS.sh
if [ $? -ne 0 ]; then
  echo "WebSphere Server failed to start"
  exit 1
fi
echo "WebSphere Server started"


echo "------------------------- Install CLM application to WAS -----------------"
# actual schell script will be run as nonRoot user
sh $SCRIPTS_DIR/InstallCLMApp.sh
if [ $? -ne 0 ]
then
echo "ERROR: CLM application ($COMPONENT) failed to install to WAS"
exit 1
fi
echo "CLM application ($COMPONENT) installed to WAS"

echo "pause 60 seconds to wait for all applications to start..."
sleep 60


echo "--------------------- end of script  -----------"
