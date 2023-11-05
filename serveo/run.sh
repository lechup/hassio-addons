#!/bin/bash
set -e

CONFIG_PATH="/data/options.json"

SERVER=$(jq --raw-output '.server' "$CONFIG_PATH")
PRIVATE_KEY=$(jq --raw-output '.private_key' "$CONFIG_PATH")
SSH_PORT=$(jq --raw-output '.ssh_port' "$CONFIG_PATH")
RETRY_TIME=$(jq --raw-output '.retry_time' "$CONFIG_PATH")

IDENTITY=""
if [[ -n "$PRIVATE_KEY" ]]; then
    echo "$PRIVATE_KEY" > /private_key
    chmod 600 /private_key
    IDENTITY="-i /private_key"
fi

SSH_PORT_PARAM=""
if [ "$SSH_PORT" -ne 0 ]; then
    SSH_PORT_PARAM="-p $SSH_PORT"
fi

# Create supervisor configuration
cat > /etc/supervisor-docker.conf << EOL
[supervisord]
user=root
nodaemon=true
logfile=/dev/null
logfile_maxbytes=0
EOL

# Iterate over the exposed_ports array and create separate commands
exposed_ports=$(jq '.exposed_ports' "$CONFIG_PATH")

for port in $(echo "$exposed_ports" | jq -c '.[]'); do
    DOMAIN=$(echo "$port" | jq -r '.domain')
    ALIAS=$(echo "$port" | jq -r '.alias')
    FROM=$(echo "$port" | jq -r '.from')
    TO=$(echo "$port" | jq -r '.to')

    if [ -z "$DOMAIN" ] || [ -n "$DOMAIN" ]; then
        DOMAIN="${ALIAS}.${SERVER}"
    fi

    CMD="/bin/bash -c 'sleep $RETRY_TIME && ssh $IDENTITY -tt -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no -o ServerAliveInterval=10 -o ServerAliveCountMax=3 -o HostKeyAlgorithms=+ssh-rsa -R ${DOMAIN}:${TO}:localhost:${FROM} $ALIAS@$SERVER $SSH_PORT_PARAM'"

    echo "Running '$CMD' through Supervisor!"

    cat >> /etc/supervisor-docker.conf << EOL
[program:serveo_${ALIAS}_${FROM}_to_${TO}]
command=$CMD
autostart=true
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true
EOL
done

exec supervisord -c /etc/supervisor-docker.conf
