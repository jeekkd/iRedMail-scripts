#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Makes an existing user a domain admin in iRedMail.
# License: 	2-clause BSD license
#
# Note: Replace ALL with a specific domain name if you want the user to be restricted to administer only
# a specific domain.
#
# sh new-domain-admin.sh user@example.com ALL
#
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# sh new-domain.sh example.com > output.sql
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
username="$1"
domain="$2"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 2 ]; then
	printf "Purpose: Makes an existing user a domain admin in iRedMail. \n"
	printf "Note: Replace ALL with a specific domain name if you want the user to be restricted to administer only a specific domain. \n"
	printf "Usage: sh new-domain-admin.sh user@example.com ALL \n"
	exit 0
fi

printf "INSERT INTO domain_admins (username, domain, active) VALUES ('${username}', '${domain}', 1); \n"
