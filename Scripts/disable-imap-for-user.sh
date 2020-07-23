#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Disables enableimap,enableimapsecured,enableimaptls in the mailbox table for a given user to be 0 (disabled) in iRedmail so to disable IMAP.
# License: 	2-clause BSD license
#
# sh disable-imap-for-user.sh jeff@example.com
#
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# sh disable-imap-for-user.sh jeff@example.com > output.sql
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
	printf "Purpose: Disables enableimap,enableimapsecured,enableimaptls in the mailbox table for a given user to be 0 (disabled) in iRedmail so to disable IMAP. \n"
	printf "Usage: sh disable-imap-for-user.sh jeff@example.com \n"
	exit 0
fi

printf "UPDATE mailbox SET enableimap = '0' WHERE username = '$username' AND enableimap = '1';\n"
printf "UPDATE mailbox SET enableimapsecured = '0' WHERE username = '$username' AND enableimapsecured = '1';\n"
printf "UPDATE mailbox SET enableimaptls = '0' WHERE username = '$username' AND enableimaptls = '1';\n"
