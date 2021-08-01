#!/bin/bash
#
# Author: 	Daulton
# Website: 	daulton.ca
# Purpose: 	Updates the password for a user account in iRedmail.
# License: 	2-clause BSD license
#
# Note: You can also use this script to change hashing algorithms. If you made an account with SHA512 but actually wanted bcrypt you can change that by updating the password.
#
# 1) First you must get the hashed password, use the following example. SSHA512 is recommended on Linux systems. BCRYPT is recommended on BSD systems.
# SHA512: doveadm pw -s 'ssha512' -p '123456'
# bcrypt: doveadm pw -s 'blf-crypt' -p '123456'
#
# 2) Next use the hash with this script to get the SQL required to update the specified user account. Note for bcrypt passwords surround the password with an apostrophe on each side.
# sh update-account-password.sh jeff@example.com {SSHA512}ZJrxEEz44aTyd/srPRU3RH4zThW4PHFIDSGYyADEE/D3QUyrgWmiKHyajWN2SQA4+VAk6X5ePaqwbMQqqICj3BCnhYgc/SDc
# 
# This will print SQL commands on the console directly, you can redirect the
# output to a file for further use like this:
# 
# bash update-account-password.sh jeff@example.com {SSHA512}ZJrxEEz44aTyd/srPRU3RH4zThW4PHFIDSGYyADEE/D3QUyrgWmiKHyajWN2SQA4+VAk6X5ePaqwbMQqqICj3BCnhYgc/SDc > output.sql
#
# Import output.sql into SQL database like below:
#
# mysql -uroot -p
# mysql> USE vmail;
# mysql> SOURCE /path/to/output.sql;
#
# psql -U vmailadmin -d vmail
# sql> \i /path/to/output.sql;

# Password scheme. Available schemes: BCRYPT, SSHA512, SSHA, MD5, NTLM, PLAIN.
# Check file Available
PASSWORD_SCHEME='SSHA512'

# Read input
address="$1"
plain_password="$2"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 2 ]; then
	printf "Purpose: Updates the password for a user account in iRedmail. \n"
	printf "Note: You can also use this script to change hashing algorithms. If you made an account with SHA512 but actually wanted bcrypt you can change that by updating the password."
	printf "Note: Default password scheme is SSHA512, enter a different scheme as the third parameter if you wish to override. Available schemes: BCRYPT, SSHA512, SSHA, MD5, NTLM, PLAIN. \n"
	printf "Usage: bash update-account-password.sh jeff@example.com Password123 \n"
	exit 0
fi

# Crypt the password given in $2
export CRYPT_PASSWD="$(python ./generate_password_hash.py ${PASSWORD_SCHEME} ${plain_password})"

printf "UPDATE mailbox SET password = '${CRYPT_PASSWD}', passwordlastchange = NOW() WHERE username = '$address';\n"
