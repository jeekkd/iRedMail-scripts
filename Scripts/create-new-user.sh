#!/usr/bin/env bash
#
# Author: 		Daulton
# Website: 		daulton.ca
# Purpose: 		Create a new user account in iRedmail setup with an SQL backend.
# License: 		2-clause BSD license
# 
# Usage:
# Edit these variables:
# PASSWORD_SCHEME
# DEFAULT_QUOTA='1024'   # 1024 is 1GB
# ALIAS_ARRAY
#
# Run this script to generate SQL command used to create new user. Note run this script from the directory where generate_password_hash.py is.
# Example usage: bash create-new-user.sh user@example.com plain-password
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
#
# bash create-new-user.sh user@example.com plain-password > output.sql
#
# Import output.sql into SQL database like below:
#
# mysql -uroot -p
# mysql> USE vmail;
# mysql> SOURCE /path/to/output.sql;
#
# psql -U vmailadmin -d vmail
# sql> \i /path/to/output.sql;

# --------- CHANGE THESE VALUES ----------
# Storage base directory used to store users' mail.
STORAGE_BASE_DIRECTORY="/var/vmail/vmail1"

###########
# Password
#
# Password scheme. Available schemes: BCRYPT, SSHA512, SSHA, MD5, NTLM, PLAIN.
# Check file Available
PASSWORD_SCHEME='SSHA512'

# Default mail quota (in MB).
DEFAULT_QUOTA='1024'

# The default alias(es) you want all new mail accounts to be apart of. The aliases must first exist, and also adding the domain portion to the alias is unnecessary - see the example below.
# Format example: ALIAS_ARRAY=("allcompany" "announcements" "alerts")
ALIAS_ARRAY=("")

#
# Maildir settings
#
# Maildir style: hashed, normal.
# Hashed maildir style, so that there won't be many large directories
# in your mail storage file system. Better performance in large scale
# deployment.
# Format: e.g. username@domain.td
#   hashed  -> domain.ltd/u/us/use/username/
#   normal  -> domain.ltd/username/
# Default hash level is 3.
MAILDIR_STYLE='hashed'      # hashed, normal.

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 2 ]; then
	echo "Purpose: Create a new user account in iRedmail setup with an SQL backend."
    echo "Usage: bash create-new-user.sh user@example.com plain_password"
    exit 0
fi

# Time stamp, will be appended in maildir.
DATE="$(date +%Y.%m.%d.%H.%M.%S)"
WC_L='wc -L'
if [ X"$(uname -s)" == X'OpenBSD' ]; then
    WC_L='wc -l'
fi

STORAGE_BASE="$(dirname ${STORAGE_BASE_DIRECTORY})"
STORAGE_NODE="$(basename ${STORAGE_BASE_DIRECTORY})"

# Read input
mail="$1"
plain_password="$2"

username="$(echo $mail | awk -F'@' '{print $1}')"
domain="$(echo $mail | awk -F'@' '{print $2}')"

# Crypt the password given in $2
export CRYPT_PASSWD="$(python ./generate_password_hash.py ${PASSWORD_SCHEME} ${plain_password})"

# Different maildir style: hashed, normal.
if [ X"${MAILDIR_STYLE}" == X"hashed" ]; then
    length="$(echo ${username} | ${WC_L} )"
    str1="$(echo ${username} | cut -c1)"
    str2="$(echo ${username} | cut -c2)"
    str3="$(echo ${username} | cut -c3)"

    test -z "${str2}" && str2="${str1}"
    test -z "${str3}" && str3="${str2}"

    # Use mbox, will be changed later.
    maildir="${domain}/${str1}/${str2}/${str3}/${username}-${DATE}/"
    printf "Create users maildir with the following command: \n"
    printf "mkdir -p ${STORAGE_BASE_DIRECTORY}/${domain}/${str1}/${str2}/${str3}/${username}-${DATE}/ \n"
    printf "chown -R vmail:vmail ${STORAGE_BASE_DIRECTORY}/${domain}/${str1}/ \n"
    printf "\n"
else
    maildir="${domain}/${username}-${DATE}/"
    printf "Create users maildir with the following command: \n"
    printf "mkdir -p ${STORAGE_BASE_DIRECTORY}/${domain}/${username}-${DATE}/"
    printf "chown -R vmail:vmail ${STORAGE_BASE_DIRECTORY}/${domain}/${username}-${DATE}/ \n"
    printf "\n"
fi

printf "Run the following query in your vmail db: \n"
printf "INSERT INTO mailbox (username, password, name, storagebasedirectory,storagenode, maildir, quota, domain, active, passwordlastchange, created)
             VALUES ('${mail}', '${CRYPT_PASSWD}', '${username}', '${STORAGE_BASE}','${STORAGE_NODE}', '${maildir}', '${DEFAULT_QUOTA}', '${domain}', '1', NOW(), NOW());
INSERT INTO forwardings (address, forwarding, domain, dest_domain, is_forwarding)
             VALUES ('${mail}', '${mail}','${domain}', '${domain}', 1); \n"

if [ ! -z "$ALIAS_ARRAY" ]; then
    ALIAS_ARRAYLength=${#ALIAS_ARRAY[@]}
	adjustedLength=$(( ALIAS_ARRAYLength - 1 ))

	for i in $( eval echo {0..$adjustedLength} ); do
		printf "INSERT INTO forwardings (address, forwarding, domain, dest_domain, is_list, active) VALUES '${ALIAS_ARRAY[$i]}@${domain}', '${mail}', '${domain}', '${domain}', 1, 1); \n"
	done
fi

printf "UPDATE domain SET mailboxes = mailboxes + 1 WHERE domain = '${domain}';\n"
