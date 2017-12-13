#/bin/bash
app_url='https://fastly.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.6p1.tar.gz'
app='openssh-7.6p1'
ziptype='.tar.gz'
cd /usr/src
wget $app_url
tar -xvzf ${app}${ziptype}
yum install -y rpm-build gcc make wget openssl-devel krb5-devel pam-devel libX11-devel xmkmf libXt-devel
mkdir -p /root/rpmbuild/{SOURCES,SPECS}
cp ./$app/contrib/redhat/openssh.spec /root/rpmbuild/SPECS/
cp ${app}${ziptype} /root/rpmbuild/SOURCES/
cd /root/rpmbuild/SPECS/
sed -i -e "s/%define no_gnome_askpass 0/%define no_gnome_askpass 1/g" openssh.spec
sed -i -e "s/%define no_x11_askpass 0/%define no_x11_askpass 1/g" openssh.spec
sed -i -e "s/BuildPreReq/BuildRequires/g" openssh.spec
rpmbuild -bb openssh.spec
cd /root/rpmbuild/RPMS/x86_64/
rpm -Uvh *.rpm
rpm -qa | grep openssh