#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Updates the allowed mailbox size (quota) for a user in iRedmail.
# License: 	2-clause BSD license
#
# Example usage: sh increase-mailbox-quota.sh jeff@example.com 2048
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# Note: Enter the size as mb. The default quota is 1024 mb.
# sh increase-mailbox-quota.sh jeff@example.com 2048 > output.sql
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
quota="$2"

cat <<EOF
UPDATE mailbox SET quota = '${quota}' WHERE username = '${address}';
EOF
