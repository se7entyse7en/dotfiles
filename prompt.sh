set -e

echo "Copying .hyper.js file..."
cp ./prompt/.hyper.js ~/
echo "Copying starship.toml file..."
mkdir -p ~/config
cp ./prompt/starship.toml ~/config/starship.toml
