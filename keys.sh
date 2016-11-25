# Check if a key is already present
echo "Checking if a key pair is already present..."
keyAlreadyPresent=$(ls ~/.ssh/ | grep "id_rsa");
if [ -z "$keyAlreadyPresent" ]; then
    echo "Key pair not present."
    echo "Checking if there's any external volume mounted to copy the keys from..."
    externalVolumePresent=$(ls /Volumes/ | grep -v "Primary");
    # Check if an external volume is present
    if [ -z externalVolumePresent ]; then
        echo "No external volume present."
    else
        echo "External volume present."
        # Copy key pair from the inserted path
        echo "Type the path of the location of the key pair"
        read keyPath

        if [ -z keyPath ]; then
            echo "No path inserted. Skipping."
        else
            echo "Copying keys to ~/.ssh/..."
            echo "Copying private key..."
            cp $key_path/id_rsa ~/.ssh/
            echo "Copying public key..."
            cp $key_path/id_rsa.pub ~/.ssh/
        fi
    fi
else
    echo "Key pair already present."
fi
