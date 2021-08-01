#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Creates or updates an access policy for an alias to restrict which senders are allowed to send email to this mail alias, in iRedMail.
# License: 	2-clause BSD license
# Requirements: Access restriction requires iRedAPD plugin sql_alias_access_policy, please make sure it's enabled in iRedAPD config file /opt/iredapd/settings.py.
#
# Available access policies:
# Access Policy Name 	Comment
# public 	no restrictions
# domain 	all users under same domain are allowed to send email to this mail alias account.
# subdomain 	all users under same domain and all sub-domains are allowed to send email to this mail alias account.
# membersonly 	only members of this mail alias account are allowd.
# moderatorsonly 	only moderators of this mail alias account are allowed.
# membersandmoderatorsonly 	only members and moderators of this mail alias account are allowed.

# Example usage: sh create-alias-policy.sh alias@mydomain.com public
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# sh create-alias-policy.sh alias@mydomain.com public > output.sql
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
dlName="$1"
policy="$2"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 2 ]; then
	printf "Purpose: Creates or updates an access policy for an alias to restrict which senders are allowed to send email to this mail alias, in iRedMail. \n"
	printf "Available access policies: \n"
	printf "public 	no restrictions \n"
	printf "domain 	all users under same domain are allowed to send email to this mail alias account. \n"
	printf "subdomain 	all users under same domain and all sub-domains are allowed to send email to this mail alias account. \n"
	printf "membersonly 	only members of this mail alias account are allowd. \n"
	printf "moderatorsonly 	only moderators of this mail alias account are allowed. \n"
	printf "membersandmoderatorsonly 	only members and moderators of this mail alias account are allowed. \n"
	printf "\n"
	printf "Usage: sh create-alias-policy.sh alias@mydomain.com public \n"
	exit 0
fi

printf "UPDATE alias SET accesspolicy='${policy}' WHERE address='${dlName}'; \n"
