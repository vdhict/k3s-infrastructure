#!/bin/bash

message() {
  echo -e "\n######################################################################"
  echo "# $1"
  echo "######################################################################"
}

usage() {
  echo "Run the script with '$0 <some node name> (optional <some target path>)'"
  echo "e.g. '$0 clu01-master /Volumes/system-boot'"
  echo -e "the following node files are detected:\n"
  ls -1 nodes
  exit 1
}

if [ $# -eq 0 ]
  then
    usage
else
  NODE="$1"
  if [ -d "nodes/$NODE" ]
    then
      echo "$NODE found"
    else
      usage
  fi
fi

if [ -z "$2" ]
  then
    # check if the ubuntu system-boot volume is already present in the default location
    if [ -f /mnt/d/cmdline.txt ]
      then
        echo "Assuming /mnt/d as the target"
        TARGET_VOLUME="/mnt/d"
      else
        echo "No path given as a target. Call the script with '$0 <some node name> <some target path>' or mount the drive with "
        echo "mount -t drvfs d: /mnt/d"
        echo "assuming sdcard is D: in Windows and not mounted in WSL yet"
        exit 1
    fi
else
  TARGET_VOLUME="$2"
fi

export REPO_ROOT=$(git rev-parse --show-toplevel)
. "$REPO_ROOT"/.env

message "writing $NODE configuration to $TARGET_VOLUME"

echo "copying cmdline.txt to $TARGET_VOLUME/cmdline.txt"
cp -f cmdline.txt "$TARGET_VOLUME/cmdline.txt"
echo "copying nodes/${NODE}/user-data to $TARGET_VOLUME/user-data"
envsubst < "nodes/${NODE}/user-data" > "$TARGET_VOLUME/user-data"