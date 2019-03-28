#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Disables enablepop3,enablepop3secured,enablepop3tls in the mailbox table for a given user to be 0 (disabled) in iRedmail so to disable pop3.
# License: 	2-clause BSD license
#
# sh disable-pop3-for-user.sh jeff@example.com
#
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# sh disable-pop3-for-user.sh jeff@example.com > output.sql
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
username="$1"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -eq 0 ]; then
	printf "Purpose: Disables enablepop3,enablepop3secured,enablepop3tls in the mailbox table for a given user to be 0 (disabled) in iRedmail so to disable pop3. \n"
	printf "Usage: sh disable-pop3-for-user.sh jeff@example.com \n"
	exit 0
fi

printf "UPDATE mailbox SET enablepop3 = '0' WHERE username = '$username' AND enablepop3 = '1';\n"
printf "UPDATE mailbox SET enablepop3secured = '0' WHERE username = '$username' AND enablepop3secured = '1';\n"
printf "UPDATE mailbox SET enablepop3tls = '0' WHERE username = '$username' AND enablepop3tls = '1';\n"
