#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Creates an alias account, otherwise known as a Distribution List, in iRedmail.
# License: 	2-clause BSD license
#
# Example usage: sh create-alias.sh alias@mydomain.com mydomain.com
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# sh create-alias.sh alias@mydomain.com mydomain.com > output.sql
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
dlName="$1"
domainName="$2"

cat <<EOF
INSERT INTO alias (address, domain, active)
                VALUES ('${dlName}', '${domainName}', 1);

EOF
