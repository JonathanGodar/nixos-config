searchTerm=$(rofi -dmenu)
urlEncodedSearchTerm=$(jq -nr --arg v "$searchTerm" '$v|@uri')
chromium --app="https://mynixos.com/search?q=$urlEncodedSearchTerm" 
