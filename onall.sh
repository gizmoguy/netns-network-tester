#!/bin/bash

for netns in $(ip netns list | awk '{print $1}'); do
    sudo ip netns exec $netns $@
done
