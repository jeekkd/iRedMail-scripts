#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Lists top 10 mailboxes in vmail db in used_quota from largest to smallest in iRedmail.
# License: 	2-clause BSD license
#
# Example usage: sh list-top-10-mailbox.sh
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# sh list-top-10-mailbox.sh > output.sql
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
	printf "Purpose: Lists top 10 mailboxes in vmail db in used_quota from largest to smallest in iRedmail. \n"
	printf "Usage: sh list-top-10-mailbox.sh \n"
	exit 0
fi

printf "select * FROM used_quota ORDER BY bytes DESC limit 10; \n"
