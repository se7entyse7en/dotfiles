# Install Homebrew if not present
echo "Checking if Homebrew already present..."
if ! which -s brew; then
    # Install Homebrew
    echo "Downloading and installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Make sure we're using the latest Homebrew
echo "Updating Homebrew..."
brew update

# Upgrade any already-installed formulae
echo "Upgrading Homebrew..."
brew upgrade

echo "Installing formulae..."
grep -v "#" brew/formulae.txt | xargs brew install

# Required for installing font-fira-code
brew tap homebrew/cask-fonts

echo "Installing casks..."
grep -v "#" brew/casks.txt | xargs brew install --cask

# Check if everything is ok
echo "Checking if brew is fine..."
brew doctor
