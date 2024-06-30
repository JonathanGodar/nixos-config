classes=$(hyprctl clients -j | jq -r '.[].class' | sort | uniq)
chosen_class=$(echo "$classes" | rofi -dmenu)

focusWindow "$chosen_class" ""
