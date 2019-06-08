#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

ALIAS="$(jq --raw-output '.alias' ${CONFIG_PATH})"
PRIVATE_KEY="$(jq --raw-output '.private_key' ${CONFIG_PATH})"
SERVER="$(jq --raw-output '.server' ${CONFIG_PATH})"
DOMAIN="$(jq --raw-output '.domain' ${CONFIG_PATH})"
PORT1FROM="$(jq --raw-output '.port1from' ${CONFIG_PATH})"
PORT1TO="$(jq --raw-output '.port1to' ${CONFIG_PATH})"
PORT2FROM="$(jq --raw-output '.port2from' ${CONFIG_PATH})"
PORT2TO="$(jq --raw-output '.port2to' ${CONFIG_PATH})"
PORT3FROM="$(jq --raw-output '.port3from' ${CONFIG_PATH})"
PORT3TO="$(jq --raw-output '.port3to' ${CONFIG_PATH})"
RETRY_TIME="$(jq --raw-output '.retry_time' ${CONFIG_PATH})"


IDENTITY=""
if [[ "${PRIVATE_KEY}" != "" ]]
then
    echo "${PRIVATE_KEY}" >> /private_key
    chmod 600 /private_key
    IDENTITY="-i /private_key"
fi


if [ "${DOMAIN}" == "" ]
then
    DOMAIN="${ALIAS}.${SERVER}"
fi

PORT1="-R ${DOMAIN}:${PORT1TO}:localhost:${PORT1FROM}"
PORT2=""
PORT3=""


if [ "${PORT2FROM}" != "0" ] && ["${PORT2TO}" != "0"]
then
    PORT2=" -R ${DOMAIN}:${PORT2TO}:localhost:${PORT2FROM}"
fi

if [ "${PORT3FROM}" != "0" ] && ["${PORT3TO}" != "0"]
then
    PORT3=" -R  ${DOMAIN}:${PORT3TO}:localhost:${PORT3FROM}"
fi

CMD="/bin/bash -c 'sleep ${RETRY_TIME} && ssh ${IDENTITY} -tt -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no -o ServerAliveInterval=10 -o ServerAliveCountMax=3 ${PORT1}${PORT2}${PORT3} ${ALIAS}@${SERVER}'"

echo "Running '${CMD}' through supervisor!"

cat > /etc/supervisor-docker.conf << EOL
[supervisord]
user=root
nodaemon=true
logfile=/dev/null
logfile_maxbytes=0
EOL
cat >> /etc/supervisor-docker.conf << EOL
[program:serveo]
command=${CMD}
autostart=true
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true
EOL

exec supervisord -c /etc/supervisor-docker.conf
