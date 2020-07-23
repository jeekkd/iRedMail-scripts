#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Determine if a given email address has forwards set from itself to other email addreses in iRedmail.
# License: 	2-clause BSD license
# Note: If you see an address to itself in the forwarding column this is normal and is required for a regular account and mailbox to function.
#
# sh is-forward-to.sh jeff@example.com
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# sh is-forward-to.sh jeff@example.com > output.sql
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
	printf "Purpose: Determine if a given email address has forwards set from itself to other email addreses in iRedmail. \n"
	printf "Note: If you see an address to itself in the forwarding column this is normal and is required for a regular account and mailbox to function. \n"
	printf "Usage: sh is-forward-to.sh jeff@example.com \n"
	exit 0
fi

printf "SELECT id,address,forwarding,domain FROM forwardings WHERE is_forwarding = '1' AND forwarding = '${address}'; \n"
