Command to install oh-my-zsh.

This styles the terminal and provides git branch information.
```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Command to install homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then
```
brew install npm nvm gh
```

Set up python
```
npm cat .
```

Set up github
```
gh auth login
git config --global user.email "linzjax@gmail.com"
git config --global user.name "Lindsey Jacks"
```

Note that the __git file needs to live in .zsh/functions/__git
