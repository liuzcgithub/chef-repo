
def AddCustomProperties(appserver,appnode):
	print "----- Add custom properties ----------------"
	serverid = AdminConfig.getid("/Cell:" + cellName + "/Node:" + appnode + "/Server:" + appserver +"/")
	pp = AdminConfig.list('PluginProperties',serverid)
	for  propname in properties.keys():
        	if propname.find("ppcp.") == 0:
                	pname = propname[5:]
                	pvalue = properties.getProperty(propname)
            		profcmd = '[[validationExpression ""]'
            		profcmd = profcmd +  ' [name \"' + pname + '\"]'
            		profcmd = profcmd +  ' [description ""]'
            		profcmd = profcmd +  ' [value \"' + pvalue + '\"]'
            		profcmd = profcmd +  ' [required "false"]]'
            		print "== creating property:",pname,":",pvalue
            		rc = AdminConfig.create('Property', pp, profcmd)

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
# 1. add custom properties in the webserver plugin properties
# 2. Delete CMS Keystore
# 3.
############################

import sys
import java.util as util
import java.io as javaio
import os
import shutil
import commands

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

appserverName=AdminConfig.showAttribute(servers[0],'name')
appserverNodeName=servers[0].split("nodes/")[1].split("/servers/")[0]
print "== AppServerName is",appserverName
print "== AppServer node name is",appserverNodeName


WebserverList=AdminTask.listServers('[-serverType WEB_SERVER ]')
WebserverName=AdminConfig.showAttribute(WebserverList,'name')
AfterNodes=WebserverList.split("nodes/")[1]
WebserverNodeName=AfterNodes.split("/servers/")[0]
print "WebServer node name is " + WebserverNodeName + "\n"
print "WebServerName is " + WebserverName + "\n"

AddCustomProperties(WebserverName,WebserverNodeName)

# Delete CMS keystore
command="[-keyStoreName CMSKeyStore -keyStoreScope (cell):" + cellName+":(node):" + WebserverNodeName + ":(server):" + WebserverName + " -certificateAlias default ]"
print "command is " + command
AdminTask.deleteCertificate(command)
AdminConfig.save()

print "Modify SSL Configuration to use TLSv1.2"
SSLConfigCmd="[-alias NodeDefaultSSLSettings -scopeName (cell):"
SSLConfigCmd= SSLConfigCmd + cellName + ":(node):" + appserverNodeName + " -keyStoreName NodeDefaultKeyStore -keyStoreScopeName (cell):"
SSLConfigCmd= SSLConfigCmd + cellName + ":(node):" + appserverNodeName + " -trustStoreName NodeDefaultTrustStore -trustStoreScopeName (cell):"
SSLConfigCmd= SSLConfigCmd + cellName + ":(node):" + appserverNodeName + " -jsseProvider IBMJSSE2 -sslProtocol TLSv1.2 -clientAuthentication false -clientAuthenticationSupported false -securityLevel HIGH -enabledCiphers ]"
print "SSLConfigCmd: " + SSLConfigCmd
AdminTask.modifySSLConfig(SSLConfigCmd)
AdminConfig.save()


print "Convert Security certificate"
AdminTask.convertCertForSecurityStandard('[-fipsLevel SP800-131 -signatureAlgorithm SHA256withRSA -keySize 2048 ]')
# Enable FIPS to Convert Certificate
#print "enable FIPS"
#AdminTask.enableFips('[-enableFips true -fipsLevel SP800-131 ]')
#print "Disable FIPS for retrieve signer from IHS host"
#AdminTask.enableFips('[-enableFips false ]')
#AdminConfig.save()

#commands.getoutput('/opt/IBM/WebSphere/Profiles/DefaultAppSrv01/bin/stopServer.sh server1')
#commands.getoutput('/opt/IBM/WebSphere/Profiles/DefaultAppSrv01/bin/startServer.sh server1')

#AdminTask.modifySSLConfig('[-alias NodeDefaultSSLSettings -scopeName (cell):CloudBurstCell_5:(node):CloudBurstNode_5 -keyStoreName NodeDefaultKeyStore -keyStoreScopeName (cell):CloudBurstCell_5:(node):CloudBurstNode_5 -trustStoreName NodeDefaultTrustStore -trustStoreScopeName (cell):CloudBurstCell_5:(node):CloudBurstNode_5 -jsseProvider IBMJSSE2 -sslProtocol TLSv1.2 -clientAuthentication false -clientAuthenticationSupported false -securityLevel HIGH -enabledCiphers ]')

#for appserver in servers:
#	appserverName=AdminConfig.showAttribute(appserver,'name')
#	appserverNodeName=appserver.split("nodes/")[1].split("/servers/")[0]
#	print "== AppServerName is",appserverName
#	print "== AppServer node name is",appserverNodeName
#	serverxml='(cells/' + cellName + '/nodes/' + appserverNodeName + '/servers/' + appserverName + '|server.xml)'
#	sessionMgr=AdminConfig.list('SessionManager',serverxml)
#	print "== SessionManager id is",sessionMgr
#	AddCustomProperties(appserverName,appserverNodeName) 
#	SetAttributes(appserverName,appserverNodeName) 
