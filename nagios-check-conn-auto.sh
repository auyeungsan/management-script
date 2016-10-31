#!/bin/bash
host_name[0]='aw-cw3-hp02'
host_lst[0]='52.77.3.184'

host_name[1]='aw-cw3-hp03'
host_lst[1]='52.76.141.145'

host_name[2]='az-cw3-hp01'
host_lst[2]='23.97.79.171'

host_name[3]='az-cw3-hp02'
host_lst[3]='23.102.232.15'

host_name[4]='rs-cw3-hp02'
host_lst[4]='119.9.107.150'

host_name[5]='rs-cw3-hp03'
host_lst[5]='119.9.95.121'

host_name[6]='aw-cw3-hp04'
host_lst[6]='52.220.15.36'

host_name[7]='xb-cw3-hp07'
host_lst[7]='122.128.109.247'
host_name[8]='xb-cw3-hp08'
host_lst[8]='122.128.109.248'

host_name[9]='xb-cw3-hp09'
host_lst[9]='122.128.109.14'

host_name[10]='xb-cw3-hp10'
host_lst[10]='122.128.109.230'

host_name[11]='xb-cw3-hp11'
host_lst[11]='122.128.109.213'

host_name[12]='aw-cb3-hp01'
host_lst[12]='54.255.140.225'

host_name[13]='rs-cb3-hp01'
host_lst[13]='119.9.105.105'

host_name[14]='aw-cb3-hp02'
host_lst[14]='52.220.39.195'

count=${#host_lst[@]}
reboot_count='0'

for ((n=0; n<$count; n++))
do
	if [ ! -f /usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg ] 
	then
		touch /usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg
		reboot_count='1'
	fi


	host_find=`grep ${host_name[$n]}_connection_check.cfg /usr/local/nagios/etc/nagios.cfg`
	
	if [ -z "$host_find" ]
	then
		echo "cfg_file=/usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg">>/usr/local/nagios/etc/nagios.cfg
		reboot_count='1'
	fi


	domainlist=`/usr/local/nagios/libexec/check_ncpa.py -H ${host_lst[$n]} -t Asdqwe123 -M 'agent/plugin/domain_discovery.sh'`

#	echo $domainlist

	array=($domainlist)

	length=${#array[@]}

#	echo $length

	
	for ((i=0; i<$length; i++))
	do
		find=`grep ${array[$i]} /usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg`
		if [ -z "$find" ]
		then
			echo "define service{" >>/usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg
			echo "		host_name		${host_name[$n]} ">>/usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg
			echo "		service_description	check  ${array[$i]} connection">>/usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg
			echo "		check_command		check_ncpa_remote!'agent/plugin/check_haproxy_conn.sh'!'${array[$i]}' ">>/usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg
			echo "		max_check_attempts      5">>/usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg
			echo "		normal_check_interval   1">>/usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg
			echo "		retry_check_interval    3">>/usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg
			echo "		check_period            24x7">>/usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg
			echo "		notification_interval   30">>/usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg
			echo "		notification_period     24x7">>/usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg
			echo "		notification_options    w,c,r">>/usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg
			echo "		contact_groups          infra">>/usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg
			echo "}">>/usr/local/nagios/etc/objects/service/${host_name[$n]}_connection_check.cfg
			reboot_count='1'
		fi
#		echo 'find :' $find
#		echo 'array :' ${array[$i]}
	done
	
	
done

#echo $reboot_count
#reboot_count='1'

if [ $reboot_count -eq 1 ]
then
   service nagios reload
fi 
