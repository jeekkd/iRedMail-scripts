#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Creates an alias account, otherwise known as a Distribution List, in iRedmail.
# License: 	2-clause BSD license
#
# Example usage: sh create-dl.sh alias@mydomain.com mydomain.com
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# sh create-dl.sh alias@mydomain.com mydomain.com > output.sql
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
aliasName="$1"

cat <<EOF
DELETE from alias WHERE address = '${aliasName}';
EOF
