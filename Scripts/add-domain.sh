#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Adds a new domain in iRedMail.
# License: 	2-clause BSD license
# Note: 	Once the new domain is added to iRedMail in the database, you can they use create-new-user.sh or create-new-user-bulk.sh scripts to add user accounts.
# The usage of this script is only necessary when adding NEW domains to iRedMail as during installation time your initial domain will be added.
#
# sh new-domain.sh example.com
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
# psql -U vmailadmin -d vmail
# sql> \i /path/to/output.sql;

# Read input
domain="$1"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 1 ]; then
	printf "Purpose: Adds a new domain in iRedMail. \n"
	printf "Usage: sh new-domain.sh example.com \n"
	exit 0
fi

printf "INSERT INTO domain (domain, active) VALUES ('${domain}', 1); \n"
