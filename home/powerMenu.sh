options=$(cat << EOM
Power off
Reboot
EOM)

chosen=$(echo "$options" | tofi)

if [[ "$chosen" == "Power off" ]]; then
  shutdown now
fi

if [[ "$chosen" == "Reboot" ]]; then
  shutdown -r now
fi
