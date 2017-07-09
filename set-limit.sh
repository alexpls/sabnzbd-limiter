#!/bin/bash

function ipAddressOfDeviceOnNetwork {
  ip_addr=$(arp -a | grep $1 | awk '{print substr($2, 2, length($2)-2)}')
  if [[ -z "$ip_addr" ]]; then
    return 1
  else
    echo $ip_addr
    return 0
  fi
}

function pingIpAddress {
  ping -c2 $1 > /dev/null 2>&1
}

function pingScan {
  for i in {1..254}; do
    ping -c 1 -W 1 "192.168.1.$i";
  done
}

function limitSpeed {
  speed=${1:-$UNLIMITED_SPEED}
  api_result=$(curl -s "$SABNZBD_HOST/api?mode=config&name=speedlimit&value=$speed&apikey=$SABNZBD_API_KEY&output=json")
  if echo $api_result | grep "true" > /dev/null 2>&1; then  
    return 0
  else
    return 1
  fi
}

function loadEnv {
  for i in $(cat $1); do
    export $i
  done
}

function main {
  lastKnownIp=""

  while true; do
    if [[ ! -z $lastKnownIp ]]; then
      echo -n "Pinging $lastKnownIp to try to refresh the ARP table..."
      pingIpAddress $lastKnownIp
      echo " done!"
    fi

    echo -n "Trying to find device '$PHONE_MAC_ADDRESS' on the network..."
    lastKnownIp=$(ipAddressOfDeviceOnNetwork $PHONE_MAC_ADDRESS)

    if [[ -z $lastKnownIp ]]; then
      echo " didn't find it"
      echo -n "Removing SABNZBD speed limit..."
      limitSpeed $UNLIMITED_SPEED
      echo " done!"
    else
      echo " found it, its IP is $lastKnownIp"
      echo -n "Setting SABNZBD speed limit to $LIMITED_SPEED..."
      limitSpeed $LIMITED_SPEED
      echo " done!"
    fi

    echo "Sleeping for $POLL_TIMEOUT seconds"
    sleep $POLL_TIMEOUT
  done
}

loadEnv ".env"
main
