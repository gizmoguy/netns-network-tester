#!/bin/bash

DEST=$1

ME=$(ip netns identify)
MY_IP=$(ip address show veth0 | grep "inet " | awk '{print $2}')

while true; do
  loss=$(mtr -rw $DEST | grep $DEST | awk '{print $3}')
  if [ "$loss" != "0.0%" ]; then
    echo $(date) "$loss loss from $ME (${MY_IP}) to $1"
  fi
  sleep 0.1
done
