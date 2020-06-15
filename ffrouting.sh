#!/usr/bin/bash
# -*- ENCODING: UTF-8 -*-
#
clear
#
echo -e "\n ##################### Personalizando CentOS #################### \n"
sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config
sleep 1
echo "export LANG="en_US"" >> .bash_profile
systemctl stop firewalld && systemctl disable firewalld
# 
sleep 1s
echo -e "\n ##################### Actualianzando el Sistema #################### \n"
echo "dnf update -y"
#
sleep 2s
#
echo -e "\n ##################### Instalando Programas Basicos #################### \n"
#
dnf install wget git telnet traceroute bind-utils net-tools  bash-completion -y
#
sleep 1s
#
systemctl stop systemd-resolved && systemctl disable systemd-resolved && systemctl mask systemd-resolved
#
echo -e "\n ##################### Instalando FRRouting #################### \n"
dnf install --enablerepo=PowerTools git autoconf pcre-devel automake libtool make readline-devel texinfo net-snmp-devel pkgconfig groff pkgconfig json-c-devel pam-devel bison flex c-ares-devel python36 python36-devel python3-pytest systemd-devel libcap-devel gcc-c++ patch sphinx -y

sleep 1s
dnf install https://ci1.netdef.org/artifact/LIBYANG-YANGRELEASE/shared/build-10/CentOS-7-x86_64-Packages/libyang-0.16.111-0.x86_64.rpm -y && dnf install https://ci1.netdef.org/artifact/LIBYANG-YANGRELEASE/shared/build-10/CentOS-7-x86_64-Packages/libyang-devel-0.16.111-0.x86_64.rpm -y
#
groupadd -g 92 frr && groupadd -r -g 85 frrvty && useradd -u 92 -g 92 -M -r -G frrvty -s /sbin/nologin -c "FRR FRRouting suite" -d /var/run/frr frr
#
sleep 1s
git clone https://github.com/FRRouting/frr.git && cd frr && ./bootstrap.sh && ./configure --prefix=/usr --includedir=\${prefix}/include --bindir=\${prefix}/bin --sbindir=\${prefix}/lib/frr --libdir=\${prefix}/lib/frr --libexecdir=\${prefix}/lib/frr -localstatedir=/var/run/frr --sysconfdir=/etc/frr --enable-exampledir=\${sysconfdir}/examples --with-moduledir=\${prefix}/lib/frr/modules --enable-configfile-mask=0640 --enable-logfile-mask=0640 --enable-snmp=agentx --enable-systemd=yes --enable-vty-group=frrvty --disable-ripd --disable-ripngd --disable-ospfd --disable-ospf6d --disable-ldpd --disable-nhrpd --disable-eigrpd --disable-babeld --disable-pimd --disable-vrrpd --disable-pbrd --enable-sharpd --disable-bgp-vnc --disable-ospfapi --disable-ospfclient --disable-isisd --disable-irdp --disable-fabricd --enable-datacenter=no && make && make install
#
sleep 1s
install -p -m 644 tools/etc/frr/daemons /etc/frr/ && chown frr:frr /etc/frr/daemons && install -p -m 644 tools/frr.service /usr/lib/systemd/system/frr.service
#
sleep 1s
cp /etc/frr/examples/vtysh.conf.sample /etc/frr/vtysh.conf && chown frr:frr /etc/frr/vtysh.conf
#
sleep 1s
#
systemctl daemon-reload && systemctl enable frr.service 
#
sleep 1s
#
sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons && sed -i 's/bfdd=no/bfdd=yes/g' /etc/frr/daemons
sleep 1s
systemctl start frr.service && systemctl enable frr.service



