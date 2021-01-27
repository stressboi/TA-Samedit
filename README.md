# TA-Samedit

Simple Splunk UF detection for Baron Samedit sudo buffer overflow.

This takes the detection method from https://blog.qualys.com/vulnerabilities-research/2021/01/26/cve-2021-3156-heap-based-buffer-overflow-in-sudo-baron-samedit and converts it into a scripted input for any Splunk Universal Forwarder running on a Linux server or endpoint. This detection method is not foolproof but parses the output of stderror from a sudoedit command. If that output contains "sudoedit:" then the version of sudo is vulnerable.

Simply drop it into the /etc/apps directory on a Universal Forwarder (or use deployment server or your favorite distribution method to get it there). By default it runs once an hour and outputs key/value pairs "samedit_status" and "finding" to tell you if that particular Linux host is potentially vulnerable. It also outputs the sudo version found.

26JAN21

brodsky@splunk.com
