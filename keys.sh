# Copy key pair from the inserted path
echo "Type the path of the location of the key pair"
read key_path

echo "Copying keys to ~/.ssh/..."
echo "Copying private key..."
cp $key_path/id_rsa ~/.ssh/
echo "Copying public key..."
cp $key_path/id_rsa.pub ~/.ssh/
