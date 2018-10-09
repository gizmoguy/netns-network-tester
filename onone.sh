#!/bin/bash

netns=$(ip netns list | awk '{print $1}' | shuf | head -1)

sudo ip netns exec $netns $@
