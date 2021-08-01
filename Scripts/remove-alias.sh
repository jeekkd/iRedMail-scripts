#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Removes an already existing alias in iRedmail.
# License: 	2-clause BSD license
#
# Example usage: sh remove-alias.sh alias@mydomain.com
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# bash remove-alias.sh alias@mydomain.com > output.sql
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
aliasName="$1"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 1 ]; then
	printf "Purpose: Creates an alias address which can be used to send email to multiple users at once when they are added 'onto' the alias in iRedmail. \n"
	printf "Usage: bash remove-alias.sh alias@mydomain.com \n"
	exit 0
fi

domain=$(echo $dlName | cut -f 2 -d '@')

printf "DELETE from alias WHERE address = '${aliasName}'; \n"
printf "UPDATE domain SET aliases = aliases - 1 WHERE domain = '${domain}';\n"
