#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Lists active email accounts in iRedmail.
# License: 	2-clause BSD license
#
# Example usage: sh list-active-accounts.sh
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# sh list-active-accounts.sh > output.sql
#
# Import output.sql into SQL database like below:
#
# mysql -uroot -p
# mysql> USE vmail;
# mysql> SOURCE /path/to/output.sql;
#
# psql -d vmail
# sql> \i /path/to/output.sql;

cat <<EOF
select username FROM mailbox WHERE active = 1;
EOF
