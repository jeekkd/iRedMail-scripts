#!/bin/sh
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
# sh update-account-password.sh jeff@example.com {SSHA512}ZJrxEEz44aTyd/srPRU3RH4zThW4PHFIDSGYyADEE/D3QUyrgWmiKHyajWN2SQA4+VAk6X5ePaqwbMQqqICj3BCnhYgc/SDc > output.sql
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
password="$2"

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -lt 2 ]; then
	printf "Purpose: Updates the password for a user account in iRedmail. \n"
	printf "Note: You can also use this script to change hashing algorithms. If you made an account with SHA512 but actually wanted bcrypt you can change that by updating the password."
	printf "Instructions: 
1) First you must get the hashed password, use the following example. SSHA512 is recommended on Linux systems. BCRYPT is recommended on BSD systems.\n
SHA512: doveadm pw -s 'ssha512' -p '123456'
bcrypt: doveadm pw -s 'blf-crypt' -p '123456'

2) Next use the hash with this script to get the SQL required to update the specified user account. Note for bcrypt passwords surround the password with an apostrophe on each side. \n"

	printf "Usage: sh update-account-password.sh jeff@example.com {SSHA512}ZJrxEEz44aTyd/srPRU3RH4zThW4PHFIDSGYyADEE/D3QUyrgWmiKHyajWN2SQA4+VAk6X5ePaqwbMQqqICj3BCnhYgc/SDc \n"
	exit 0
fi

printf "UPDATE mailbox SET password = '$password' where username = '$address';\n"
