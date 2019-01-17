#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Creates a mail forwarding setup to direct email sent to user@example.com otherUser@example.com in iRedmail.
# License: 	2-clause BSD license
# Reference: https://docs.iredmail.org/sql.user.mail.forwarding.html
# Note: Be careful if a user with a mailbox set to forward to itself (same configuration as normal user) as it will save a copy of all email still and if left unchecked the space used by mail could add up.
#
# Example usage: sh add-mail-forward.sh user@example.com otherUser@example.com
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# sh add-mail-forward.sh user@example.com otherUser@example.com > output.sql
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
forwardToEmail="$2"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -lt 2 ]; then
	printf "Purpose: Creates a mail forwarding setup to direct email sent to user@example.com otherUser@example.com in iRedmail. \n"
	printf "Usage: sh add-mail-forward.sh user@example.com otherUser@example.com \n"
	exit 0
fi

addressDomain=$(echo $address | cut -f 2 -d '@')
forwardToEmailDomain=$(echo $forwardToEmail | cut -f 2 -d '@')

printf "INSERT INTO forwardings (address, forwarding, domain, dest_domain, is_forwarding, active) VALUES ('${address}', '${forwardToEmail}', '${addressDomain}', '${forwardToEmailDomain}', 1, 1); \n"
