set -e

download_dotfiles() {
    GITHUB_REPOSITORY="se7entyse7en/dotfiles"
    DOTFILES_ORIGIN="git@github.com:$GITHUB_REPOSITORY.git"
    DOTFILES_TARBALL_URL="https://github.com/$GITHUB_REPOSITORY/tarball/master"

    # Download and extract dotfiles repo into a temporary directory
    tmp_file="/tmp/dotfiles.tar.gz"
    echo "Downloading $DOTFILES_TARBALL_URL into $tmp_file..."
    curl -LsSo "$tmp_file" "$DOTFILES_TARBALL_URL" &> /dev/null

    output_dir="/tmp/dotfiles"
    rm -rf "$output_dir" && mkdir "$output_dir"
    echo "Extracting $tmp_file into $output_dir..."
    tar -zxf "$tmp_file" --strip-components 1 -C "$output_dir"

    echo "Entering $output_dir..."
    cd "$output_dir"
}

echo "Disabling gatekeeper..."
sudo spctl --master-disable

download_dotfiles

./keys.sh
./tokens.sh
./xcode.sh
./brew.sh
./rust.sh
./zsh.sh
./git.sh
./google-cloud-sdk.sh
./emacs.sh
./prompt.sh
./github.sh

echo "Opening Hyper and closing Terminal..."
hyper && ps aux | grep Terminal | grep -v grep | tr -s ' ' | cut -f2 -d ' ' | xargs kill -9
