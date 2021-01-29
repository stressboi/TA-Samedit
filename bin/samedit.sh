#! /bin/sh
# Baron Samedit checker 
# https://www.sudo.ws/alerts/unescape_overflow.html
# brodsky@splunk.com 
# 28 JAN 2021

VERSION=0.2-SplunkUF

# set a date format so we can output a date for each line
DATETIME=$(date '+%Y-%m-%d %H:%M:%S %Z')

# what's the IP address of the machine?
IPADD=$(hostname -I)

# check for sudo
if ! command -v sudo > /dev/null
then
	echo "$DATETIME src_ip=$IPADD finding='no sudo on this machine or in path'" 
	exit
fi

# any linux: what version is sudo?
VERSION=$(sudo -V |grep "Sudo version" | cut -c14-50)

# check for ubuntu, if ubuntu then use apt to find version
if command -v lsb_release > /dev/null
then
	UBUNTUVERSION=$(apt list --installed 2> /dev/null |grep sudo| cut -d ' ' -f 2)
fi

# if ubuntu, reset sudo version found to apt output
if [ -z ${UBUNTUVERSION+x} ]; then SUDOVERSION=$VERSION; else SUDOVERSION=$UBUNTUVERSION; fi

# is this version vuln
case $SUDOVERSION in
	1.9.5p2) VULNSTATUS=OK ;;
	1.9.4p2-2ubuntu2) VULNSTATUS=OK ;;
	1.9.1-1ubuntu1.1) VULNSTATUS=OK ;;
	1.8.31-1ubuntu1.2) VULNSTATUS=OK ;;
	1.8.21p2-3ubuntu1.4) VULNSTATUS=OK ;;
	1.8.16-0ubuntu1.10) VULNSTATUS=OK ;;
	1.8.9p5-1ubuntu1.5+esm6) VULNSTATUS=OK ;;
	*) VULNSTATUS=PATCH ;;
esac

case $VULNSTATUS in
	OK) STATUS=0 ;;
	*) STATUS=1 ;;
esac

# output finding
echo "$DATETIME src_ip=$IPADD finding='CVE-2021-3156 status is $VULNSTATUS' samedit_status=$STATUS sudo_v='$SUDOVERSION'"
