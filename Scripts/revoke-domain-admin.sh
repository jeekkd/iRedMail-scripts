#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Revokes a users domain administrator permission in iRedMail.
# License: 	2-clause BSD license
#
# bash revoke-domain-admin.sh user@example.com
#
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# bash revoke-domain-admin.sh user@example.com > output.sql
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
username="$1"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -lt 1 ] || [ $# -ne 1 ]; then
	printf "Purpose: Revokes a users domain administrator permission in iRedMail. \n"
	printf "Usage: bash revoke-domain-admin.sh user@example.com \n"
	exit 0
fi

printf "UPDATE domain_admins SET active = '0' WHERE username = '$username';\n"
printf "UPDATE mailbox SET isadmin = '0' WHERE username = '${username}';\n"
printf "UPDATE mailbox SET isglobaladmin = '0' WHERE username = '${username}';\n"
