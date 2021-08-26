set -e

echo "Installing gcloud components..."
gcloud components install core gsutil bq kubectl docker-credential-gcr cloud_sql_proxy
