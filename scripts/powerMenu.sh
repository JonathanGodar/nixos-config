options=$(cat << EOM
Power off
Reboot
Suspend
EOM)

chosen=$(echo "$options" | rofi -dmenu)

if [[ "$chosen" == "Power off" ]]; then
  shutdown now
fi

if [[ "$chosen" == "Reboot" ]]; then
  shutdown -r now
fi

if [[ "$chosen" == "Suspend" ]]; then
  systemctl suspend
fi
