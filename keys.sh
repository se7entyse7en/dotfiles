set -e

echo "Ensuring existence of ~/.ssh directory..."
mkdir -p ~/.ssh

key_already_present=$(ls ~/.ssh/ | grep "id_rsa" || true)
if [ -z "$key_already_present" ]; then
    echo "Key pair not present."
    while [ -z "$key_path" ]; do
        echo "Type the path of the location of the key pair"
        read key_path
    done

    # Copy key pair from the inserted path
    echo "Copying keys to ~/.ssh/..."
    echo "Copying private key..."
    cp $key_path/id_rsa ~/.ssh/
    echo "Copying public key..."
    cp $key_path/id_rsa.pub ~/.ssh/

else
    echo "Key pair already present."
fi

echo "Copying known_hosts file..."
cp ./known_hosts ~/.ssh/
