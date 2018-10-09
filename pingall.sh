#!/bin/bash

declare -A host
. hosts

my_ip=$(ip -4 address show veth0 | grep -oE "inet([^/]+)" | awk '{print $2}')

for host in ${hosts[@]}; do
    output=$(ping -A -c 20 $host | grep -E "(PING|packet loss)" | tr '\n' ' ')
    if ! echo $output | grep " 0% packet loss" > /dev/null; then
      echo "$(date) [$(ip netns identify) $my_ip] $output"
    fi
done
