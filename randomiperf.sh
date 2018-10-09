#!/bin/bash

netns_server=$(ip netns list | awk '{print $1}' | shuf | head -1)
netns_client=$(ip netns list | awk '{print $1}' | grep -v "$netns_server" | shuf | head -1)

echo "Starting iperf between $netns_server and $netns_client"

iperf_server=$(sudo ip netns exec $netns_server ip -4 address show veth0 | grep -oE "inet([^/]+)" | awk '{print $2}')

sudo ip netns exec $netns_server iperf3 -s -D
sudo ip netns exec $netns_client iperf3 -c $iperf_server
sudo ip netns exec $netns_server killall iperf3
