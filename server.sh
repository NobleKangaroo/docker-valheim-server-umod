#!/usr/bin/env bash
# Source .profile for .NET and uMod paths
. ~/.profile

# Server settings and default values
SERVER_NAME="${SERVER_NAME:-Valheim Server}"
SERVER_PASSWORD="${SERVER_PASSWORD:-secret}"
SERVER_PORT=${SERVER_PORT:-2456}
SERVER_WORLD="${SERVER_WORLD:-Valheim}"

# Valheim server x86_64 library path
export LD_LIBRARY_PATH=/opt/valheim/server/linux64:${LD_LIBRARY_PATH}

# Update or install the server
echo "Installing Valheim"
umod update valheim --dir=/opt/valheim/server -P \
    || umod install valheim --dir=/opt/valheim/server -P
chmod +x /opt/valheim/server/valheim_server.x86_64

# Start the server as a background job
echo "Starting server:"
echo "    Name    : ${SERVER_NAME}"
echo "    Password: ${SERVER_PASSWORD}"
echo "    Port    : ${SERVER_PORT}"
echo "    World   : ${SERVER_WORLD}"
cd /opt/valheim/server
./valheim_server.x86_64 \
    -name "${SERVER_NAME}" \
    -password "${SERVER_PASSWORD}" \
    -port ${SERVER_PORT} \
    -world "${SERVER_WORLD}" \
    -savedir "/opt/valheim/data" \
    -public 1 \
    -batchmode \
    -nographics \
    > >(tee -a "/opt/valheim/data/${SERVER_WORLD}.log") &

# Trap SIGTERM and perform safe shutdown
trap "kill -s SIGINT $!; wait" SIGTERM

# Wait for the job to end
wait $!

