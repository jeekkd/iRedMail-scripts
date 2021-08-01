#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Re-enables a disabled user account in iRedmail.
# License: 	2-clause BSD license
#
# Example usage: sh enable-user.sh jeff@example.com
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# sh enable-user.sh jeff@example.com > output.sql
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

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 1 ]; then
	printf "Purpose: Re-enable a disabled user account in iRedmail. \n"
	printf "Usage: sh enable-user.sh jeff@example.com \n"
	exit 0
fi

printf "UPDATE mailbox SET active = '1' WHERE username = '${username}';\n"
