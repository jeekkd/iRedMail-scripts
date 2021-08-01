#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Add an alias domain in iRedMail.
# License: 	2-clause BSD license
#
# Let's say you have a mail domain example.com hosted on your iRedMail server, if you add domain name domain.ltd as an alias domain of example.com, all emails sent to username@domain.ltd will be delivered to user username@example.com's mailbox.
#
# bash add-alias-domain.sh example.com domain.ltd
#
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# bash add-alias-domain.sh example.com domain.ltd > output.sql
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
domainAlias="$2"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 2 ]; then
	printf "Purpose: Add an alias domain in iRedMail. \n"
	printf "Note: Let's say you have a mail domain example.com hosted on your iRedMail server, if you add domain name domain.ltd as an alias domain of example.com, all emails sent to username@domain.ltd will be delivered to user username@example.com's mailbox. \n"
	printf "Usage: bash add-alias-domain.sh example.com domain.ltd \n"
	exit 0
fi

printf "INSERT INTO alias_domain (alias_domain, target_domain) VALUES ('${domainAlias}', '${domain}'); \n"
