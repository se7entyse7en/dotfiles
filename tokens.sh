github_token_present() {
    echo $(ls ~/.tokens/github | grep "dotfiles.txt")
}

echo "Ensuring existence of ~/.tokens/github directory..."
mkdir -p ~/.tokens/github/

echo "Checking if a Github token is already present..."
if [ -z "$(github_token_present)" ]; then
    while [ -z "$(github_token_present)" ]; do
        echo "Token file not present."
        echo "Create a file named 'dotfiles.txt' in ~/.tokens/github and press 'Enter'"
        read
    done
    echo "Token file found."
else
    echo "Token already present."
fi
