###############################################################################
#author: yeliu@us.ibm.com
#
#USAGE (linux): cd $WAS_HOME/bin
#       wsadmin -lang jython -f /opt/RAT_Cluster_PostConfig/AddHostAlias.py <dmgr_host_long_name> <Cell name>
# Deployment parameters
# <dmgr_host_long_name> - deployment manager host name 
# <cell name> - the dmgr cell name
###############################################################################



dmgr_host=sys.argv[0]

#AdminConfig.create('HostAlias', AdminConfig.getid('/Cell:CloudBurstCell_1/VirtualHost:default_host/'), '[[hostname "fit-vm6-025.rtp.raleigh.ibm.com"] [port "1025"]]') 

cell=AdminConfig.list('Cell')
cellName=AdminConfig.showAttribute(cell,'name')

ObjId_cmd="/Cell:" + cellName + "/VirtualHost:default_host/"
ObjId=AdminConfig.getid(ObjId_cmd)

AddHostAlias_cmd="[[hostname \"" + dmgr_host + "\"] [port \"1025\"]]"
AdminConfig.create('HostAlias', ObjId, AddHostAlias_cmd)

AdminConfig.save()

