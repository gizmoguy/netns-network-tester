#!/bin/bash

declare -A gateway
. etc/gateways.sh
. etc/netmasks.sh
. etc/vlans.sh

create_ns () {
    NETNS=$1
    IP=$2
    GW=$3
    TAG=$4
    sudo ip netns add ${NETNS}
    sudo ip link add dev veth-${NETNS} type veth peer name veth0 netns $NETNS
    sudo ip link set dev veth-${NETNS} up
    sudo ip netns exec $NETNS ip link set dev veth0 up
    sudo ip netns exec $NETNS ip addr add dev veth0 $IP
    sudo ip netns exec $NETNS ip route add default via $GW
    sudo ip netns exec $NETNS ip link set dev lo up
    sudo ovs-vsctl add-port ${BRIDGE} veth-${NETNS} tag=$TAG
}

echo -n "" > hosts

i=0
for vlan in ${vlans[@]}; do
    echo "Booting hosts for vlan $vlan" >&2
    for host in $(seq 1 $HOSTS_PER_VLAN ); do
        IFS=. read ip1 ip2 ip3 ip4 <<< "${gateway[$vlan]}"
        ip4=$(( $ip4 + $host ))
        echo "Starting vlan${vlan}-host${host} with IP ${ip1}.${ip2}.${ip3}.${ip4}/${netmask[$vlan]} and gtw ${gateway[$vlan]}" >&2
        echo "hosts[${i}]=${ip1}.${ip2}.${ip3}.${ip4}" >> hosts
        create_ns "${vlan}-h${host}" "${ip1}.${ip2}.${ip3}.${ip4}/${netmask[$vlan]}" "${gateway[$vlan]}" "$vlan"
        i=$(( $i + 1 ))
    done
done
