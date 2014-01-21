#!/bin/bash
# This script works around an apparent bug with the WAS8 VI by 
# forcing the load of GUI components required to run the IM in
# GUI mode.


echo "Changing directory to /opt/IBM/InstallationManager/eclipse"
cd /opt/IBM/InstallationManager/eclipse

echo "Substitute Admin for nonAdmin to allow root to run GUI"
sed -i 's/nonAdmin/admin/' IBMIM.ini
sed -i 's/nonAdmin/admin/' launcher.ini
sed -i 's/nonAdmin/admin/' silent-install.ini
sed -i 's/nonAdmin/admin/' /home/$WAS_USERNAME/var/ibm/InstallationManager/installRegistry.xml


echo "Done."
