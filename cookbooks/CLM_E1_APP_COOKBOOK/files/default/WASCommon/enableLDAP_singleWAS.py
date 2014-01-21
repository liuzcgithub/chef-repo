########################################################
#
#       Authored: Jennifer Liu (yeliu@us.ibm.com)
#       Rational Core Team Automation
#       This script based on HongYan Huo (HongYan_huo@ca.ibm.com)'s scripts
#	1. Setup app server to run as clmadmin
#	2. Enable LDAP
#	Updated: Tanya Wolff (twolff@ca.ibm.com)
#	to set SSL when the properties file contains an SSL server 
#
########################################################
import java.util as util
import java.io as javaio
#load LDAP Properties from properties file
propertiesLDAP = util.Properties()
ldapfile="/tmp/WASCommon/LDAP/LDAPSecurity.properties"
propertiesLDAPfile = javaio.FileInputStream(ldapfile)
propertiesLDAP.load(propertiesLDAPfile)
print "args: ",sys.argv
# default ssl is false
ldapssl=0
if (len(sys.argv) > 0):
  ldapserver=sys.argv[0]
  ldapssl=("SSLEnabledTDS" == ldapserver)

if ldapssl:
  sslEnabledString = " -sslEnabled true"
else:
  sslEnabledString = " -sslEnabled false"

celllist = AdminConfig.list('Cell').split("\n")
if (len(celllist) == 1 ):
    cellname = AdminConfig.showAttribute(celllist[0], 'name')
    print "cell name is: " + cellname
else:
    print "this script works with single cell only"
    sys.exit() 

serverlist = AdminTask.listServers('[-serverType APPLICATION_SERVER ]').splitlines() 
if (len(serverlist) == 1 ):
    servername = AdminConfig.showAttribute(serverlist[0], 'name')
    print "server name is: " + servername
else:
    print "this script works with single server only. there are " + len(serverlist)
    sys.exit() 
print "====== end server info ===============\n"

stuffAfterNodes=serverlist[0].split("nodes/")[1]
nodename=stuffAfterNodes.split("/servers/")[0]
print "the nodename is " + nodename + "\n"

#print "------------- Set Run as Root User -------------------"
# Commenting out since we do not set RunAsRoot for running WAS as clmadmin
#runAsRootScope="(cells/" + cellname + "/nodes/" + nodename + "/servers/" + servername + "|server.xml#ProcessExecution_1183122130078)"
#AdminConfig.modify( runAsRootScope , '[[runAsUser "root"] [runAsGroup ""] [runInProcessGroup "0"] [processPriority "20"] [umask "022"]]')
#AdminConfig.save()

print "-------Configure LDAP General Properties-------"
#
# properties are in LDAPSecurity.properties
#
ldapGenProps = "[-ldapHost " + propertiesLDAP.getProperty("jazz_ldap_host") 
ldapGenProps = ldapGenProps + " -ldapPort " + propertiesLDAP.getProperty("jazz_ldap_port")
ldapGenProps = ldapGenProps + " -ldapServerType CUSTOM " 
ldapGenProps = ldapGenProps + " -baseDN " + propertiesLDAP.getProperty("jazz_ldap_baseDN") 
ldapGenProps = ldapGenProps + " -bindDN " + propertiesLDAP.getProperty("jazz_ldap_bindDN") 
ldapGenProps = ldapGenProps + " -bindPassword " + propertiesLDAP.getProperty("jazz_ldap_bindPassword")
ldapGenProps = ldapGenProps + " -searchTimeout 120 -reuseConnection false " + sslEnabledString + " -sslConfig -autoGenerateServerId true"
ldapGenProps = ldapGenProps + " -primaryAdminId " + propertiesLDAP.getProperty("jazz_ldap_primaryid") 
ldapGenProps = ldapGenProps + " -ignoreCase false -customProperties -verifyRegistry false]"
rc = AdminTask.configureAdminLDAPUserRegistry(ldapGenProps)
rc = AdminConfig.save()


print "-------Configure Perf LDAP Additional Properties-------"
ldapAddProps = "[-userFilter " + propertiesLDAP.getProperty("jazz_ldap_userFilter") 
ldapAddProps = ldapAddProps + " -groupFilter " + propertiesLDAP.getProperty("jazz_ldap_groupFilter")
ldapAddProps = ldapAddProps + " -userIdMap " + propertiesLDAP.getProperty("jazz_ldap_userIdMap")
ldapAddProps = ldapAddProps + " -groupIdMap " + propertiesLDAP.getProperty("jazz_ldap_groupIdMap")
ldapAddProps = ldapAddProps + " -groupMemberIdMap " + propertiesLDAP.getProperty("jazz_ldap_groupMemberIdMap")
ldapAddProps = ldapAddProps + " -certificateFilter -certificateMapMode EXACT_DN -krbUserFilter"
ldapAddProps = ldapAddProps + ' -customProperties ["com.ibm.websphere.security.ldap.recursiveSearch="] -verifyRegistry false'
ldapAddProps = ldapAddProps + "]"
rc = AdminTask.configureAdminLDAPUserRegistry(ldapAddProps)
rc = AdminConfig.save()

print "-------Set Realm Trust-------"
AdminTask.configureTrustedRealms('[-communicationType inbound -trustAllRealms false]')
AdminConfig.save()

print "-------Test LDAP Connection-------"
ldapConn = "[-type CUSTOM -hostname " + propertiesLDAP.getProperty("jazz_ldap_host")
ldapConn = ldapConn + " -port " + propertiesLDAP.getProperty("jazz_ldap_port")
ldapConn = ldapConn + " -baseDN " + propertiesLDAP.getProperty("jazz_ldap_baseDN")
ldapConn = ldapConn + " -bindDN " + propertiesLDAP.getProperty("jazz_ldap_bindDN")
ldapConn = ldapConn + " -bindPassword " + propertiesLDAP.getProperty("jazz_ldap_bindPassword")
ldapConn = ldapConn + sslEnabledString + "]"
rc = AdminTask.validateLDAPConnection(ldapConn)
rc = AdminConfig.save()
rc = AdminTask.configureAdminLDAPUserRegistry('[-verifyRegistry true ]')
rc = AdminConfig.save()

print "-------Set Security Current Settings-------"
AdminTask.setAdminActiveSecuritySettings('-enableGlobalSecurity true -cacheTimeout 600 -enforceJava2Security false -appSecurityEnabled true -activeUserRegistry LDAPUserRegistry -activeAuthMechanism LTPA')
rc = AdminConfig.save()

print "-------Save Registry as Current & Display Current Registry Settings-------"
#Saves Registry
print AdminTask.getUserRegistryInfo('[-userRegistryType LDAPUserRegistry]')
AdminConfig.save()

