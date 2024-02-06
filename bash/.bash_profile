# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Homebrew
export PATH="/usr/local/bin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{bash_prompt,env,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

for file in ~/.{git-completion.sh,git-integration.sh,git-prompt.sh}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

function start_agent {
    echo "Initialising new SSH agent..."
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519
}

start_agent;

# init rvm
if [ -e $HOME/.rvm/scripts/rvm ]; then
  source ~/.rvm/scripts/rvm
fi

# NVM
if [[ "$OSTYPE" == "darwin"*  ]]; then
  export PATH="/usr/local/opt/node@10/bin:$PATH"
fi
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh # This loads NVM

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
