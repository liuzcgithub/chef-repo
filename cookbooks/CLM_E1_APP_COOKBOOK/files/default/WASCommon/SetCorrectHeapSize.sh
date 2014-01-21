#!/bin/sh
. /etc/virtualimage.properties
#PROPSFILE=$SCRIPTS_DIR/WASScripts/clmwas.properties
PROPSFILE=/tmp/WASCommon/was.properties

RAMSize=`ls -la /proc/kcore | awk '{print $5}' | tr -d ''`
echo "Ramsize is $RAMSize"
if [ $RAMSize -lt 4000 ]; then
	echo "The system RAM size is less than 4GB"
	sed -i s%HeapSize=4096%HeapSize=$RAMSize% $PROPSFILE
        sed -i s%"-Xmx4g -Xms4g"%"-Xmx2g -Xms2g"% $PROPSFILE
elif [ $RAMSize -lt 6000 ]; then
	echo "The system RAM size is 4gb, do nothing"
elif [ $RAMSize -lt 7500 ]; then
	 echo "The system RAM size is less than 7GB"
        sed -i s%HeapSize=4096%HeapSize=$RAMSize% $PROPSFILE
        sed -i s%"-Xmx4g -Xms4g"%"-Xmx6g -Xms6g"% $PROPSFILE
        sed -i s%-Xmn512m%-Xmn1g% $PROPSFILE

else 
	echo "The system RAM size is 8gb"
#  Keep defaults for cluster
	#sed -i s%HeapSize=4096%HeapSize=$RAMSize% $PROPSFILE
        #sed -i s%"-Xmx4g -Xms4g"%"-Xmx8g -Xms8g"% $PROPSFILE
        #sed -i s%-Xmn512m%-Xmn1g% $PROPSFILE
fi
