set -e

GCLOUD_SDK_TARBALL_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-354.0.0-darwin-x86_64.tar.gz"

out="/Users/se7entyse7en/google-cloud-sdk.tar.gz"
echo "Downloading gcloud into $out..."
curl -LsSo "$out" "$GCLOUD_SDK_TARBALL_URL" &> /dev/null
tar -zxf "$out" -C /usr/local/opt
rm ${out}

ln -s /usr/local/opt/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud

echo "Installing gcloud..."
/usr/local/opt/google-cloud-sdk/install.sh --rc-path ~/.zshrc --path-update true --command-completion true --bash-completion true --install-python false -q

echo "Installing gcloud components..."
yes | /usr/local/bin/gcloud components install core gsutil bq kubectl docker-credential-gcr cloud_sql_proxy
