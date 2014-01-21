
def SetThreadPoolProperties(appserver,appnode):
        serverid = AdminConfig.getid("/Cell:" + cellName + "/Node:" + appnode + "/Server:" + appserver +"/")
#	print "serverid is ..." + serverid + "\n"
	orb = AdminConfig.list('ObjectRequestBroker', serverid)
        threadpoolList = AdminConfig.showAttribute(orb,'threadPool')
	threadpool= "(" + threadpoolList.split("(")[1]
        print "----------- set Thread Pool properties ---------------"
        threadpoolprops = "[[maximumSize " + properties.getProperty("threadpool.maximumSize")
        threadpoolprops = threadpoolprops + "]"
        threadpoolprops = threadpoolprops + " [minimumSize  " + properties.getProperty("threadpool.minimumSize")
        threadpoolprops = threadpoolprops + "]"
        threadpoolprops = threadpoolprops + " [inactivityTimeout  " + properties.getProperty("threadpool.inactivityTimeout")
        threadpoolprops = threadpoolprops + "]"
        threadpoolprops = threadpoolprops + " [isGrowable " + properties.getProperty("threadpool.isGrowable")
        threadpoolprops = threadpoolprops + "]]"
        print "threadpoolprops.... " + threadpoolprops + "\n"
        print "threadpool..." + threadpool +"\n"
        rc = AdminConfig.modify(threadpool,threadpoolprops)
        rc = AdminConfig.save()
        print "======== threadpool general settings changed ==============="

def SetWebContainerTPProperties(appserver,appnode):
	serverid = AdminConfig.getid("/Cell:" + cellName + "/Node:" + appnode + "/Server:" + appserver +"/")
	tpm_list = AdminConfig.list('ThreadPool', serverid)
	WebContainerTP = tpm_list.split("WebContainer")[1].split(')')[0] + ")"
	print "WebcontainerTP ID is " + WebContainerTP
	print "----------- set webcontainer Thread Pool properties ---------------"
        webthreadpoolprops = "[[maximumSize " + properties.getProperty("Webthreadpool.maximumSize")
        webthreadpoolprops = webthreadpoolprops + "]"
        webthreadpoolprops = webthreadpoolprops + " [minimumSize " + properties.getProperty("Webthreadpool.minimumSize")
        webthreadpoolprops = webthreadpoolprops + "]]"
        print "webthreadpoolprops.... " + webthreadpoolprops + "\n"
        rc = AdminConfig.modify(WebContainerTP,webthreadpoolprops)
        rc = AdminConfig.save()
        print "================= threadpool webcontainer pool settings changed ==============="

def SetGeneralProperties(appserver,appnode):
	serverid = AdminConfig.getid("/Cell:" + cellName + "/Node:" + appnode + "/Server:" + appserver +"/")
        orb = AdminConfig.list('ObjectRequestBroker', serverid)
	print "----------- set orb general properties ---------------"
	orbprops = "[[requestTimeout " + properties.getProperty("orb.requestTimeout")
	orbprops = orbprops + "]"
   	orbprops = orbprops + " [connectionCacheMaximum  " + properties.getProperty("orb.connectionCacheMaximum")
	orbprops = orbprops + "]" 
	orbprops = orbprops + " [connectionCacheMinimum  " + properties.getProperty("orb.connectionCacheMinimum")
        orbprops = orbprops + "]"
	orbprops = orbprops + " [locateRequestTimeout " + properties.getProperty("orb.locateRequestTimeout")
	orbprops = orbprops + "]"
        orbprops = orbprops + " [noLocalCopies " + properties.getProperty("orb.noLocalCopies")
	orbprops = orbprops + "]]"
	print "orbprops.... " + orbprops + "\n"
	print "orb..." + orb +"\n"
	rc = AdminConfig.modify( orb , orbprops )
    	rc = AdminConfig.save()
    	print "======== orb general settings changed ==============="

def AddCustomProperties(appserver,appnode):
	print "--------------- add custom properties ----------------"
	serverid = AdminConfig.getid("/Cell:" + cellName + "/Node:" + appnode + "/Server:" + appserver +"/")
	orb = AdminConfig.list('ObjectRequestBroker', serverid)
	print "---------------------- creating ORB custom properties ----------"
	for  propname in properties.keys():
        	if propname.find("orbcp.") == 0:
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
            		print "========== creating property: " + pname + ": " + pvalue + "==========="
            		rc = AdminConfig.create('Property', orb, profcmd)

	    		AdminConfig.save()


###################
# Main
######################33333

import sys
import java.util as util
import java.io as javaio
import os
import shutil


print "====== loading properties from directory: " +  "=========\n"
#load JVM Properties from properties file

propdir="/tmp/WASCommon"
if len(sys.argv) > 0:
  d=sys.argv[0]
  if os.path.exists(d):
    propdir=d

properties = util.Properties()
propertiesfis =javaio.FileInputStream(propdir + "/wascluster.properties")
properties.load(propertiesfis)


jvm = AdminConfig.list("JavaVirtualMachine").split("\n")

cell=AdminConfig.list('Cell')
cellName=AdminConfig.showAttribute(cell,'name')
print "cell name is " + cellName + "\n"

clusterID=AdminConfig.getid('/ServerCluster:/')
clusterList=AdminConfig.list('ClusterMember',clusterID)

servers=clusterList.split("\n")

print "Servers..", servers, "\n"

for serverID in servers:
	serverName=AdminConfig.showAttribute(serverID,'memberName')
	print "serverName....", serverName, "\n"
	nodeName=AdminConfig.showAttribute(serverID, 'nodeName')
	SetGeneralProperties(serverName,nodeName)
	AddCustomProperties(serverName,nodeName)
	SetThreadPoolProperties(serverName,nodeName)
	SetWebContainerTPProperties(serverName,nodeName)
	SetGeneralProperties("nodeagent",nodeName)
	AddCustomProperties("nodeagent",nodeName)
	SetThreadPoolProperties("nodeagent",nodeName)
# get the dmgr
print "adding ORB settings to dmgr node...."
dmgrserverList=AdminTask.listServers('[-serverType DEPLOYMENT_MANAGER ]')
AfterNodes=dmgrserverList.split("nodes/")[1]
dmgrnodeName=AfterNodes.split("/servers/")[0]
print "dmgrNodename is " + dmgrnodeName
dmgrserverName=AdminConfig.showAttribute(dmgrserverList,'name')
print "dmgrservename...", dmgrserverName, "\n"
SetGeneralProperties(dmgrserverName,dmgrnodeName)
AddCustomProperties(dmgrserverName,dmgrnodeName)
SetThreadPoolProperties(dmgrserverName,dmgrnodeName)

# set CSIv2 client to never
AdminTask.configureCSIInbound('[-messageLevelAuth Supported -supportedAuthMechList LTPA|BASICAUTH -clientCertAuth Never -transportLayer Required -sslConfiguration -enableIdentityAssertion false -statefulSession true -enableAttributePropagation true -trustedIdentities ]')
AdminConfig.save()

