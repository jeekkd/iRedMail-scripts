#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Updates the default quota for mailbox size for all domains, setting applies to all newly created mailboxes, in iRedmail.
# License: 	2-clause BSD license
#
# Note: 2048 is the new domain quota for NEWLY created mailboxes.
# sh update-all-quota.sh example.com 2048
#
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# sh update-all-domain-quota.sh 2048 > output.sql
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

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 1 ]; then
	printf "Purpose: Updates the default quota for mailbox size for all domains, setting applies to all newly created mailboxes, in iRedmail. \n"
	printf "Usage: sh update-all-domain-quota.sh 2048 \n"
	exit 0
fi

printf "UPDATE domain SET settings = 'default_user_quota:$quota;';\n"
