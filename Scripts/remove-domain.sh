#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Remove a domain from iRedMail. This does not remove associates mail accounts or mailboxes.
# License: 	2-clause BSD license
# Note: 	Once the domain is removed from the database, you can they use remove-user.sh script to remove user accounts.
#
# sh remove-domain.sh example.com
#
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# sh remove-domain.sh example.com > output.sql
#
# Import output.sql into SQL database like below:
#
# mysql -uroot -p
# mysql> USE vmail;
# mysql> SOURCE /path/to/output.sql;
#
# psql -d vmail
# sql> \i /path/to/output.sql;

# Read input
domain="$1"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -eq 0 ]; then
	printf "Purpose: Remove a domain from iRedMail. This does not remove associates mail accounts or mailboxes. \n"
	printf "Usage: sh remove-domain.sh example.com \n"
	exit 0
fi

printf "DELETE FROM domain WHERE domain = '$domain';\n"
