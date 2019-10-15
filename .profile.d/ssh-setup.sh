#!/bin/bash
echo $0: creating public and private key files

# Create the .ssh directory
mkdir -p ${HOME}/.ssh
chmod 700 ${HOME}/.ssh

# Create the public and private key files from the environment variables.
echo "${HEROKU_PUBLIC_KEY}" > ${HOME}/.ssh/heroku_id_rsa.pub
chmod 644 ${HOME}/.ssh/heroku_id_rsa.pub

# Note use of double quotes, required to preserve newlines
echo "${HEROKU_PRIVATE_KEY}" > ${HOME}/.ssh/heroku_id_rsa
chmod 600 ${HOME}/.ssh/heroku_id_rsa

# Start the SSH tunnel if not already running
SSH_CMD="ssh -o StrictHostKeyChecking=no -f -i ${HOME}/.ssh/heroku_id_rsa -N -L 5433:${REMOTE_DB_WHATSGOOD}:5432 -L 5434:${REMOTE_DB_ANALYTICS}:5432 ${TUNNEL_USER}@${TUNNEL_HOST}"

PID=`pgrep -f "${SSH_CMD}"`
if [ $PID ] ; then
    echo $0: tunnel already running on ${PID}
else
    echo $0 launching tunnel
    $SSH_CMD
fi
