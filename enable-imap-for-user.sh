#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Enables enableimap,enableimapsecured,enableimaptls in the mailbox table for a given user to be 1 (enabled) in iRedmail so to enable IMAP.
# License: 	2-clause BSD license
#
# sh enable-imap-for-user.sh jeff@example.com
#
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# sh enable-imap-for-user.sh jeff@example.com > output.sql
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

printf "UPDATE mailbox SET enableimap = '1' WHERE username = '$username';\n"
printf "UPDATE mailbox SET enableimapsecured = '1' WHERE username = '$username';\n"
printf "UPDATE mailbox SET enableimaptls = '1' WHERE username = '$username';\n"
