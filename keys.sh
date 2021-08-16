# Check if a key is already present
echo "Checking if a key pair is already present..."
key_already_present=$(ls ~/.ssh/ | grep "id_rsa");
if [ -z $key_already_present ]; then
    echo "Key pair not present."
    # Copy key pair from the inserted path
    echo "Type the path of the location of the key pair"
    read key_path

    if [ -z $key_path ]; then
        echo "No path inserted. Skipping."
    else
        echo "Copying keys to ~/.ssh/..."
        echo "Copying private key..."
        cp $key_path/id_rsa ~/.ssh/
        echo "Copying public key..."
        cp $key_path/id_rsa.pub ~/.ssh/
    fi
else
    echo "Key pair already present."
fi
