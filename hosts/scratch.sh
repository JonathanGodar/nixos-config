if [[ $exitStatus -eq 0 ]]; then
  notify-send -t 0 "Backup done"
else
  notify-send -u critical -t 0 "Backup failed" "Backup job exited with status $exitStatus"
fi
