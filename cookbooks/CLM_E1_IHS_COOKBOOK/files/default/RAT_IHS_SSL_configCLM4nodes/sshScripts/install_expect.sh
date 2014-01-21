#!/bin/bash
#********************************************************************************
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2013. All Rights Reserved.
#  
# U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
#********************************************************************************

# check if "expect" is installed, install if necessary
rpm -q expect
if [ $? != 0 ]
then
        echo -e "expect utility not installed, installing software now."
        yum -y install expect
else
        echo -e "expect utility is already installed."
fi

