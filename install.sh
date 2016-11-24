GITHUB_REPOSITORY="se7entyse7en/dotfiles"
DOTFILES_ORIGIN="git@github.com:$GITHUB_REPOSITORY.git"
DOTFILES_TARBALL_URL="https://github.com/$GITHUB_REPOSITORY/tarball/master"

# Download and extract dotfiles repo into a temporary directory
tmpFile="/tmp/dotfiles.tar.gz"
echo "Downloading $DOTFILES_TARBALL_URL into $tmpFile..."
curl -LsSo "$tmpFile" "$DOTFILES_TARBALL_URL" &> /dev/null

outputDir="/tmp/dotfiles"
mkdir "$outputDir"
echo "Extracting $tmpFile into $outputDir..."
tar -zxf "$tmpFile" --strip-components 1 -C "$outputDir"

echo "Entering $outputDir..."
cd "$outputDir"

./keys.sh
./brew.sh
./zsh.sh
./git.sh
./xcode.sh
./conda.sh
./emacs.sh

env zsh
