#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
module=phddns
DIR=$(cd $(dirname $0); pwd)
odmpid=$(nvram get odmpid)
productid=$(nvram get productid)
[ -n "${odmpid}" ] && MODEL="${odmpid}" || MODEL="${productid}"
LINUX_VER=$(uname -r|awk -F"." '{print $1$2}')

_get_type() {
	local FWTYPE=$(nvram get extendno|grep koolshare)
	if [ -d "/koolshare" ];then
		if [ -n $FWTYPE ];then
			echo "koolshare官改固件"
		else
			echo "koolshare梅林改版固件"
		fi
	else
		if [ "$(uname -o|grep Merlin)" ];then
			echo "梅林原版固件"
		else
			echo "华硕官方固件"
		fi
	fi
}

exit_install(){
	local state=$1
	case $state in
		1)
			echo_date "本插件适用于【koolshare 梅林改/官改 hnd/axhnd/axhnd.675x】固件平台！"
			echo_date "你的固件平台不能安装！！!"
			echo_date "本插件支持机型/平台：https://github.com/koolshare/rogsoft#rogsoft"
			echo_date "退出安装！"
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 1
			;;
		0|*)
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 0
			;;
	esac
}

# 判断路由架构和平台：koolshare固件，并且linux版本大于等于4.1
if [ -d "/koolshare" -a -f "/usr/bin/skipd" -a "${LINUX_VER}" -ge "41" ];then
	echo_date 机型：${MODEL} $(_get_type) 符合安装要求，开始安装插件！
else
	exit_install 1
fi

# stop phddns first
killall -9 phddns_daemon.sh > /dev/null 2>&1
killall -9 oraysl > /dev/null 2>&1
killall -9 oraynewph > /dev/null 2>&1

rm -rf /koolshare/init.d/*Phddns.sh > /dev/null 2>&1
rm -rf /koolshare/phddns > /dev/null 2>&1

cp -rf /tmp/phddns/bin  /koolshare/phddns
cp -rf /tmp/phddns/oray_op/ /koolshare/phddns/
cp -rf /tmp/phddns/res/* /koolshare/res/
cp -rf /tmp/phddns/scripts/* /koolshare/scripts/
cp -rf /tmp/phddns/webs/*  /koolshare/webs/
cp -rf /tmp/phddns/init.d/* /koolshare/init.d/
cp -rf /tmp/phddns/uninstall.sh /koolshare/scripts/uninstall_phddns.sh

#if [ -f /koolshare/init.d/S60Phddns.sh ]; then
#	rm -rf /koolshare/init.d/S60Phddns.sh
#fi

#if [ -L /koolshare/init.d/S60Phddns.sh ]; then
#	rm -rf /koolshare/init.d/S60Phddns.sh
#fi

chmod 755 /koolshare/init.d/*Phddns.sh
chmod 755 /koolshare/scripts/phddns_*.sh
chmod 755 /koolshare/phddns/oraynewph
chmod 755 /koolshare/phddns/oraysl
chmod 755 /koolshare/phddns/phddns_daemon.sh
chmod 755 /koolshare/phddns/oray_op/*

# phddns config directory
mkdir /koolshare/phddns/config > /dev/null 2>&1

# 离线安装用
dbus set phddns_version="$(cat $DIR/version)"
dbus set softcenter_module_phddns_version="$(cat $DIR/version)"
dbus set softcenter_module_phddns_description="花生壳内网版3.0"
dbus set softcenter_module_phddns_install="1"
dbus set softcenter_module_phddns_name="phddns"
dbus set softcenter_module_phddns_title="花生壳内网版"

# complete
echo_date "花生壳内网版3.0 插件安装完毕！"
exit_install
