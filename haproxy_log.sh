#!/bin/bash
file_path=/var/log/
#file_path=/home/ouyangxin/haproxy_log/
tmp_path=/tmp/
log_folder=/ha_conn_count/
log_file='haproxy.log'
#log_file='haproxy.log.1'
file_date=$(date +"%b %e %H:%M" --date="1 mins ago") 
#file_date=$(date +"%b %d %T" --date="yesterday")
#file_date=$(date  +"%b %d %T")

#echo $file_path
#echo $tmp_path
#echo $log_file
#echo $file_date

#create folder at first run this script############################################
#if [ ! -d "$tmp_path$log_folder" ]; then
#  mkdir $tmp_path$log_folder 
#fi
###################################################################################


#grep "$file_date" $file_path$log_file > $tmp_path$log_file

#domain_list=(`awk -F "{" '{print $2}' $tmp_path$log_file | awk -F "}" '{print $1}'`)


#unique_domain=$(echo "${domain_list[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')



#for i in $unique_domain  # Note: No quotes
#do
 
#	if [ ! -f "$tmp_path$log_folder$1" ]; then
#		touch $tmp_path$log_folder$1
#	fi
  
	
  
#  echo `grep '$file_date' $file_path$log_file | grep $1 |wc -l` > $tmp_path$log_folder$1
grep "$file_date" $file_path$log_file | grep $1 |wc -l

#	echo "grep '$file_date' $file_path$log_file | grep $1 |wc -l > $tmp_path$log_folder$1"
  
  
#echo "grep $1 $tmp_path$log_file|wc -l > $tmp_path$log_folder$1"
  
#  echo "domain name: " "$i" 

#  echo "connection count: "`grep $i $tmp_path$log_file|wc -l`

 
#done


#for i in "${unique_domain[@]}"
#do
#	domain_name=($i)
#done


#echo ${domain_count[0]}
#echo ${domain_name[0]}

