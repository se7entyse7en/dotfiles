set -e

# Configure emacs
echo "Copying .emacs file..."
cp ./emacs/.emacs ~/

echo "Ensuring existence of ~/.emacs.d directory..."
mkdir -p ~/.emacs.d

echo "Copying ~/.emacs.d directory..."
cp -R ./emacs/.emacs.d ~/

echo "Copying .authinfo.gpg file..."
cp ./emacs/.authinfo.gpg ~/
