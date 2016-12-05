#!/bin/bash

DownloadURL='http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz'
tmpFolder="/tmp"
tmpZipName="$tmpFolder/GeoIP.dat.gz"
geoipfile="$tmpFolder/GeoIP.dat"
HKblocklistPath="/etc/nginx/GeoIP.dat"
backupFolder="/etc/nginx/geoip-backup"
date=$(date +%Y%m%d)

backupHKblocklist(){
        mkdir -p $backupFolder

        cp -rp $HKblocklistPath $backupFolder/GeoIP.dat-$date

        if [ ! -s "$backupFolder/GeoIP.dat-$date" ];then
                echo "Backup $HKblocklistPath failed."
                exit 2
        fi

        rm $HKblocklistPath
}

downloadZipFile(){
        wget $DownloadURL -O $tmpZipName
}

unZip(){
        gunzip $tmpZipName
}

UpdateIPList(){
	cp -f $geoipfile $HKblocklistPath
}

CheckHKblocklist(){
        if [ -s "$HKblocklistPath" ];then
                echo "GEOIP was updated: $HKblocklistPath ."
        else
                echo "GEOip update failed."
        fi
}

removeTmp(){
        rm -r $geoipfile
}

reloadNginx(){
        service nginx reload
}

main(){
        if [ -f $HKblocklistPath ]
        then
                backupHKblocklist
        fi
#        checkUnzip
        downloadZipFile
        unZip
        UpdateIPList
        CheckHKblocklist
        removeTmp
        reloadNginx
}

main
