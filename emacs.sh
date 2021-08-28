set -e

# Configure emacs
echo "Copying .emacs file..."
cp ./emacs/.emacs ~/

echo "Creating ~/.emacs.d directory..."
mkdir ~/.emacs.d

echo "Copying ~/.emacs.d directory..."
cp -R ./emacs/.emacs.d ~/

echo "Copying .authinfo.gpg file..."
cp ./emacs/.authinfo.gpg ~/
