#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

OTA_HOST="$(jq --raw-output '.ota_host' ${CONFIG_PATH})"
OTA_BIN_FILE_PATH="$(jq --raw-output '.ota_bin_file_path' ${CONFIG_PATH})"
OTA_PORT="$(jq --raw-output '.ota_port' ${CONFIG_PATH})"
OTA_PASSWORD="$(jq --raw-output '.ota_password' ${CONFIG_PATH})"

cat > /esphomeflasher.py << EOL
from esphome import espota2
espota2.run_ota("${OTA_HOST}", ${OTA_PORT}, "${OTA_PASSWORD}", "${OTA_BIN_FILE_PATH}")
EOL

echo "Running:"
cat /esphomeflasher.py

# exec python3 /espota.py -i "${OTA_HOST}" -p "${OTA_PORT}" -a "${OTA_PASSWORD}" -f "${OTA_BIN_FILE_PATH}"
exec python3 /esphomeflasher.py