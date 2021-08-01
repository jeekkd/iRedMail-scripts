#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Remove an alias domain in iRedMail.
# License: 	2-clause BSD license
#
# bash remove-alias-domain.sh example.com domain.ltd
#
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# bash remove-alias-domain.sh example.com domain.ltd > output.sql
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
	printf "Purpose: Remove an alias domain in iRedMail. \n"
	printf "Note: In the below example command the domain name domain.ltd is an alias domain of example.com. Adjust your command accordingly. \n"
	printf "Usage: bash remove-alias-domain.sh example.com domain.ltd \n"
	exit 0
fi

printf "DELETE FROM alias_domain WHERE alias_domain = '$domainAlias' AND target_domain = '$domain'; \n"
