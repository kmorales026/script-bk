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
dnf update -y
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
dnf install epel-release -y && dnf install -y 'dnf-command(config-manager)' && dnf config-manager --set-enabled PowerTools && curl -o /etc/yum.repos.d/powerdns-auth-43.repo https://repo.powerdns.com/repo-files/centos-auth-43.repo && dnf install -y wget pdns pdns-backend-mysql

sleep 1s
chmod 640 /etc/pdns/pdns.conf && chown root:pdns /etc/pdns/pdns.conf && mkdir /etc/pdns/pdns.d && chmod 755 /etc/pdns/pdns.d  && touch /etc/pdns/pdns.d/gmysql.conf && chmod 644 /etc/pdns/pdns.d/*

sleep 1s

dnf install -y mariadb-server mariadb-server-galera galera rsync bind-utils

