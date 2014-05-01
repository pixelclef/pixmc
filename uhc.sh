#!/bin/bash

# Version 08
# Enabled spreadplayers

# Version 07
# Stubbed in final spreadplayers, still on msg
# Added time echo on periods

# Version 06
# Added clear and spreadplayers stubs
# Added pregame echo

# Version 05
# Early morning tweaks and tests

# Version 04
# Trialing improved counter
# Checking for recovery parameter

# Version 03
# Stubbed in end of game messaging
# Disabled verbose console

# Version 02
# Added basic pregame and startgame functions
# Stubbed in command placeholders

# ===== Variables =====

SERVER=uhc
BY='[Contingency UHC S4]'

PLENGTH=20
PMAX=9
VCHECK=false

# ===== Functions =====

function error_exit() {
  echo "${PROG}: ${1:-"Unknown Error"}" 1>&2
  exit 1
}

function send() {
  screen -S $SERVER -p 0 -X stuff "$1\n"
}

function msg() {
  COM='tellraw @a {text:"'"$BY $1"'",color:gold,bold:true}'
  screen -S $SERVER -p 0 -X stuff "$COM\n"
}

function period() {
  echo Period $1 has started at `date +%T`
  case "$1" in
    0)
      msg "Good luck!"
      ;;
    $PMAX)
      msg "Please get to 0,0 for the final showdown!"
      ;;
    *)
      msg "$TMIN minutes!"
      ;;
  esac
}

function check() {
  NOW=`date +%s`
  TSEC=$(($NOW-$START))
  TMIN=$(($TSEC/60))
  TPER=$(($TMIN/$PLENGTH))
  RMIN=$(($TMIN%$PLENGTH))

  if [ $RMIN -eq 0 ]; then
    echo " "
    period $TPER
  fi

  if [ $VCHECK == "true" ]; then
    echo $TSEC total seconds have elapsed.
    echo $TMIN total minutes have elapsed.
    echo $TPER total periods have elapsed.

    echo $TPER periods and $RMIN minutes in.
  else
    if [ $RMIN -lt 10 ]; then
      echo -n 0
    fi
    echo -n "$RMIN "
  fi
}

function pregame() {
  echo "Starting pregame countdown"
  send "gamerule naturalRegeneration false"
  send "weather clear 60"
  # send "effect @a 6 30 10"
  send "effect @a 23 30 10"
  send "gamemode 0 @a"
  send "clear @a"
  send "spreadplayers 0 0 400 500 true @a"
  msg "The match will begin in 30 seconds!"
  sleep 25

  msg "5 seconds!"
  sleep 1
  msg "4 seconds!"
  sleep 1
  msg "3 seconds!"
  sleep 1
  msg "2 seconds!"
  sleep 1
  msg "1 second ..."
  sleep 1

  send "effect @a 6 1 10"
  msg "Game begins now!"
}

function startgame() {
  # if a param was passed, use it as start time
  TPARAM=0
  if [ $# -ne 0 ]; then
    msg "Time starting at $1 minutes in!"
    TPARAM=$1
  fi

  send "difficulty 3"
  send "time set $(($TPARAM * 1200))"
  send "gamerule doDaylightCycle true"

  START=$((`date +%s` - ($TPARAM * 60)))
  echo "Game started at $START `date +%s` - $(($TPARAM * 60))"
  echo "Server time is `date +%T`"
  echo Type Ctrl-C to stop
  TMIN=$TPARAM

  # check loop every minute
  while [ $TMIN -lt $(($PLENGTH * $PMAX)) ]; do
    check
    sleep 60
  done
}

# ===== Begin =====

if [ $# -eq 0 ]; then
  pregame
  startgame
else
  startgame $1
fi
