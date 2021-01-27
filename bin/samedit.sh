#! /bin/sh
# Baron Samedit checker 
# https://www.sudo.ws/alerts/unescape_overflow.html
# brodsky@splunk.com 
# 26 JAN 2021

VERSION=0.1-SplunkUF

# set a date format so we can output a date for each line
DATETIME=$(date '+%Y-%m-%d %H:%M:%S %Z')

# what's the IP address of the machine?
IPADD=$(hostname -I)

# check for sudo
if ! command -v sudo &> /dev/null
then
	echo "$DATETIME src_ip=$IPADD finding='no sudo on this machine or in path'" 
	exit
fi

# what version is sudo?
SUDOVERSION=$(sudo -V |grep "Sudo version" | cut -c14-50)

# run sudo and parse output
sudoedit -s / 2> sudoout
SUDOOUT=$(<sudoout)
rm sudoout

if [[ $SUDOOUT =~ "sudoedit" ]];
then
	echo "$DATETIME src_ip=$IPADD finding='CVE-2021-3156 found. Patch this system.' samedit_status=1 sudo_v=$SUDOVERSION"
else
	echo "$DATETIME src_ip=$IPADD finding='CVE-2021-3156 NOT found.' samedit_status=0 sudo_v=$SUDOVERSION"
fi

