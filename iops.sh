#!/bin/bash

# /usr/local/bin/dcli -l root -c cell1,cell2,cell3 cellcli -e list metriccurrent > /tmp/mcall.txt

mcfile='/tmp/mcall.txt'

line_cnt=`wc -l $mcfile | awk '{print $1}'`
while (( $line_cnt < 1000 ))
do
  sleep 1
  line_cnt=`wc -l $mcfile | awk '{print $1}'`
done


flash_io_pct() { 
   flash_pct_all=`cat $mcfile | egrep 'CD_IO_UTIL' |grep FD_ | grep -v _LG | grep -v _SM| sed 's/,//g'|awk 'BEGIN {w=0} {w=$4+w;} END {printf("%d\n",w);}'`
   flash_cnt=`cat $mcfile | egrep 'CD_IO_UTIL' | grep -v _LG | grep -v _SM| grep -c FD_`
   ((flash_pct = flash_pct_all/flash_cnt ))
   echo $flash_pct
}

disk_io_pct() { 
   disk_pct_all=`cat $mcfile | egrep 'CD_IO_UTIL' |grep -v FD_ | grep -v _LG | grep -v _SM| sed 's/,//g'|awk 'BEGIN {w=0} {w=$4+w;} END {printf("%d\n",w);}'`
   disk_cnt=`cat $mcfile | egrep 'CD_IO_UTIL' | grep -v _LG | grep -v _SM| grep -c -v FD_`
   ((disk_pct = disk_pct_all/disk_cnt ))
   echo $disk_pct
}

flash_read_lat() {
  lat_all=`cat $mcfile | egrep 'CD_IO_TM_R_SM_RQ|CD_IO_TM_R_LG_RQ' | grep FD_ | sed 's/,//g'|awk 'BEGIN {w=0} {w=$4+w;} END {printf("%d\n",w);}'`
  cnt=`cat $mcfile | egrep 'CD_IO_TM_R_SM_RQ|CD_IO_TM_R_LG_RQ' | grep -c FD_`
  ((lat = lat_all/cnt))
  echo $lat
}

disk_read_lat() {
  lat_all=`cat $mcfile | egrep 'CD_IO_TM_R_SM_RQ|CD_IO_TM_R_LG_RQ' | grep -v FD_ | sed 's/,//g'|awk 'BEGIN {w=0} {w=$4+w;} END {printf("%d\n",w);}'`
  cnt=`cat $mcfile | egrep 'CD_IO_TM_R_SM_RQ|CD_IO_TM_R_LG_RQ' | grep -v -c FD_`
  ((lat = lat_all/cnt))
  echo $lat
}

flash_write_lat() {
  lat_all=`cat $mcfile | egrep 'CD_IO_TM_W_SM_RQ|CD_IO_TM_W_LG_RQ' | grep FD_ | sed 's/,//g'|awk 'BEGIN {w=0} {w=$4+w;} END {printf("%d\n",w);}'`
  cnt=`cat $mcfile | egrep 'CD_IO_TM_W_SM_RQ|CD_IO_TM_W_LG_RQ' | grep -c FD_`
  ((lat = lat_all/cnt))
  echo $lat
}

disk_write_lat() {
  lat_all=`cat $mcfile | egrep 'CD_IO_TM_W_SM_RQ|CD_IO_TM_W_LG_RQ' | grep -v FD_ | sed 's/,//g'|awk 'BEGIN {w=0} {w=$4+w;} END {printf("%d\n",w);}'`
  cnt=`cat $mcfile | egrep 'CD_IO_TM_W_SM_RQ|CD_IO_TM_W_LG_RQ' | grep -v -c FD_`
  ((lat = lat_all/cnt))
  echo $lat
}


case $1 in
  "flash_read" ) cat $mcfile | egrep  'CD_IO_RQ_R_LG_SEC|CD_IO_RQ_R_SM_SEC' |grep  FD_ |sed 's/,//g'|awk 'BEGIN {w=0} {w=$4+w;} END {printf("%d\n",w);}'    ;;
  "flash_write") cat $mcfile | egrep  'CD_IO_RQ_W_LG_SEC|CD_IO_RQ_W_SM_SEC' |grep  FD_ |sed 's/,//g'|awk 'BEGIN {w=0} {w=$4+w;} END {printf("%d\n",w);}'    ;;
  "disk_read"  ) cat $mcfile | egrep  'CD_IO_RQ_R_LG_SEC|CD_IO_RQ_R_SM_SEC' |grep  -v FD_ |sed 's/,//g'|awk 'BEGIN {w=0} {w=$4+w;} END {printf("%d\n",w);}' ;;
  "disk_write" ) cat $mcfile | egrep  'CD_IO_RQ_W_LG_SEC|CD_IO_RQ_W_SM_SEC' |grep  -v FD_ |sed 's/,//g'|awk 'BEGIN {w=0} {w=$4+w;} END {printf("%d\n",w);}' ;;
  "flash_io_pct"  ) flash_io_pct ;;
  "disk_io_pct"   ) disk_io_pct ;;
  "flash_read_lat"   ) flash_read_lat ;;
  "disk_read_lat"    ) disk_read_lat  ;;
  "flash_write_lat"  ) flash_write_lat;;
  "disk_write_lat"   ) disk_write_lat ;;
   *              ) echo "Usage: $0 flash_read|flash_write|disk_read|disk_write|flash_io_pct|disk_io_pct|flash_read_lat|disk_read_lat|flash_write_lat|disk_write_lat" ;;
esac
