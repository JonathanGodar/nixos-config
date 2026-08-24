options=$(cat << EOM
Power off
Reboot
Suspend
Logout
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

if [[ "$chosen" == "Logout" ]]; then
  loginctl kill-user $(whoami) 
fi
