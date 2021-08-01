#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Remove mail forwarding for a user or remove a user from an alias in iRedmail.
# License: 	2-clause BSD license
#
# Example usage: sh remove-forwarding.sh alias@mydomain.com jeff@gmail.com
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# sh remove-forwarding.sh alias@mydomain.com jeff@gmail.com > output.sql
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
address="$1"
destinationAddress="$2"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 2 ]; then
	printf "Purpose: Remove mail forwarding for a user or remove a user from an alias in iRedmail. \n"
	printf "Usage: sh remove-forwarding.sh alias@mydomain.com jeff@gmail.com \n"
	exit 0
fi

printf "DELETE FROM forwardings WHERE address = '${address}' AND forwarding = '${destinationAddress}'; \n"
