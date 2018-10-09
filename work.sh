#!/bin/bash

while true; do
  if ! ping -A -c 10 140.221.197.66 | grep " 0% packet loss"; then
    echo "ping failed"
  fi
  randtime=$(shuf -i 1-14 -n 1)
  sleep $randtime
done
