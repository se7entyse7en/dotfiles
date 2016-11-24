# Configure emacs
echo "Copying .emacs file..."
cp ./emacs/.emacs ~/

echo "Creating ~/.emacs.d directory..."
mkdir ~/.emacs.d

echo "Copying ~/.emacs.d directory..."
cp -R ./emacs/.emacs.d ~/

# Install elpy dependencies
echo "Installing python dependencies for elpy..."
pip install jedi
pip install flake8
pip install importmagic
