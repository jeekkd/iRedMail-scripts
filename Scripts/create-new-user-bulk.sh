#!/bin/bash
#
# Author: 		Daulton
# Website: 		daulton.ca
# Purpose: 		Create a new user account in iRedmail setup with an SQL backend.
# License: 		2-clause BSD license
# Note: 		The CSV file used must have the format of email address,full name,password. Example: jeff@example.com,Jeff Gretzky,12345678
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
# 1) This will print SQL commands on the console directly and also it will save a SQL output file named 
# create-new-user-bulk.sql in the scripts present directory.
# 2) Additionally the user mailbox creation commands will be output to a file for you named create-new-user-bulk-commands.txt
#
# Import output.sql into SQL database like below:
#
# mysql -uroot -p
# mysql> USE vmail;
# mysql> SOURCE /path/to/create-new-user-bulk.sql;
#
# psql -U vmailadmin -d vmail
# sql> \i /path/to/create-new-user-bulk.sql;
#
# --------- CHANGE THESE VALUES ----------
# Storage base directory used to store users' mail.
STORAGE_BASE_DIRECTORY="/var/vmail/vmail1"

###########
# Password
#
# Password scheme. Available schemes: BCRYPT, SSHA512, SSHA, MD5, NTLM, PLAIN.
# Check file Available
PASSWORD_SCHEME='BCRYPT'

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

# control_c()
# Trap Ctrl-C for a quick and clean exit when necessary
control_c() {
	echo "Control-c pressed - exiting NOW"
	exit 1
}

# Trap any ctrl+c and call control_c function provided through functions.sh
trap control_c SIGINT

# get_script_dir()
# Gets the directory the script is being ran from.
get_script_dir() {
	script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}

# Leave here to get scripts running location
get_script_dir

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 1 ]; then
	echo "Purpose: Bulk creation of new user accounts in iRedmail setup with an SQL backend."
	echo "Note: The CSV file used must have the format of email address,full name,password. Example: jeff@example.com,Jeff Gretzky,12345678"
	echo "Usage: bash create-new-user-bulk.sh new-users.csv"
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

rm "$script_dir"/create-new-user-bulk-commands.txt 2> /dev/null
rm "$script_dir"/create-new-user-bulk.sql 2> /dev/null

count=1
while read csv; do
    mail=$(head -n "$count" "$1" | tail -n 1 | awk -F "\"*,\"*" '{print $1}')
	full_name=$(head -n "$count" "$1" | tail -n 1 | awk -F "\"*,\"*" '{print $2}')
	plain_password=$(head -n "$count" "$1" | tail -n 1 | awk -F "\"*,\"*" '{print $3}')
	
	username="$(echo $mail | awk -F'@' '{print $1}')"
	domain="$(echo $mail | awk -F'@' '{print $2}')"

	# Crypt the password given
	export CRYPT_PASSWD="$(python "$script_dir"/generate_password_hash.py ${PASSWORD_SCHEME} ${plain_password})"

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
		
		printf "\n"
		printf "Create users maildir with the following command: \n"
		printf "mkdir -p ${STORAGE_BASE_DIRECTORY}/${domain}/${str1}/${str2}/${str3}/${username}-${DATE}/ \n" | tee "$script_dir"/create-new-user-bulk-commands.txt
		printf "chown -R vmail:vmail ${STORAGE_BASE_DIRECTORY}/${domain}/${str1}/ \n" | tee "$script_dir"/create-new-user-bulk-commands.txt
		printf "\n"
	else
		maildir="${domain}/${username}-${DATE}/"
		printf "Create users maildir with the following command: \n"
		printf "mkdir -p ${STORAGE_BASE_DIRECTORY}/${domain}/${username}-${DATE}/ \n" | tee "$script_dir"/create-new-user-bulk-commands.txt
		printf "chown -R vmail:vmail ${STORAGE_BASE_DIRECTORY}/${domain}/${username}-${DATE}/ \n" | tee "$script_dir"/create-new-user-bulk-commands.txt
		printf "\n"
	fi

	printf "Create user via the following SQL statements: \n"
	printf "INSERT INTO mailbox (username, password, name, storagebasedirectory,storagenode, maildir, quota, domain, active, passwordlastchange, created) VALUES ('${mail}', '${CRYPT_PASSWD}', '${full_name}', '${STORAGE_BASE}','${STORAGE_NODE}', '${maildir}', '${DEFAULT_QUOTA}', '${domain}', '1', NOW(), NOW());\n" | tee "$script_dir"/create-new-user-bulk.sql
	printf "INSERT INTO forwardings (address, forwarding, domain, dest_domain, is_forwarding) VALUES ('${mail}', '${mail}','${domain}', '${domain}', 1); \n" | tee "$script_dir"/create-new-user-bulk.sql

	if [ ! -z "$ALIAS_ARRAY" ]; then
		ALIAS_ARRAYLength=${#ALIAS_ARRAY[@]}
		adjustedLength=$(( ALIAS_ARRAYLength - 1 ))

		for i in $( eval echo {0..$adjustedLength} ); do
			printf "INSERT INTO forwardings (address, forwarding, domain, dest_domain, active) VALUES '${ALIAS_ARRAY[$i]}@${domain}', '${mail}', '${domain}', '${domain}', 1); \n" | tee "$script_dir"/create-new-user-bulk.sql
		done
	fi

	printf "UPDATE domain SET mailboxes = mailboxes + 1 WHERE domain = '${domain}';\n"

	count=`expr $count + 1`
done < "$1"

