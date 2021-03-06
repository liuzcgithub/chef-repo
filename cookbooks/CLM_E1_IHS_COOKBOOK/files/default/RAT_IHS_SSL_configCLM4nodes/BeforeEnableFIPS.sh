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


stopcount=$NUMBER_OF_CUSTOM_NODES
for (( i=0; i<$stopcount; i++ ))
do
        c_host_var=appnode$i
        eval c_host=\$$c_host_var
	echo "Prepare $c_host for certificate conversion"
	echo "------------------------------------"
	ssh root@$c_host sh /tmp/WASCommon/BeforeConvertCert.sh
done

