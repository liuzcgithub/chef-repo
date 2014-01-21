#!/bin/sh
#********************************************************************************
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2013. All Rights Reserved.
#  
# U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
#********************************************************************************

DBName=$1
DBHome=$2
db2 CREATE DATABASE jtsDB AUTOMATIC STORAGE YES ON '/db2fs' DBPATH ON '/db2fs' USING CODESET UTF-8 TERRITORY US COLLATE USING SYSTEM PAGESIZE 16384

db2 CREATE DATABASE ccmDB AUTOMATIC STORAGE YES ON '/db2fs' DBPATH ON '/db2fs' USING CODESET UTF-8 TERRITORY US COLLATE USING SYSTEM PAGESIZE 16384

db2 CREATE DATABASE qmDB AUTOMATIC STORAGE YES ON '/db2fs' DBPATH ON '/db2fs' USING CODESET UTF-8 TERRITORY US COLLATE USING SYSTEM PAGESIZE 16384

db2 CREATE DATABASE dwDB AUTOMATIC STORAGE YES ON '/db2fs' DBPATH ON '/db2fs' USING CODESET UTF-8 TERRITORY US COLLATE USING SYSTEM PAGESIZE 16384

