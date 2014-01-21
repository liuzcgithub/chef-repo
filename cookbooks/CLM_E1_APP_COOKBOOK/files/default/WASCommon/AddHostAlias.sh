#!/bin/sh
. /etc/virtualimage.properties
echo $WAS_USER_NAME $WAS_PROFILE_ROOT $dmgrhost
echo "--------------------Add host aliases ----------------------------------"
su - $WAS_USER_NAME -c "$WAS_PROFILE_ROOT/bin/wsadmin.sh -lang jython -f /tmp/WASCommon/AddHostAlias.py $dmgrhost"

