
def AddCustomProperties(appserver,appnode):
	print "----- Add custom properties ----------------"
	serverid = AdminConfig.getid("/Cell:" + cellName + "/Node:" + appserverNodeName + "/Server:" + appserverName +"/")
	sm = AdminConfig.list('SessionManager',serverid)
	for  propname in properties.keys():
        	if propname.find("smcp.") == 0:
                	pname = propname[5:]
                	pvalue = properties.getProperty(propname)
            		profcmd = '[[validationExpression ""]'
            		profcmd = profcmd +  ' [name \"' + pname + '\"]'
            		profcmd = profcmd +  ' [description ""]'
            		profcmd = profcmd +  ' [value \"' + pvalue + '\"]'
            		profcmd = profcmd +  ' [required "false"]]'
            		print "== creating property:",pname,":",pvalue
            		rc = AdminConfig.create('Property', sm, profcmd)

	    		AdminConfig.save()

def SetAttributes(appserver,appnode):
	print "----------------- Set SessionManager attributes -----------------"
	serverid = AdminConfig.getid("/Cell:" + cellName + "/Node:" + appserverNodeName + "/Server:" + appserverName +"/")
	sm = AdminConfig.list('SessionManager',serverid)
	smprops = "[[enableCookies " +  properties.getProperty("sm.enableCookies")
	smprops = smprops + "]]"
	rc = AdminConfig.modify(sm,smprops)
	rc = AdminConfig.save()

############################
# Main
############################

import sys
import java.util as util
import java.io as javaio
import os
import shutil

propdir="/tmp/WASCommon"
if len(sys.argv) > 0:
  d=sys.argv[0]
  if os.path.exists(d):
    propdir=d

print "----- Load properties from directory: " + propdir + "\n"
#load JVM Properties from properties file

properties = util.Properties()
propertiesfis =javaio.FileInputStream(propdir + "/was.properties")
properties.load(propertiesfis)


sess = AdminConfig.list("JavaVirtualMachine").split("\n")

cell=AdminConfig.list('Cell')
cellName=AdminConfig.showAttribute(cell,'name')
print "== Cell name is",cellName

serverList=AdminTask.listServers('[-serverType APPLICATION_SERVER ]')
servers=serverList.split("\n")

for appserver in servers:
	appserverName=AdminConfig.showAttribute(appserver,'name')
	appserverNodeName=appserver.split("nodes/")[1].split("/servers/")[0]
	print "== AppServerName is",appserverName
	print "== AppServer node name is",appserverNodeName
	serverxml='(cells/' + cellName + '/nodes/' + appserverNodeName + '/servers/' + appserverName + '|server.xml)'
	sessionMgr=AdminConfig.list('SessionManager',serverxml)
	print "== SessionManager id is",sessionMgr
	AddCustomProperties(appserverName,appserverNodeName) 
	SetAttributes(appserverName,appserverNodeName) 
