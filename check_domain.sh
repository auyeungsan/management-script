#!/bin/bash
path='/home/infra/domain_check/'
filename="${path}gaming"
log_time=$(date +"%m-%d-%Y")
log_file="${path}domain_check_${log_time}.csv"

echo 'Start'
echo $log_file
echo 'check date,'$log_time >>$log_file
echo 'Domain name,Reuslt,network test result' >>$log_file

while read -r line
do
	domain="$line"
#	echo "Name read from file - $domain"
	result=`/usr/local/nagios/libexec/check_http -H $domain -e "200,301,302" -t 3 -N`
#	echo $result

	if [[ $result == *'CRITICAL'* ]]
	then
#		echo 'CRITICAL'
		curl_result=`${path}curl_check.sh ${domain}`
		echo "${domain},${result},${curl_result}" >>$log_file
	fi
	
done < "$filename"
echo 'Start send email...'
/usr/bin/printf "%b" "Domain daily check result\n\n  Please find attachment for detail" | /bin/mail -r "nagios@abc.com (domain Check result)" -s "Domain check result" -a "$log_file" san.auyeung@abc.com
echo 'Start remove log file'
/bin/rm -f $log_file
echo 'End'
