#!/bin/bash

# Welcome
echo 'Server start script initialized...'

# Set the port
PORT=2137

# Kill anything that is already running on that port
echo 'Cleaning port' $PORT '...'
fuser -k 2137/tcp

# Change directories to the release folder
cd build/web/

# Start the server
echo 'Starting server on port' $PORT '...'
python -m http.server $PORT

# Exit
echo 'Server exited...'