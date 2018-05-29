#!/usr/bin/expect


device_name=$1

spawn sudo mkfs -t ext4 $1
expect "${device_name}: data"

send -- "y\r"

expect eof