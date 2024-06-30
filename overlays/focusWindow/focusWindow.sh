# This is a simple shell script that makes hyprland focus on different windows
# It takes to arguments $1 is the class of the window we want to focus 
# (Eg. of classes: firefox or com.github.flxtz.rnote. (See "hyprctl clients"))
# $2 is optional and the command that is run if no window with that class is found
# If there are multiple winows that have the same class a tofi is used to make the user pick
# Which window should be focused

window_name=$1
program_name=$2

# Find all windows with the class as specified by $1

titles=$(hyprctl clients -j | jq -r ".[] | select (.class == \"$window_name\" ) | \"\\(.title) (\\(.address))\"")

# Count the amount of windows with that class
line_count=$(echo "$titles" | wc -l)

# If no winwos match run $2 and exit
if [ -z "$titles" ]; then
  eval "$program_name"
  exit
fi

if [ "$line_count" -gt 1 ]; then
  # If multiple windows match make the user pick one with tofi
  title=$(echo "$titles" | rofi)
else 
  # If only one window matches pick that one
  title=$titles
fi

# Extract the address, (which  can be used as an identifier)
address=$(echo "$title" | rg -o '\((0x[0-9a-f]{7})\)' -r '$1')

# Focus the selected window
hyprctl dispatch focuswindow address:"$address"

# A way to grab the workspace id of the process not needed anymore
# workspace_id=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$address\") | .workspace.id")
