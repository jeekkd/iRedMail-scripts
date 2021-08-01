#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Removes the whole forwarding address and all forwards associated to it in iRedMail.
# License: 	2-clause BSD license
#
# Example usage: sh remove-whole-forward.sh contact@mydomain.com
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# bash remove-whole-forward.sh contact@mydomain.com > output.sql
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

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 1 ]; then
	printf "Purpose: Removes the whole forwarding address and all forwards associated to it in iRedMail. \n"
	printf "Usage: bash remove-whole-forward.sh contact@mydomain.com \n"
	exit 0
fi

printf "DELETE FROM forwardings WHERE address = '${address}'; \n"
