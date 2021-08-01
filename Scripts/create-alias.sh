#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Creates an alias in iRedmail, email sent to an alias goes to all addresses added onto the alias.
# License: 	2-clause BSD license
#
# Example usage: sh create-alias.sh alias@mydomain.com mydomain.com
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# sh create-alias.sh alias@mydomain.com mydomain.com > output.sql
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
dlName="$1"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 1 ]; then
	printf "Purpose: Creates an alias in iRedmail, email sent to an alias goes to all addresses added onto the alias. \n"
	printf "Usage: sh create-alias.sh alias@mydomain.com \n"
	exit 0
fi

domain=$(echo $dlName | cut -f 2 -d '@')

printf "INSERT INTO alias (address, domain, active) VALUES ('${dlName}', '${domain}', 1); \n"
printf "UPDATE domain SET aliases = aliases + 1 WHERE domain = '${domain}';\n"
