#!/bin/bash

stats="/var/run/haproxy.sock"

function haproxy_maint() {
  for i in `echo "show stat" | socat stdio ${stats} | grep FRONTEND | awk -F"," '{print $1}'`
  do
    if [ $i != "stats" -a $1 != "status" ];then
      echo "$1 frontend $i" | socat stdio ${stats > /dev/null
      echo "$i $1d"
    else
      status_result=`echo "show stat" | socat stdio ${stats} | grep FRONTEND | grep $i | awk -F"," '{print $18}'`
      echo "frontend $i $1 $status_result"
    fi
  done
}

case $1 in
  maint_all)
    elb_detach
    haproxy_maint disable
    ;;
  status_haproxy)
    haproxy_maint status
    ;;
  enable_haproxy)
    haproxy_maint enable
    ;;
  disable_haproxy)
    haproxy_maint disable
    ;;
  *)
    echo $"Usage: $0 {maint_all|status_haproxy|enable_haproxy|disable_haproxy}"
esac
