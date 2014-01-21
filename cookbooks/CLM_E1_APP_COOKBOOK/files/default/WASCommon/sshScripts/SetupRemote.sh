#!/bin/sh

. /etc/virtualimage.properties
#############################################
#       Authored: Jennifer Liu (yeliu@us.ibm.com)
#       Rational Core Team Automation
#
#       This script will install expect and setup ssh between dmgr and custom nodes
#Note: it hardcode for the Root password install directory
###########################################
SCRIPTS_DIR=/tmp/WASCommon
ROOT_PASSWORD=aut0mat10n
DMGR=$1
APP1=$2
APP2=$3

echo "Server node variables from parameter pass"
echo "DMGR node: $DMGR" 
echo "APP1 node: $APP1"
echo "APP2 node: $APP2"

echo " "
echo "Server node variables from virtualimage.properties"
echo "DMGR node: $dmgrhost"
echo "APP1 node: $appnode1"
echo "APP2 node: $appnode2"


echo "Installing expect if it is not find on the system"
$SCRIPTS_DIR/sshScripts/install_expect.sh

echo "set up ssh on dmgr machines..."
$SCRIPTS_DIR/sshScripts/setupSSH -p $ROOT_PASSWORD root@$appnode1
$SCRIPTS_DIR/sshScripts/setupSSH -p $ROOT_PASSWORD root@$appnode2

echo "copy setup ssh and install expect scripts for other nodes ...."
scp $SCRIPTS_DIR/sshScripts/install_expect.sh root@$appnode1:/tmp
scp $SCRIPTS_DIR/sshScripts/install_expect.sh root@$appnode2:/tmp

scp $SCRIPTS_DIR/sshScripts/setupSSH root@$appnode1:/tmp
scp $SCRIPTS_DIR/sshScripts/setupSSH root@$appnode2:/tmp

echo "executing setupSSH from appnode2 to appnode1"
ssh root@$appnode2 "/tmp/install_expect.sh"
ssh root@$appnode2 "/tmp/setupSSH -p $ROOT_PASSWORD root@$appnode1"



