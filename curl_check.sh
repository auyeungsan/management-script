#!/bin/bash

domain=$1
#log_date=$(date +'%Y-%m-%d %H:%M:%S')
#log_path="/var/log/curl_log/$domain"
format_file='/usr/local/nagios/libexec/curl-format.txt'

#echo "check date: $log_date" >> $log_path
#com="/usr/bin/curl -w "@$format_file" -o /dev/null -s $domain"
result=$(/usr/bin/curl -w "@$format_file" -o /dev/null -s "$domain")
#echo $result
total_time=$(/bin/echo $result |awk -F ':' '{print $8}')
#total_time='100'
#echo $total_time
#echo ${total_time%.*}

#test='0'

#if [ $test -lt 3 ]
# then
#	echo "OK - $domain connection is $total_time."
#	exit 0
#elif [[ $test -ge 3 && $test -lt 8 ]]
# then
#	echo "WARNING - $domain connection is $total_time."
#	exit 1
#elif [ $test -ge 8 ]
# then
#	echo "CRITICAL - $domain connection is $total_time."
#	exit 2
#else
#	echo "UNKNOWN - $domain connection is $total_time."
#	exit 3
#fi


if [ ${total_time%.*} -lt 8 ]
 then
        echo "OK - $domain connection is $total_time."
        exit 0
elif [[ ${total_time%.*} -ge 8 && ${total_time%.*} -lt 10 ]]
 then
        echo "WARNING - $domain connection is $total_time."
        /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: PROBLEM\n\nService: CURL-check\nAddress: $domain\n\nTest result: $result\n" | /bin/mail -r "nagios@lazybugstudio.com (nagios Check)" -s "** CURL Check Alert: $domain is WARNING **" san.auyeung@lazybugstudio.com	
        exit 1
elif [ ${total_time%.*} -ge 10 ]
 then
        echo "CRITICAL - $domain connection is $total_time."
	/usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: PROBLEM\n\nService: CURL-check\nAddress: $domain\n\nTest result: $result\n" | /bin/mail -r "nagios@lazybugstudio.com (nagios Check)" -s "** CURL Check Alert: $domain is CRITICAL **" san.auyeung@lazybugstudio.com
        exit 2
else
        echo "UNKNOWN - $domain connection is $total_time."
    	# /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: PROBLEM\n\nService: CURL-check\nAddress: $domain\n\ncommand: $com\nTest result: $result\n" | /bin/mail -r "nagios@lazybugstudio.com (nagios Check)" -s "** PORBLEM Service Alert: $domain/Curl-check is CRITICAL **" san.auyeung@lazybugstudio.com
	exit 3
fi

