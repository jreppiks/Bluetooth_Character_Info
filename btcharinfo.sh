#!/bin/bash

usage() {
	echo "Usage: $0 [-m MAC] [-d device name (for log file)] [-i interface e.g. hci0"
  exit 1
}
while getopts "m:d:i:" flag; do
  case "${flag}" in
  m|mac)
    mac=${OPTARG}
    ;;
  d|device)
    device=${OPTARG}
    ;;
  i|interface)
   interface=${OPTARG}
   ;;
  *)
    usage
    ;;
  esac
done
raw_char=$device-raw-char.txt

[[ -z "${mac-}" ]] && echo "Missing required parameter: m|mac" && exit
[[ -z "${device-}" ]] && echo "Missing required parameter: d|device" && exit
if [ -z "${interface-}" ]; then
	interface=hci0
fi

gatttool -i $interface -b $mac  --characteristics | awk -F "," '{print $3}' | awk -F "= " '{print $2}' > $raw_char

for var in `cat $raw_char`; do echo -e "$var:"; gatttool -b $mac --char-read -a $var|awk -F ": " '{print $2}'|xxd -r -p; echo -e "\n\n";done
