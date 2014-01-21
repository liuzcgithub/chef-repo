########################################################
#
#       Authored: Jennifer Liu (yeliu@us.ibm.com)
#       Rational Core Team Automation
#
########################################################


cell=AdminConfig.list('Cell')
cellName=AdminConfig.showAttribute(cell,'name')
print "cell name is " + cellName + "\n"

serverList=AdminTask.listServers('[-serverType APPLICATION_SERVER ]')
AfterNodes=serverList.split("nodes/")[1]
NodeName=AfterNodes.split("/servers/")[0]
print "Nodename is " + NodeName

#CertPath="/tmp/dmgr-root.cer"
#AdminTask.extractCertificate('[-certificateFilePath ' + CertPath + ' -base64Encoded true -certificateAlias root -keyStoreName DmgrDefaultRootStore -keyStoreScope (cell):' + cellName + ':(node):' + dmgrNodeName + ' ]') 
CertPath="/tmp/serverroot.cer"
AdminTask.extractCertificate('[-certificateFilePath ' + CertPath + ' -base64Encoded true -certificateAlias root -keyStoreName NodeDefaultRootStore -keyStoreScope (cell):' + cellName + ':(node):' + NodeName +' ]') 
