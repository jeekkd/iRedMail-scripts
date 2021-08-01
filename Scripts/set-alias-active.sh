#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Re-activates an alias in iRedmail.
# License: 	2-clause BSD license
#
# Example usage: sh set-alias-active.sh alias@mydomain.com
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# bash set-alias-active.sh alias@mydomain.com > output.sql
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
	printf "Purpose: Re-activates an alias in iRedmail. \n"
	printf "Usage: bash set-alias-active.sh alias@mydomain.com \n"
	exit 0
fi

printf "UPDATE forwardings SET active = '1' WHERE address = '${aliasName}' AND forwarding != '${aliasName}'; \n"
