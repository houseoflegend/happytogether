tell application "iTunes"
    set search_results to (every file track of playlist "Library" whose artist is "__artistName__" and name is "__trackName__" and album is "__albumName__")
    play item 1 of search_results
    set player position to __playPosition__
end tell
