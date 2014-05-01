# ===== Pix Minecraft Functions =====

# Version 01
# First working version
# Includes working colormap function

# ===== Installation Variables =====

PIX_USERNAME=minecraft
PIX_SERVER=vanilla

# ===== Default Values =====

PIX_MSGCOLOR=yellow
PIX_MSGBOLD=false
PIX_BY='[Server]'

PIX_DEBUG=false

# ===== Base Functions =====

function pix_errorexit() {
  echo "${PROG}: ${1:-"Unknown Error"}" 1>&2
  exit 1
}

function pix_debug() {
  PIX_DEBUG=true
}

function pix_send() {
  pix_echo "$1"
  screen -S $PIX_SERVER -p 0 -X stuff "$1\n"
}

function pix_colormap() {
  # Expects two params: variable name to set, color to map from
  # legal output: black, dark_blue, dark_green, dark_aqua, dark_red, dark_purple,
  # gold, gray, dark_gray, blue, green, aqua, red, light_purple, yellow, white
  case "$2" in
    "0" | "black")
      _PIX_RESULT=black
      ;;
    "1" | "dark_blue")
      _PIX_RESULT=dark_blue
      ;;
    "2" | "dark_green")
      _PIX_RESULT=dark_green
      ;;
    "3" | "dark_aqua" | "dark_turqouise" | "dark_cyan")
      _PIX_RESULT=dark_aqua
      ;;
    "4" | "dark_red" | "maroon")
      _PIX_RESULT=dark_red
      ;;
    "5" | "dark_purple" | "purple" | "dark_magenta")
      _PIX_RESULT=dark_purple
      ;;
    "6" | "gold" | "dark_yellow" | "orange")
      _PIX_RESULT=gold
      ;;
    "7" | "gray" | "grey" | "light_gray" | "light_grey" | "silver")
      _PIX_RESULT=gray
      ;;
    "8" | "dark_gray" | "dark_grey" | "charcoal")
      _PIX_RESULT=dark_gray
      ;;
    "9" | "blue" | "light_blue")
      _PIX_RESULT=blue
      ;;
    "a" | "A" | "green" | "light_green")
      _PIX_RESULT=green
      ;;
    "b" | "B" | "aqua" | "turquoise" | "cyan" | "light_aqua" | "light_turquoise" | "light_cyan")
      _PIX_RESULT=aqua
      ;;
    "c" | "C" | "red" | "light_red")
      _PIX_RESULT=red
      ;;
    "d" | "D" | "light_purple" | "magenta" | "pink" | "light_magenta" | "light_pink")
      _PIX_RESULT=light_purple
      ;;
    "e" | "E" | "yellow" | "light_yellow")
      _PIX_RESULT=yellow
      ;;
    "f" | "F" | "white")
      _PIX_RESULT=white
      ;;
    *)
      pix_errorexit "$2 is not a recognized color."
      ;;
  esac
  
  local _PIX_RETURNVAR=$1
  eval $_PIX_RETURNVAR="'$_PIX_RESULT'"
}

function pix_set() {
  pix_echo "pix_set $1 $2"
  case "$1" in
    "by")
      PIX_BY="[$2]"
      ;;
    "msgcolor")
      pix_colormap PIX_MSGCOLOR $2
      ;;
    "msgbold")
      PIX_MSGBOLD=$2
      ;;
    *)
      pix_errorexit "$1 is not a recognized variable."
      ;;
  esac
}

function pix_echo() {
  if [ $PIX_DEBUG = "true" ]; then
    echo $1
  fi
}

# ===== Sending Messages to Players Ingame =====

function pix_msg() {
  COM='tellraw @a {text:"'"$PIX_BY $1"'",color:'$PIX_MSGCOLOR',bold:'$PIX_MSGBOLD'}'
  pix_send "$COM"
}

function pix_say() {
  pix_send "say $1"
}

# ====== Enabling and Disabling Save ======

function pix_disablesave() {
  if pgrep -u $PIX_USERNAME -f $PIX_SERVER > /dev/null
  then
    # Server is running. Disable saving.
    pix_msg "Disabling save."
    pix_send "save-off"
    pix_send "save-all"
    sync
    sleep 10
  else
    pix_errorexit "$PIX_SERVER is not running. Not disabling save."
  fi
}

function pix_enablesave() {
  if pgrep -u $PIX_USERNAME -f $PIX_SERVER > /dev/null
  then
    # Server is running. Enable saving.
    pix_msg "Enabling save."
    pix_send "save-on"
  else
    pix_errorexit "$PIX_SERVER is not running. Not enabling save."
  fi
}
