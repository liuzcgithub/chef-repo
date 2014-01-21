#!/bin/sh
. /etc/virtualimage.properties

###################################################################
#	Authored: Jennifer Liu (yeliu@us.ibm.com)
#	Rational Core Team Automation
#	Installs CLM 4.0.x Bits via IM
#	Components allowed are "all", "jts", "ccm", "qm", "rrc"
###################################################################

echo "CLM Build to be installed: "$CLM_BUILD_ID

echo "Set correct ulimit"

chmod +rwx /tmp/CLM/testulimit.sh
cd /tmp/CLM
./testulimit.sh

echo "Substitute CLM Build ID"
CLMXML=/tmp/CLM/CLM.xml
cp CLM_template.xml $CLMXML
sed -i s%_CLM_REPO_WEBSERVER_%$CLM_Repo_Webserver% $CLMXML
sed -i s%_PRODUCT_%$CLM_Product% $CLMXML
sed -i s%_CLM_BUILD_STREAM_%$CLM_BUILD_STREAM% $CLMXML
sed -i s%_CLM_BUILD_TYPE_%$CLM_Build_Type% $CLMXML
sed -i s%_CLM_BUILD_ID_%$CLM_BUILD_ID% $CLMXML
sed -i s%_CLM_SUFFIX_%$CLM_Suffix% $CLMXML
echo "Component is set to $COMPONENT"
if [ $COMPONENT != all ]
then
	FromStrBG="!--_BG_"$COMPONENT"_"
	FromStrEND="_END_"$COMPONENT"_--"
	echo "FromStrBG is $FromStrBG"
	echo "FromStrEND is $FromStrEND"
	sed -i s#$FromStrBG##g $CLMXML
	sed -i s#$FromStrEND##g $CLMXML
else
	sed -i s#!--_BG_jts_##g $CLMXML
	sed -i s#_END_jts_--##g $CLMXML
	sed -i s#!--_BG_ccm_##g $CLMXML
        sed -i s#_END_ccm_--##g $CLMXML
	sed -i s#!--_BG_qm_##g $CLMXML
        sed -i s#_END_qm_--##g $CLMXML
	sed -i s#!--_BG_rrc_##g $CLMXML
        sed -i s#_END_rrc_--##g $CLMXML
fi
if [ $COMPONENT == jts ]
then
	DM_LIC_REPO_1="<repository location='http://jazzweb.beaverton.ibm.com/calm/main/I/" 
	DM_LIC_REPO_2="/jfs-product-rhapsody-dm-offering/offering-repo/'/>" 
	DM_LIC_OFFERING="<offering id='com.ibm.team.install.jfs.app.product-rhapsody-dm' profile='Collaborative Lifecycle Management' features='server.conf,server.provision,require.jts' installFixes='none'/>"
        sed -i s%^.*_DM_LIC_REPO_1_IF_JTS_%"$DM_LIC_REPO_1"%g $CLMXML
        sed -i s%_DM_LIC_REPO_2_IF_JTS_.*$%"$DM_LIC_REPO_2"%g $CLMXML
        sed -i s%^.*_DM_LIC_OFFERING_IF_JTS_.*$%"$DM_LIC_OFFERING"%g $CLMXML
fi
echo "Install CLM 4.x via Installation Manager"

cd /opt/IBM/InstallationManager/eclipse
./IBMIM --launcher.ini silent-install.ini -input $CLMXML -keyring /tmp/IM_Keyring/im.keyring -acceptLicense -accessRights admin

if [ $? -gt 0 ]
then
        echo "Error. CLM install failed"
        exit 1
fi


exit
