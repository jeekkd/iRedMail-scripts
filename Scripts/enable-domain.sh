#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Re-enables a disabled domain in iRedMail.
# License: 	2-clause BSD license
#
# sh enable-domain.sh example.com
#
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# sh enable-domain.sh example.com > output.sql
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
	printf "Purpose: Re-enables a disabled domain in iRedMail. \n"
	printf "Usage: sh enable-domain.sh example.com \n"
	exit 0
fi

printf "UPDATE domain SET active = '1' WHERE domain = '$domain';\n"
