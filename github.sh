set -e

echo "Authenticating with Github token..."
gh auth login --with-token < ~/.tokens/github/dotfiles.txt

gh_users=(${GH_USERS:-se7entyse7en})
base_path="/Users/se7entyse7en/Projects/"
for gh_user in "${gh_users[@]}"
do
    path="$base_path$gh_user"
    echo "Cloning repositories for $gh_user in $path..."
    mkdir -p "$path" && cd "$path"
    gh repo list "$gh_user" --source -L 1000 --json sshUrl --jq '.[] | .sshUrl' | xargs -L1 git clone || true
    echo "All repositories for $gh_user cloned."
done
