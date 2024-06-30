hyprctl dispatch togglespecialworkspace Chat 

active=$(pgrep -f -- '--app=https://chatgpt.com')
if [ -z "$active" ]; then
  chromium --app="https://chatgpt.com" &
fi
