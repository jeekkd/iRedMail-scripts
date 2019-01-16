#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Add a user to an alias, otherwise known as a distribution list, in iRedmail.
# License: 	2-clause BSD license
# Reference: https://docs.iredmail.org/sql.create.mail.alias
# 
# Note: The distribution list needs to exist first before you can add users to it.
# Example usage: sh add-user-to-alias.sh alias@mydomain.com jeff@gmail.com
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# sh add-user-to-alias.sh alias@mydomain.com jeff@gmail.com > output.sql
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
aliasAccount="$1"
sendToEmail="$2"

aliasAccountDomain=$(echo $aliasAccount | cut -f 2 -d '@')
sendToEmailDomain=$(echo $sendToEmail | cut -f 2 -d '@')

cat <<EOF
INSERT INTO forwardings (address, forwarding,
                              domain, dest_domain,
                              is_list, active)
                      VALUES ('${aliasAccount}', '${sendToEmail}',
                              '${aliasAccountDomain}', '${sendToEmailDomain}',
                              1, 1);

EOF
