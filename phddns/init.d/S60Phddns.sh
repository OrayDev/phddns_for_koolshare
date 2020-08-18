#!/bin/sh
eval `dbus export phddns`

Phddns=/koolshare/phddns
proc=`ps | grep oraysl | grep -v "grep" | grep -v "grep"|awk '{print $1}'`
start_with_sys(){
	if [ -z "$proc" ]; then
		/koolshare/script/phddns_run.sh  start >/dev/null 2>&1 &
	fi
}
case $1 in

start)
	start_with_sys
	exit 0
	;;
esac
