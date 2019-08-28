#!/usr/bin/expect
set timeout 2
spawn ssh-keygen -t rsa
expect "Enter file in which to save the key (/root/.ssh/id_rsa):"
send "\n"
expect "Enter passphrase (empty for no passphrase):"
send "\n"
expect "Enter same passphrase again:"
send "\n"
expect "Overwrite (y/n)? "
send "\n"
expect eof
exit