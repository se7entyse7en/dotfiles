echo "Authenticating with Github token..."
gh auth login --with-token < ~/.tokens/github/dotfiles.txt

echo "Cloning repositories for se7entyse7en..."
mkdir -p ~/Projects/se7entyse7en && cd ~/Projects/se7entyse7en
gh repo list se7entyse7en --source -L 1000 --json sshUrl --jq '.[] | .sshUrl' | xargs -L1 git clone
echo "All repositories for se7entyse7en cloned."
