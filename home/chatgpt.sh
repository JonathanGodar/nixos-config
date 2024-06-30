hyprctl dispatch togglespecialworkspace Chat 

pgrep -f 'asdlfkjasdfl'
active=$(pgrep -f -- '--app=https://chatgpt.com')
if [ -z "$active" ]; then
  chromium --app="https://chatgpt.com" &
fi
