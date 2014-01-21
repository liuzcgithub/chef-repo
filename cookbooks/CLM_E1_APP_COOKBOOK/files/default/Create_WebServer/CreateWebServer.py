import java.util as util
import java.io as javaio
import os
#load LDAP Properties from properties file
propertiesLDAP = util.Properties()
if os.path.exists("/tmp/WASCommon"):
  ldapfile="/tmp/WASCommon/LDAP/LDAPSecurity.properties"
else:
  ldapfile="/tmp/LDAP/LDAPSecurity.properties"
propertiesLDAPfile = javaio.FileInputStream(ldapfile)
propertiesLDAP.load(propertiesLDAPfile)
adminId=propertiesLDAP.getProperty("jazz_ldap_primaryid")
adminPw=propertiesLDAP.getProperty("jazz_ldap_primaryid_Password")
ihshost=os.environ['ihshost']
WebserverName=os.environ['WebserverName']

settings = "[-webserverName " + WebserverName 
settings = settings + " -templateName IHS -webPort 80 -serviceName "
settings = settings + " -webInstallRoot /opt/IBM/HTTPServer -webProtocol HTTP "
settings = settings + " -configurationFile -errorLogfile -accessLogfile "
settings = settings + " -pluginInstallRoot /opt/IBM/Plugins -webAppMapping ALL "
settings = settings + " -hostName " + ihshost 
settings = settings + " -platform linux -adminPort 8008 "
settings = settings + " -adminUserID " + adminId + " -adminPasswd " + adminPw
settings = settings + " -adminProtocol HTTP]"
rc = AdminTask.createWebServerByHostName(settings)
rc = AdminConfig.save()
#rc = AdminTask.createWebServerByHostName('[-webserverName $WebserverName -templateName IHS -webPort 80 -serviceName -webInstallRoot /opt/IBM/HTTPServer -webProtocol HTTP -configurationFile -errorLogfile -accessLogfile -pluginInstallRoot /opt/IBM/Plugins -webAppMapping ALL -hostName $ihshost -platform linux -adminPort 8008 -adminUserID $WAS_USERNAME -adminPasswd $WAS_PASSWORD -adminProtocol HTTP]')
