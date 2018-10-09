#!/bin/bash

for netns in $(ip netns list | awk '{print $1}'); do
    sudo ip netns del $netns
done

for port in $(sudo ovs-vsctl show | grep -oE "(veth.*) \(No such device\)" | awk '{print $1}'); do
    sudo ovs-vsctl del-port $port
done
