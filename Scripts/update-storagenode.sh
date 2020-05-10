#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Updates the storagenode in iRedmail, this by default is vmail1.
# License: 	2-clause BSD license
#
# Note: vmail1 is the default value and should NOT be changed without good reason. 
# Note #2: The files and folders on the file system will not be moved to the new location without you doing so.
#
# sh update-storagenode.sh vmail1 vmail2
#
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# sh update-storagenode.sh vmail1 vmail2 > output.sql
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
current="$1"
new="$2"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 2 ]; then
	printf "Purpose: Updates the storagenode in iRedmail, this by default is vmail1. \n"
	printf "Usage: sh update-storagenode.sh vmail1 vmail2 \n"
	exit 0
fi

printf "UPDATE mailbox SET storagenode = '$new' WHERE storagenode = '$current';\n"
