hyprctl dispatch togglespecialworkspace Chat 

pgrep -f 'asdlfkjasdfl'
active=$(pgrep -f -- '--app=https://chatgpt.com')
if [ -z "$active" ]; then
  brave --app="https://chatgpt.com" &
fi
