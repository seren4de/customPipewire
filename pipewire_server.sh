#!/bin/bash

# Define log function
log() {
    echo "$(date) - $1" >> $HOME/pipewire_server.log
}

# update to remote repo
cd $HOME/pipewire/ && git pull

if [ $? -ne 0 ]; then
    log "Failed to update remote repo"
    exit 1
fi

# rebuild with ninja incase there are any changes
cd $HOME/pipewire/builddir/ && ninja

if [ $? -ne 0 ]; then
    log "Failed to rebuild with ninja"
    exit 1
fi

# Stop pipewire services
systemctl --user stop pipewire.service \
                      pipewire.socket \
                      pipewire-media-session.service \
                      pipewire-pulse.service \
                      pipewire-pulse.socket

if [ $? -ne 0 ]; then
    log "Failed to stop pipewire services"
    exit 1
fi

# Change directory to the build directory and set the PIPEWIRE_DEBUG environment variable and run make
cd $HOME/pipewire/builddir/ && PIPEWIRE_DEBUG="D" make run

if [ $? -ne 0 ]; then
    log "Failed to run make"
    exit 1
fi

#log success
log "Running pipewire_server.sh successfully"