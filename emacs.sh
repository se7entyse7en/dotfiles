echo "Copying .emacs file..."
cp ./emacs/.emacs ~/

echo "Creating ~/.emacs.d directory..."
mkdir ~/.emacs.d

echo "Copying ~/.emacs.d directory..."
cp -R ./emacs/.emacs.d ~/
