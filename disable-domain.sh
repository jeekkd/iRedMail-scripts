#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Disables a domain in iRedMail.
# License: 	2-clause BSD license
#
# sh disable-domain.sh example.com
#
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# sh disable-domain.sh example.com > output.sql
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

printf "UPDATE domain SET active = '0' WHERE domain = '$domain';\n"
