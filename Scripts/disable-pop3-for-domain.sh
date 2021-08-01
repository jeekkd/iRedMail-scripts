#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Disables enablepop3,enablepop3secured,enablepop3tls in the mailbox table for a given domain to be 0 (disabled) in iRedmail so to disable pop3.
# License: 	2-clause BSD license
# Note: 	This is a one time change for all CURRENT user accounts, future accounts require the use of disable-pop3-for-user.sh to disable pop3 for an individual account.
#
# Usage: bash disable-pop3-for-domain.sh example.com
#
# Note: You can verify if this was successful with the following command:
# select username,domain,enablepop3,enablepop3secured,enablepop3tls FROM mailbox;
#
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# bash disable-pop3-for-domain.sh example.com > output.sql
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
domain="$1"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 1 ]; then
	printf "Purpose: Disables enablepop3,enablepop3secured,enablepop3tls in the mailbox table for a given domain to be 0 (disabled) in iRedmail so to disable pop3. \n"
	printf "Note: This is a one time change for all CURRENT user accounts, future accounts require the use of disable-pop3-for-user.sh to disable pop3 for an individual account. \n"
	printf "Usage: bash disable-pop3-for-domain.sh example.com \n"
	exit 0
fi

printf "UPDATE mailbox SET enablepop3 = '0' WHERE domain = '$domain' AND enablepop3 = '1';\n"
printf "UPDATE mailbox SET enablepop3secured = '0' WHERE domain = '$domain' AND enablepop3secured = '1';\n"
printf "UPDATE mailbox SET enablepop3tls = '0' WHERE domain = '$domain' AND enablepop3tls = '1';\n"
