#!/usr/bin/env bash

if [ "$1" == "" ]; then
  echo "Usage: $0 <domain>"
  exit 1
fi

SERVER=$1

# Step 1: Launch Homer in a new tab
kitty @ launch --type=tab --tab-title="Simpsons Demo" \
  bash -c "watch curl -s -k https://homer-simpson.${SERVER}/demo"

sleep 0.5

# Step 2: Selma to the right (top-right)
kitty @ launch --tab-index=last --location=vsplit \
  bash -c "watch curl -s -k https://selma-bouvier.${SERVER}/demo"

sleep 0.5

# Step 3: Marge below Homer (bottom-left)
kitty @ launch --tab-index=last --location=hsplit \
  bash -c "watch curl -s -k https://marge-simpson.${SERVER}/demo"

sleep 0.5

# Step 4: Patty to the right of Marge (bottom-right)
kitty @ launch --tab-index=last --location=neighbor \
  bash -c "watch curl -s -k https://patty-bouvier.${SERVER}/demo"
