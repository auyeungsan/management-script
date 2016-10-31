#/bin/bash

DownloadURL="http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country-CSV.zip"
tmpFolder="/tmp"
tmpZipName="$tmpFolder/GeoLite2-Country-CSV.zip"
GeoLite2="$tmpFolder/GeoLite2-Country-CSV_*"
GeoLite2CSV="$GeoLite2/GeoLite2-Country-Blocks-IPv4.csv"
HKID=1819730
HKblocklistPath="/etc/haproxy/HKblocklist.lst"
backupFolder="/etc/haproxy/HKblocklist-backup"
date=$(date +%Y%m%d)

checkUnzip(){
        dpkg -s unzip >/dev/null 2>&1
        if [ "$?" = 1 ];then
                apt-get -y install unzip
        fi
}

backupHKblocklist(){
        mkdir -p $backupFolder

        cp -rp $HKblocklistPath $backupFolder/HKblocklist.lst-$date

        if [ ! -s "$backupFolder/HKblocklist.lst-$date" ];then
                echo "Backup $HKblocklistPath failed."
                exit 2
        fi

        rm $HKblocklistPath
}

downloadZipFile(){
        wget $DownloadURL -O $tmpZipName
}

unZip(){
        unzip $tmpZipName -d $tmpFolder
}

UpdateIPList(){
        IPList=$(grep -P "^.*\/[0-9][0-9],$HKID," $GeoLite2CSV|cut -d ',' -f1)
        echo "$IPList" > $HKblocklistPath
}

CheckHKblocklist(){
        if [ -s "$HKblocklistPath" ];then
                echo "IP list imported to $HKblocklistPath ."
        else
                echo "IP list import failed."
        fi
}

removeTmp(){
        rm -r $tmpZipName $GeoLite2
}

reloadHAproxy(){
        service haproxy reload
}

main(){
        backupHKblocklist
        checkUnzip
        downloadZipFile
        unZip
        UpdateIPList
        CheckHKblocklist
        removeTmp
        reloadHAproxy
}

main
