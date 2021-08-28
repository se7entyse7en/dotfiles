set -e

GCLOUD_SDK_TARBALL_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-354.0.0-darwin-x86_64.tar.gz"

tmp_file="/tmp/google-cloud-sdk.tar.gz"
echo "Downloading gcloud into $tmp_file..."
curl -LsSo "$tmp_file" "$GCLOUD_SDK_TARBALL_URL" &> /dev/null
tar -zxf "$tmp_file" -C /tmp

echo "Installing gcloud..."
/tmp/google-cloud-sdk/install.sh --rc-path ~/.zshrc --path-update true --command-completion true --bash-completion true --install-python false -q

echo "Installing gcloud components..."
gcloud components install core gsutil bq kubectl docker-credential-gcr cloud_sql_proxy
