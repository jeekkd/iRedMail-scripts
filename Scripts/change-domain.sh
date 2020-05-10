#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Changes an existing domain to a different one in iRedMail.
# License: 	2-clause BSD license
# Note: 	Once the new domain is added to iRedMail in the database, you can they use create-new-user.sh or create-new-user-bulk.sh scripts to add user accounts.
# The usage of this script is only necessary when adding NEW domains to iRedMail as during installation time your initial domain will be added.
#
# sh change-domain.sh old-domain.com new-domain.com
#
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# sh change-domain.sh old-domain.com new-domain.com > output.sql
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
oldDomain="$1"
oldDomain="$2"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -eq 0 || [ $# -gt 2 ]; then
	printf "Purpose: Changes an existing domain to a different one in iRedMail. \n"
	printf "Usage: sh change-domain.sh old-domain.com new-domain.com \n"
	exit 0
fi

printf "INSERT INTO domain VALUES domain = '$domain' AND active ='1';\n"
