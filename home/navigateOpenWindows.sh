classes=$(hyprctl clients -j | jq -r '.[].class' | sort | uniq)
chosen_class=$(echo "$classes" | tofi)

focusWindow "$chosen_class" ""
