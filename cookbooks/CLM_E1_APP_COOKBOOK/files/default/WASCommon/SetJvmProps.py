#####################################################################
#
# Function SetHeapSize
#
#####################################################################
def SetHeapSize(appserver,appnode):
	print "----- set heap size ---------------"
	jvmprops = "[-serverName " + appserver + " -nodeName " + appnode
	jvmprops = jvmprops + " -initialHeapSize " + properties.getProperty("jvm.initialHeapSize")
   	jvmprops = jvmprops + " -maximumHeapSize " + properties.getProperty("jvm.maximumHeapSize") 
	jvmprops = jvmprops + " -genericJvmArguments " + properties.getProperty("jvm.genericJvmArguments")
	jvmprops = jvmprops + "]"
	rc = AdminTask.setJVMProperties(jvmprops)
    	rc = AdminConfig.save()

#####################################################################
#
# Function Add Custom Properties
#
#####################################################################
def AddCustomProperties(appserver,appnode):
	print "----- add custom properties ----------------"
	serverid = AdminConfig.getid("/Cell:" + cellName + "/Node:" + nodeName + "/Server:" + appserver +"/")
	jvm = AdminConfig.list('JavaVirtualMachine', serverid)
	print "----- creating jvm custom properties ----------"
	for  propname in properties.keys():
        	if propname.find("jvmcp.") == 0:
            		if propname.find(".file.") == 5:
                		#file url properties
                		pname = propname[11:]
                		pvalue = "file:///" + properties.getProperty("CLM_HOME") + "/" + properties.getProperty(propname)
            		else:
                		pname = propname[6:]
                		pvalue = properties.getProperty(propname)
            		profcmd = '[[validationExpression ""]'
            		profcmd = profcmd +  ' [name \"' + pname + '\"]'
            		profcmd = profcmd +  ' [description ""]'
            		profcmd = profcmd +  ' [value \"' + pvalue + '\"]'
            		profcmd = profcmd +  ' [required "false"]]'
            		print "----- creating property",pname,": ",pvalue
            		rc = AdminConfig.create('Property', jvm, profcmd)

	    		AdminConfig.save()


#####################################################################
#
# Main
#
#####################################################################
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
if (len(sys.argv) > 1):
  print "PROFILE_TYPE =", sys.argv[1]
  PROFILE_TYPE = sys.argv[1]

#load JVM Properties from properties file
#propdir=os.getenv('SCRIPTS_DIR')+'/WASScripts'
print "----- loading properties from directory: " + propdir

properties = util.Properties()
propertiesfis =javaio.FileInputStream(propdir + '/was.properties')
properties.load(propertiesfis)


jvm = AdminConfig.list("JavaVirtualMachine").split("\n")

cell=AdminConfig.list('Cell')
cellName=AdminConfig.showAttribute(cell,'name')
print "----- cell name is " + cellName + "\n"
# for cluster
# if cluster
if PROFILE_TYPE == "dmgr":

	clusterID=AdminConfig.getid('/ServerCluster:/')
	clusterList=AdminConfig.list('ClusterMember',clusterID)

	servers=clusterList.split("\n")

	print "----- Servers ...", servers, "\n"

	for serverID in servers:
		serverName=AdminConfig.showAttribute(serverID,'memberName')
		print "----- serverName is ", serverName, "\n"
		nodeName=AdminConfig.showAttribute(serverID, 'nodeName')
		print "----- nodeName is ", nodeName
		SetHeapSize(serverName,nodeName)
		AddCustomProperties(serverName,nodeName)
else: 
	# for non-cluster

	serverList=AdminTask.listServers('[-serverType APPLICATION_SERVER ]')

	print "----- serverlist ..." ,serverList, "\n"
	servers=serverList.split("\n")

	for serverID in servers:
		serverName=AdminConfig.showAttribute(serverID,'name')
		print "----- Servername is ", serverName, "\n"
		stuffAfterNodes=serverID.split("nodes/")[1]
		nodeName=stuffAfterNodes.split("/servers/")[0]
		SetHeapSize(serverName,nodeName)
		AddCustomProperties(serverName,nodeName)  
