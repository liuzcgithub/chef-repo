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

WASCOMMON=/tmp/WASCommon
echo "WASCOMMON=$WASCOMMON"
echo "WAS_PROFILE_ROOT=$WAS_PROFILE_ROOT"
echo "WAS_USER_NAME=$WAS_USER_NAME"


SSLClientFile=$WAS_PROFILE_ROOT/properties/ssl.client.props

echo "make a copy of ssl.client.props"
cp $SSLClientFile ${SSLClientFile}_bak

sed -i s%com.ibm.security.useFIPS=false%com.ibm.security.useFIPS=true% $SSLClientFile
echo "com.ibm.websphere.security.FIPSLevel=SP800-131" >> $SSLClientFile
sed -i s%com.ibm.ssl.protocol=SSL_TLS%com.ibm.ssl.protocol=TLSv1.2% $SSLClientFile

echo "Set FIP properties for JVM"
su - $WAS_USER_NAME -c "$WAS_PROFILE_ROOT/bin/wsadmin.sh -lang jython -f $WASCOMMON/SetJvmFIPSProps.py $WASCOMMON $PROFILE_TYPE"
if [ $? -ne 0 ]
        then
        echo "WAS JVM FIPS settings NOT updated"
        exit 1
fi
