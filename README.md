# TA-Samedit

Simple Splunk UF detection for Baron Samedit sudo buffer overflow (CVE-2021-3156). Refer to https://blog.qualys.com/vulnerabilities-research/2021/01/26/cve-2021-3156-heap-based-buffer-overflow-in-sudo-baron-samedit.

1-28-2021: V2: Redid detection to not rely on sudoedit command. V1 (found in bin directory) required UF to run as root! No bueno.

This scripted input captures the version of sudo found on the system and compares to a known-good list of sudo versions. It also takes into account Ubuntu systems that even after patching may still show a sudo --version known to be vulnerable and may therefore result in a false positive detection. 

This can be used on any Splunk Universal Forwarder running on a Linux server or endpoint. This detection method is not foolproof but parses the output of either sudo --version or apt list sudo. The version is then compared against a hard-coded list in the script.

Simply drop it into the /etc/apps directory on a Universal Forwarder (or use deployment server or your favorite distribution method to get it there). By default it runs once an hour and outputs key/value pairs "samedit_status" and "finding" to tell you if that particular Linux host is potentially vulnerable. It also outputs the sudo version found.

26JAN21

brodsky@splunk.com
