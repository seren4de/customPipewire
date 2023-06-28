#!/bin/bash

# update to remote repo
cd $HOME/pipewire/ && git pull

# rebuild with ninja incase there are any changes
cd $HOME/pipewire/builddir/ && ninja

# Stop pipewire services
systemctl --user stop pipewire.service \
                      pipewire.socket \
                      pipewire-media-session.service \
                      pipewire-pulse.service \
                      pipewire-pulse.socket

# Change directory to the build directory and set the PIPEWIRE_DEBUG environment variable and run make
cd $HOME/pipewire/builddir/ && PIPEWIRE_DEBUG="D" make run

#log
echo "$(date) - Running pipewire_server.sh" >> $HOME/pipewire_server.log
