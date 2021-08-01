#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Lists all from the forwardings table that are not just regular accounts in iRedmail.
# License: 	2-clause BSD license
#
# Example usage: sh list-all-but-regular-accounts.sh
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# sh list-all-but-regular-accounts.sh > output.sql
#
# Import output.sql into SQL database like below:
#
# mysql -uroot -p
# mysql> USE vmail;
# mysql> SOURCE /path/to/output.sql;
#
# psql -U vmailadmin -d vmail
# sql> \i /path/to/output.sql;

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -gt 0 ]; then
	printf "Purpose: Lists all from the forwardings table that are not just regular accounts in iRedmail. \n"
	printf "Usage: sh list-all-but-regular-accounts.sh \n"
	exit 0
fi

printf "select id,address,forwarding,domain,active FROM forwardings WHERE address != forwarding; \n"
