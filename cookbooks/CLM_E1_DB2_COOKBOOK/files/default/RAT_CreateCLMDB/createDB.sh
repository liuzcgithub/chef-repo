#!/bin/sh
#********************************************************************************
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2013. All Rights Reserved.
#  
# U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
#********************************************************************************

#su - db2inst1 -c "sh /tmp/createtables.sh" > /tmp/createtables.log 2>&1
su - db2inst1 -c "sh /tmp/createtables.sh"

/etc/init.d/iptables save
/etc/init.d/iptables stop
