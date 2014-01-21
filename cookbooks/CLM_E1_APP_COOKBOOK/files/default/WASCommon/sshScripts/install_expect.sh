#!/bin/bash


# check if "expect" is installed, install if necessary
rpm -q expect
if [ $? != 0 ]
then
        echo -e "expect utility not installed, installing software now."
        yum -y install expect
else
        echo -e "expect utility is already installed."
fi

