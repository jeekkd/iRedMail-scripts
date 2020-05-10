#!/bin/sh
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose:  Change domain name of an existing domain and associated mail accounts in iRedmail.
# License: 	2-clause BSD license
#
# WARNING: This changes ONLY the SQL side, the mail directory needs to be renamed as well as any existing maildir to reflect the new domain.
#
# sh update-domain.sh old-domain.com new-domain.com
#
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# sh update-domain.sh old-domain.com new-domain.com > output.sql
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
current="$1"
new="$2"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 2 ]; then
	printf "Purpose: Change domain name of an existing domain and associated mail accounts in iRedmail. \n"
	printf "WARNING: This changes ONLY the SQL side, the mail directory needs to be renamed as well as any existing maildir to reflect the new domain. \n"
	printf "Usage: sh update-domain.sh old-domain.com new-domain.com \n"
	exit 0
fi

# alias table
printf "UPDATE alias SET domain = '$new' WHERE domain = '$current';\n"
printf "UPDATE alias SET username = replace(username, '$current', '$new') WHERE address LIKE '$current'';\n"

# deleted_mailboxes table
printf "UPDATE deleted_mailboxes SET maildir = regexp_replace(maildir, '\m$current\M', '$new', 'gi') WHERE domain LIKE '$current';\n"
printf "UPDATE deleted_mailboxes SET username = regexp_replace(username, '\m$current\M', '$new', 'gi') WHERE domain LIKE '$current';\n"
printf "UPDATE deleted_mailboxes SET domain = '$new' WHERE domain = '$current';\n"

# domain table
printf "UPDATE domain SET domain = '$new' WHERE domain = '$current';\n"

# domain_admins table
printf "UPDATE domain_admins SET username = regexp_replace(username, '\m$current\M', '$new', 'gi') WHERE username LIKE '%$current';\n"

# forwardings table
printf "UPDATE forwardings SET address = regexp_replace(address, '\m$current\M', '$new', 'gi') WHERE domain LIKE '$current';\n"
printf "UPDATE forwardings SET forwarding = regexp_replace(forwarding, '\m$current\M', '$new', 'gi') WHERE dest_domain LIKE '$current';\n"
printf "UPDATE forwardings SET domain = '$new' WHERE domain = '$current';\n"
printf "UPDATE forwardings SET dest_domain = '$new' WHERE dest_domain = '$current';\n"

# mailbox table
printf "UPDATE mailbox SET maildir = regexp_replace(maildir, '\m$current\M', '$new', 'gi') WHERE domain LIKE '$current';\n"
printf "UPDATE mailbox SET username = regexp_replace(username, '\m$current\M', '$new', 'gi') WHERE domain LIKE '$current';\n"
printf "UPDATE mailbox SET domain = '$new' WHERE domain = '$current';\n"

# used_quota table
printf "UPDATE used_quota SET username = regexp_replace(username, '\m$current\M', '$new', 'gi') WHERE domain LIKE '$current';\n"
printf "UPDATE used_quota SET domain = '$new' WHERE domain = '$current';\n"

