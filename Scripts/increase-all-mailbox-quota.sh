#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Increases the mail box quota size for all users regardless of domain, or for a specific domain, in iRedmail.
# License: 	2-clause BSD license
#
# Note: Enter the size as mb. The default quota is 1024 mb. Replace the domain name with an asterisk (*) to update all current users with the new mailbox quota size.
#
# Example usage: sh increase-all-mailbox-quota.sh example.com 2048
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# sh increase-all-mailbox-quota.sh example.com 2048 > output.sql
#
# Import output.sql into SQL database like below:
#
# mysql -uroot -p
# mysql> USE vmail;
# mysql> SOURCE /path/to/output.sql;
#
# psql -U vmailadmin -d vmail
# sql> \i /path/to/output.sql;

# Read input
domain="$1"
quota="$2"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 2 ]; then
	printf "Purpose: Increases the mail box quota size for all users regardless of domain, or for a specific domain, in iRedmail. \n"
	printf "Note: Replace the domain name with a quoted asterisk (*) to update all current users with the new mailbox quota size."
	printf "Usage: sh increase-all-mailbox-quota.sh example.com 2048 OR sh increase-all-mailbox-quota.sh \"*\" 2048 \n"
	exit 0
fi

if [ "$domain" != "*" ]; then
	printf "UPDATE mailbox SET quota = '${quota}' WHERE domain = '${domain}'; \n"
else
	printf "UPDATE mailbox SET quota = '${quota}'; \n"
fi
