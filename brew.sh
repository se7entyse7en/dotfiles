# Install Homebrew if not present
echo "Checking if Homebrew already present..."
if ! which -s brew; then
    # Install Homebrew
    echo "Downloading and installing Homebrew..."
    yes | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we're using the latest Homebrew
echo "Updating Homebrew..."
brew update

# Upgrade any already-installed formulae
echo "Upgrading Homebrew..."
brew upgrade

echo "Installing some core packages..."
# GNU core utilities
brew install coreutils
brew install moreutils
# GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils
# GNU `sed` `g`-prefixed
brew install gnu-sed

brew install wget
brew install htop
brew install git --without-completions
brew install jq
brew install ack
brew install nginx

# zsh
echo "Installing zsh..."
brew install zsh
brew install zsh-completions

# Tapping taps
echo "Tapping caskroom/cask..."
brew tap caskroom/cask
echo "Tapping homebrew/science..."
brew tap homebrew/science

echo "Installing dev packages from caskroom/cask..."
brew cask install emacs
brew cask install gas-mask
brew cask install java
brew cask install karabiner
brew cask install rstudio
brew cask install vagrant
brew cask install virtualbox
brew cask install xquartz

echo "Installing some extra dev packages..."
brew install node  # Requires java
brew install scala
brew install sbt

echo "Installing packages from homebrew/science..."
brew install octave

if ! grep -Fxq "setenv(\"GNUTERM\", \"X11\")" /usr/local/share/octave/site/m/startup/octaverc; then
    echo "setenv(\"GNUTERM\", \"X11\")" >> /usr/local/share/octave/site/m/startup/octaverc
fi

echo "Installing utils packages from caskroom/cask..."
brew cask install adobe-acrobat
brew cask install duet
brew cask install ghost
brew cask install slack
brew cask install vlc

GOOGLE_CHROME_INSTALLED=$(brew cask ls --versions google-chrome 2> /dev/null)
LASTPASS_INSTALLED=$(brew cask ls --versions lastpass 2> /dev/null)
UTORRENT_INSTALLED=$(brew cask ls --versions utorrent 2> /dev/null)

brew cask install google-chrome
brew cask install lastpass  # Requires running the installer
brew cask install utorrent  # Requires running the installer

# Check if everything is ok
echo "Checking if brew is fine..."
brew doctor

# Finalize installation of packages requiring to run installer
if [ -z "$GOOGLE_CHROME_INSTALLED" ]; then
    echo "Launching Chrome for the first time... Close it when done."
    open -W /Applications/Google\ Chrome.app/  # Lastpass requires opening
                                               # Google Chrome first in order
                                               # to install the plugin on it
fi

if [ -z "$LASTPASS_INSTALLED" ]; then
    echo "Launching Lastpass for the first time... Close it when done."
    open -W /usr/local/Caskroom/lastpass/latest/LastPass\ Installer.app/
fi

if [ -z "$UTORRENT_INSTALLED" ]; then
    echo "Launching uTorrent for the first time... Close it when done."
    open -W /usr/local/Caskroom/utorrent/latest/uTorrent.app/
fi
