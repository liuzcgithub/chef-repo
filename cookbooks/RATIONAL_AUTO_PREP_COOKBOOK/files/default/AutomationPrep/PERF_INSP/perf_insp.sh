#!/bin/sh
. /etc/virtualimage.properties
PERFDIR=/tmp/AutomationPrep/PERF_INSP
touch $PERFDIR/install_drv.log

cd $PERFDIR
unzip -o $PERFDIR/PI_Linux_1.1.zip
chmod -R 777 Dpiperf
dos2unix Dpiperf/*

echo "===== Installing utils via yum"
yum install -y binutils
yum install -y binutils-devel
yum install -y glibc-devel.i686

export PATH=$WAS_INSTALL_ROOT/java/bin:$PATH
export PATH=$WAS_INSTALL_ROOT/java/jre/bin:$PATH

echo "===== Installing Performance Inspector"
cd $PERFDIR/Dpiperf
./tinstall.appl.int > $PERFDIR/install_appl.log 2>&1
./tinstall.drv > $PERFDIR/install_drv.log 2>&1

RESULT=`grep "Performance Inspector driver set up complete" $PERFDIR/install_drv.log`
if [ "$RESULT" == "" ]; then
echo "===== Performance inspector not installed. Check $PERFDIR/install_drv.log"
exit 1
fi
echo "===== Performance inspector driver  set up complete."
