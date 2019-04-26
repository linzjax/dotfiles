#!/bin/bash
set -e

# Enforce that all updates are installed before we begin
function check_macos_updated() {
  echo "Checking if macOS is up to date..."
  if [[ "$(sudo softwareupdate -l 2>&1)" != *"No new software available"* ]]; then
    echo "Updating macOS"
    sudo softwareupdate -i -a
    echo "Reboot your machine now and run this script again afterwards."
    exit 0
  else
    echo "This macOS is up to date."
  fi
}

# function install_xcode() {
#   ### XCode Command Line Tools
#   # thx https://github.com/alrra/dotfiles/blob/ff123ca9b9b/os/os_x/installs/install_xcode.sh
#   if ! xcode-select --print-path &> /dev/null; then
#
#       # Prompt user to install the XCode Command Line Tools
#       xcode-select --install &> /dev/null
#
#       # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#       # Wait until the XCode Command Line Tools are installed
#       until xcode-select --print-path &> /dev/null; do
#           sleep 5
#       done
#
#       print_result $? 'Install XCode Command Line Tools'
#
#       # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#       # Point the `xcode-select` developer directory to
#       # the appropriate directory from within `Xcode.app`
#       # https://github.com/alrra/dotfiles/issues/13
#
#       sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
#       print_result $? 'Make "xcode-select" developer directory point to Xcode'
#
#       # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#       # Prompt user to agree to the terms of the Xcode license
#       # https://github.com/alrra/dotfiles/issues/10
#
#       sudo xcodebuild -license
#       print_result $? 'Agree with the XCode Command Line Tools licence'
#
#   fi
# }

# Install brew and XCode Command Line Tools
function install_brew() {
  if ! command -v brew > /dev/null 2>&1; then
    echo "Installing Brew..."
    printf "\n\n" | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap caskroom/cask
    brew tap caskroom/versions
  else
    echo "Brew already installed."
  fi

  # NVM
  echo 'Installing NVM...'
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
}

function install_brew_packages() {
  mode=$1
  echo "Install new taps from brew.txt"
  comm -23 \
    <(sort ~/code/dotfiles/brew.txt) \
    <(brew ls --full-name) \
    | xargs brew install

  echo "Install new casks from cask.txt"
  comm -23 \
    <(sort ~/code/dotfiles/cask.txt) \
    <(brew cask ls) \
    | xargs brew cask install
}

function install_dotfiles() {
  mkdir -p ~/code
  cd ~/code
  if [ ! -d ~/code/dotfiles ]; then
    echo "Cloning dotfiles repo"
    git clone https://github.com/linzjax/dotfiles
  else
    echo "Updating dotfiles repo"
  fi
  cd ~/code/dotfiles
  ./sync.sh -f
}

function set_defaults() {
  echo "Setting user defaults"

  ###############################################################################
  # General                                                                     #
  ###############################################################################

  defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

  ###############################################################################
  # Screen                                                                      #
  ###############################################################################

  # Require password immediately after sleep or screen saver begins
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0

  # Save screenshots to the desktop
  defaults write com.apple.screencapture location -string "${HOME}/Desktop"

  # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
  defaults write com.apple.screencapture type -string "png"
}

function usage()
{
  cat << EOF
usage: $0 [options]

Set up a fresh Mac or run individual parts of it.

OPTIONS:
  --help|-h       Show this message
  --update|-u     Install macOS updates
  --brew|-b       Install Homebrew, all brew.txt packages and cask.txt
  --dotfiles|-d   Install dotfiles repo or update it
  --defaults|-D   Install default user settings

Without any option it runs the complete setup.
EOF
  exit 1
}

# Main

UPDATE=0
BREW=0
DOTFILES=0
DEFAULTS=0
# translate long options to short
for arg
do
  delim=""
  case "${arg}" in
    --help) args="${args}-h ";;
    --update) args="${args}-u ";;
    --brew) args="${args}-b ";;
    --dotfiles) args="${args}-d ";;
    --defaults) args="${args}-D ";;
    # pass through anything else
    *) [[ "${arg:0:1}" == "-" ]] || delim="\""
      args="${args}${delim}${arg}${delim} ";;
  esac
done
# reset the translated args
eval set -- "$args"
# now we can process with getopt
while getopts ":ubfdDt" opt; do
  case $opt in
    h)  usage ;;
    u)  UPDATE=1 ;;
    b)  BREW=1 ;;
    d)  DOTFILES=1 ;;
    D)  DEFAULTS=1 ;;
    \?) usage ;;
    :)
      echo "option -$OPTARG requires an argument"
      usage
    ;;
  esac
done
shift $((OPTIND -1))

if [ -z "$args" ]; then
  UPDATE=1
  BREW=1
  DOTFILES=1
  DEFAULTS=1
fi

if [ $UPDATE == 1 ]; then check_macos_updated; fi
if [ $BREW == 1 ]; then install_brew; fi
if [ $BREW == 1 ]; then install_brew_packages; fi
if [ $DOTFILES == 1 ]; then install_dotfiles; fi
if [ $DEFAULTS == 1 ]; then set_defaults; fi
