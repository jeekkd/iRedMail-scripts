#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Re-activate a user account iRedmail.
# License: 	2-clause BSD license
#
# Example usage: sh set-account-active.sh jeff@example.com
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# sh sh set-account-active.sh jeff@example.com > output.sql
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
address="$1"

cat <<EOF
UPDATE forwardings SET active = '1' WHERE address = '${address}' AND forwarding = '${address}';
EOF
