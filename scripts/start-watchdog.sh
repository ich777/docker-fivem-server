#!/bin/bash
sleep 30
killpid="$(pidof ld-musl-x86_64.so.1)"
while true
do
	tail --pid=$killpid -f /dev/null
	kill "$(pidof tail)"
	exit 0
done