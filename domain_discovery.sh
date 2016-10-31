for domains in `cat /var/log/haproxy.log |egrep 'HTTP/1.1" 200'|awk '{print$7}'|egrep "www."|sed 's/[\"|\{|\}]//g'|sed 's/\:.*//g'|sort|uniq`;do
        domainlist="$domainlist,\n"'\t\t{\n\t\t\t"{#DOMAIN_NAME}":'\""$domains"\"'}'
done
echo '{\n\t"data":[\n'${domainlist#,}']}'
