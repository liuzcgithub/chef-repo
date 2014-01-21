#!/bin/sh

. /etc/virtualimage.properties
#Extract cert
export WAS_HOME=$WAS_PROFILE_ROOT

echo "---------------Extracting cert from server root-------------------------"
su -c "WAS_HOME=$WAS_PROFILE_ROOT $WAS_HOME/bin/wsadmin.sh -lang jython -f /tmp/Extract_Cert/Extract_server1_Cert.py" -- $WAS_USER_NAME 


