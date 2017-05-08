#!/bin/bash

# set PATH
export PATH=$PATH:/opt/oracle/cell12.1.2.3.4_LINUX.X64_170111/cellsrv/bin/

smartio () {
  cellcli -e list metriccurrent WHERE name LIKE  $1 | awk '{print $3}' | sed s/,//g 
}

dbio () { 
  cellcli -e list metriccurrent WHERE name LIKE DB_IO_BY_SEC and metricObjectName like $1 | awk '{print $3}' | sed s/,//g
}

usage () {
  echo "Usage: $0 smartio/dbio other arguments."
  exit 1
}

if [ $# -ne 2 ]; then usage; fi

case $1 in 
  "smartio" ) smartio $2 ;;
  "dbio"    ) dbio    $2 ;;
  *         ) usage      ;;
esac
