#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Re-activate a user account iRedmail.
# License: 	2-clause BSD license
#
# Example usage: sh set-account-active.sh jeff@example.com
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# sh sh set-account-active.sh jeff@example.com > output.sql
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

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 1 ]; then
	printf "Purpose: Re-activate a user account iRedmail. \n"
	printf "Usage: sh set-account-active.sh jeff@example.com \n"
	exit 0
fi

printf "UPDATE forwardings SET active = '1' WHERE address = '${address}' AND forwarding = '${address}'; \n"
