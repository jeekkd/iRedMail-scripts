#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Updates the allowed mailbox size (quota) for a user in iRedmail.
# License: 	2-clause BSD license
#
# Note: Enter the size as mb. The default quota is 1024 mb.
#
# Example usage: sh increase-mailbox-quota.sh jeff@example.com 2048
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# sh increase-mailbox-quota.sh jeff@example.com 2048 > output.sql
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
address="$1"
quota="$2"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 2 ]; then
	printf "Purpose: Updates the allowed mailbox size (quota) for a user in iRedmail. \n"
	printf "Usage: sh increase-mailbox-quota.sh jeff@example.com 2048 \n"
	exit 0
fi

printf "UPDATE mailbox SET quota = '${quota}' WHERE username = '${address}'; \n"
