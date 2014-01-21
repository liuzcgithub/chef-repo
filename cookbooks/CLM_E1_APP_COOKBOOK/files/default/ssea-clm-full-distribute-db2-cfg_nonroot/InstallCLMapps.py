

###################################################

def deployJazzApp(app_name,nname,sname):

    print "====== installing " + app_name + " Web Application on WAS on " + nname + "server " + sname + "======\n"
    app_war= app_name + '.war'
    installed_appname = app_name + '_war'
    app_ctx = '/' + app_name
    appfile = "/opt/IBM/JazzTeamServer/server/webapps/" + app_war
    #appfile = properties.getProperty("CLM_HOME") + "/server/webapps/" + app_war
    #appfile = "/tmp/webapps/" + app_war
    installcmd = ""
    installcmd = installcmd + "["
    installcmd = installcmd + " -nopreCompileJSPs -distributeApp -nouseMetaDataFromBinary -nodeployejb"
    installcmd = installcmd + " -appname " + installed_appname
    installcmd = installcmd + " -createMBeansForResources -noreloadEnabled -nodeployws"
    installcmd = installcmd + " -validateinstall warn"
    installcmd = installcmd + " -noprocessEmbeddedConfig"
    installcmd = installcmd + " -filepermission .*\\.dll=755#.*\\.so=755#.*\\.a=755#.*\\.sl=755"
    installcmd = installcmd + " -noallowDispatchRemoteInclude -noallowServiceRemoteInclude"
    installcmd = installcmd + " -asyncRequestDispatchType DISABLED"
    installcmd = installcmd + " -nouseAutoLink"
    installcmd = installcmd + " -MapModulesToServers [[ " + app_war + " " + app_war + ",WEB-INF/web.xml"
    installcmd = installcmd + " WebSphere:cell=" + cellName + ",node=" + nname + ",server=" + sname  + "+WebSphere:cell=" + cellName + ",node=" + WebserverNodeName + ",server=" + WebserverName + " ]]"
    installcmd = installcmd + " -MapWebModToVH [[ " + app_war + " " + app_war + ",WEB-INF/web.xml default_host ]]"
    installcmd = installcmd + " -CtxRootForWebMod [[ " + app_war + " " + app_war + ",WEB-INF/web.xml " + app_ctx +" ]]"
    installcmd = installcmd + "]"

    #command doesn't like literal single quotes quoting actural parameters IN the variables

    rc = AdminApp.install(appfile, installcmd)
    AdminConfig.save()
    print "====== application " + app_name + " is installed on WAS =========\n"

    if (app_name in comp_JazzApps):
	if os.path.exists('/tmp/WASCommon'):
          mapRolesToJazzApp(installed_appname)
	else:
          oldmapRolesToJazzApp(installed_appname)

###################################################

# Function mapRolesToJazzApp(installed_appname)

###################################################

def oldmapRolesToJazzApp(installed_appname):
    print "====== mapping user roles and group roles to jazz ==============="
    userrealm = properties.getProperty("jazz.userrealm")
    userrole = properties.getProperty("jazz.userrole.primaryid")
    if len(userrole) == 0:
        userrole = "\'\'"
        userrealmstr = ""
    else:
        userrealmstr = " user:" + userrealm + "/"
	print "userrealm: ",userrealmstr
    for propname in properties.keys():
        if propname.find("jazz.grouprole.") == 0:
            editcmd = ""
            editcmd = editcmd + "["
            editcmd = editcmd + " -MapRolesToUsers ["
            editcmd = editcmd + "[ " + propname[15:] + " AppDeploymentOption.No AppDeploymentOption.No"
            editcmd = editcmd + " " + userrole
            editcmd = editcmd + " " + properties.getProperty(propname)
            editcmd = editcmd + " AppDeploymentOption.No"
            editcmd = editcmd + userrealmstr + userrole
            editcmd = editcmd + " group:" + userrealm + "/" + properties.getProperty(propname)
            editcmd = editcmd + "]"
            editcmd = editcmd + "]]"
            print "========== mapping role: " + propname[15:] + "========"
            rc = AdminApp.edit(installed_appname,editcmd)

    rc = AdminConfig.save()
def mapRolesToJazzApp(installed_appname):
    print "====== mapping user roles and group roles to jazz ==============="
    userrealm = properties.getProperty("jazz_userrealm")
    userrole = properties.getProperty("jazz_ldap_primaryid")
    if len(userrole) == 0:
        userrole = "\'\'"
        userrealmstr = ""
    else:
        userrealmstr = " user:" + userrealm + "/"
    print "userrealmstr: ",userrealmstr
    print "userrole: ",userrole
    for propname in properties.keys():
        #JazzGuests="cn\=RQMSVTJazzUsers,cn\=SVT,dc\=RPTSVT,dc\=domain"
        if propname.find("jazz_grouprole_") == 0:
            editcmd = ""
            editcmd = editcmd + "["
            editcmd = editcmd + " -MapRolesToUsers ["
            editcmd = editcmd + "[ " + propname[15:] + " AppDeploymentOption.No AppDeploymentOption.No"
            editcmd = editcmd + " " + userrole
            editcmd = editcmd + " " + properties.getProperty(propname)
            editcmd = editcmd + " AppDeploymentOption.No"
            editcmd = editcmd + userrealmstr + userrole
            editcmd = editcmd + " group:" + userrealm + "/" + properties.getProperty(propname)
            editcmd = editcmd + "]"
            editcmd = editcmd + "]]"
	    print "editcmd: ",editcmd
            print "========== mapping role: " + propname[15:] + "========"
            rc = AdminApp.edit(installed_appname,editcmd)

    rc = AdminConfig.save()

########################################333
# Start application
######################################3333
def startApp(installed_appname,nname,sname):
   print "start application " + installed_appname
   app_manager_cmd="cell=" + cellName + ",node=" + nname + ",type=ApplicationManager,process=" + sname + ",*"
   appManager = AdminControl.queryNames(app_manager_cmd)
   AdminControl.invoke(appManager,'startApplication',installed_appname)

   

####################
# main
############

import sys
import java.util as util
import java.io as javaio
import os
import shutil
import time

#load JVM Properties from properties file

properties = util.Properties()
propfile="/tmp/WASCommon/LDAP/LDAPSecurity.properties"
print "====== loading properties from ",propfile
ldappropsfis=javaio.FileInputStream(propfile)
properties.load(ldappropsfis)

cell=AdminConfig.list('Cell')
cellName=AdminConfig.showAttribute(cell,'name')
print "cell name is " + cellName + "\n"

serverList=AdminTask.listServers('[-serverType APPLICATION_SERVER ]')
servers=serverList.split("\n")
AfterAppNodes=serverList.split("nodes/")[1]
AppNodeName=AfterAppNodes.split("/servers/")[0]
print "AppNodeName is " + AppNodeName + "\n"


#appNames = ['clm', 'jts', 'ccm', 'qm', 'rm', 'admin', 'clmhelp', 'converter', 'dm', 'rdmhelp']
#appNames = ['jts', 'ccm', 'qm', 'rm', 'admin', 'clmhelp', 'converter']
#jts_appNames = ['jts','admin','clmhelp']
#ccm_appNames = ['ccm']
#qm_appNames = ['qm']
#rm_appNames = ['rm','converter']
comp_JazzApps = ['jts', 'ccm', 'qm', 'rm']

if (len(sys.argv) > 0):
    opt = sys.argv[0]
    if opt == 'jts':
      distribute_appNames=['jts','admin','clmhelp']
    elif (opt == 'ccm'):
      distribute_appNames=['ccm']
    elif (opt == 'qm'):
      distribute_appNames=['qm']
    elif (opt == 'rm'):
      distribute_appNames=['rm','converter']
    else:
      print "Invalid option " + opt
      sys.exit()      
      
else:
     print "Missing options eg jts"
     sys.exit()


WebserverList=AdminTask.listServers('[-serverType WEB_SERVER ]')
WebserverName=AdminConfig.showAttribute(WebserverList,'name')
AfterNodes=WebserverList.split("nodes/")[1]
WebserverNodeName=AfterNodes.split("/servers/")[0]
print "WebServer node name is " + WebserverNodeName + "\n"
print "WebServerName is " + WebserverName + "\n"

print "===== deploy jts application deployment ======\n"
for app_name in distribute_appNames:
   print app_name + "\n"
   deployJazzApp(app_name,AppNodeName,"server1")

print "============ sleep 30 seconds to wait all applications installed ===============\n"
time.sleep(30)

for app_name in distribute_appNames:
   app_name_war=app_name + "_war"
   print "starting application " + app_name_war
   startApp(app_name_war,AppNodeName,"server1")

