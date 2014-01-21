sestatus 
setenforce Permissive
pushd . 
cd /etc/selinux 
mv config config.orig 
popd 
cp config /etc/selinux 
sestatus 

chkconfig --levels 345 iptables off
chkconfig --list iptables
/etc/init.d/iptables stop
