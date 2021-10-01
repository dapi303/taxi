Vim plugin to switch working directory.

Provides menu to qucikly switch between predefined location.
If you are using multiple repositories and they are grouped in some directories,
provide these locations to this plugin and quickly switch betwen working directiories.

Define locations with g:taxi_directories
e.g.
let g:taxi_directories = [ '/home/u/repos', '/home/u/other-repos' ]

Trigger plugin with shortcut C-x or call 'Taxi' to open buffer with list of available locations,
navigate to element and press enter to explore this location and change working directory to it.

Example: ![Example](/taxi.jpg)
