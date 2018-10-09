#!/bin/bash

declare -A mac
declare -A gateway
. etc/macs.sh
. etc/gateways.sh

for netns in $(ip netns list | awk '{print $1}' | grep -v "port"); do
    vlan=$(echo $netns | cut -d '-' -f 1)
    sudo ip netns exec $netns ip neigh del ${gateway[$vlan]} dev veth0 lladdr ${mac[$vlan]}
done
