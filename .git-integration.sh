#!/bin/bash
if [ -e "$HOME/.git-completion.bash" ]; then
	source $HOME/.git-completion.bash
fi
if [ -e "$HOME/.git-prompt.bash" ]; then
	source $HOME/.git-prompt.bash
	# Colorless prompt:
	# export PS1='\u@\h:\w$(__git_ps1 " (branch: %s)")$ '

	# \e[1;32m = Bright green
	# \e[1;34m = Bright blue
	# \e[00m   = Reset colors
	green='\[\e[1;32m\]'
	blue='\[\e[1;34m\]'
	reset='\[\e[00m\]'
	export PS1="${green}\u@\h${reset}:${blue}\w${reset}\$(__git_ps1 ' (branch: %s)')\n👑 🐝  "
fi
