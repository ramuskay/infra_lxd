#!/bin/bash
IFS=";"
PATHDNS="/etc/ansible/roles/install-bind/vars/main.yml"
PATHFILE="/root/lxc"
bool="false"
IP_DNS="240.204.0.10"
while read name ip type nfs;do
	#set -x
	lxc info $name > /dev/null 2>&1
	if [ $? -eq 0 ];then
		echo "Conteneur $name existe deja"
		continue
	fi
	res=$(dig -x $ip @${IP_DNS} +short)
	if [ "$res" != "" ] && [ "${name,,}.lief.loc." != "$res" ];then 
		echo "Ip $ip du conteneur $name dejà utilisé par $res"
		continue
	fi
	lxc init $type-t $name
	lxc network attach lxdfan0 $name eth0 eth0
	lxc config device set $name eth0 ipv4.address $ip
	lxc start $name
	if [ $type == "centos" ];then
		sleep 2
		$(lxc exec $name -- sed -i "\$a$ip ${name}.lief.loc $name" /etc/hosts < /dev/null)
		$(lxc exec $name -- hostnamectl set-hostname ${name}.lief.loc < /dev/null)
		echo "Finish ! "
	fi
	if [ "${name,,}.lief.loc." != "$res" ];then
		echo "      - {name: $name, ip: $ip}"| tr '[:upper:]' '[:lower:]' >> $PATHDNS
		bool="true"
	fi
	if [ ! -z "$nfs" ];then
		lxc config device add $name nfs disk source=/data/${nfs} path=/data > /dev/null
	fi
done < "$PATHFILE"
if [ "$bool" == "true" ];then
	cd /etc/ansible
	(nohup ansible-playbook playbook.yml --limit dns -t dns 2> /dev/null &) >/dev/null 2>&1
	cd - > /dev/null
fi

cd /etc/ansible
(nohup ansible-playbook playbook.yml -t common 2> /dev/null &) >/dev/null 2>&1
cd - > /dev/null
