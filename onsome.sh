#!/bin/bash

for netns in $(ip netns list | grep "h1 " | awk '{print $1}'); do
    sudo ip netns exec $netns $@
done
