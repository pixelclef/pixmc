#!/bin/bash

# ===== Includes and Configure Pix =====

. pixmc.sh
pix_set server uhc

# ===== Variables =====

PLAYER=VibeRaider

XMIN=-500
XMAX=500
Y=128
ZMIN=-500
ZMAX=500
DELTA=100

# ===== Functions =====

function generate() {
  for (( X = $XMIN; X <= $XMAX; X += $DELTA )); do
    for (( Z = $ZMIN; Z <= $ZMAX; Z += $DELTA)); do
      pix_send "tp $PLAYER $X $Y $Z"
      sleep 1
    done
  done
}

# ===== Begin =====

echo "Beginning generation loop."
generate
echo "Generation complete."