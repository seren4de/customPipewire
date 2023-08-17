#!/bin/bash

# Get the directory path of the script
script_dir="$(dirname "$(readlink -f "$0")")"

# Define the log file path
log_file="$script_dir/pipewire_server.log"

# Check if the log file exists
if [ -f "$log_file" ]; then
    # Delete the log file
    rm "$log_file"

    # Check if the log file was successfully deleted
    if [ $? -ne 0 ]; then
        echo "Failed to delete $log_file"
        exit 1
    fi
fi

# Create a new log file
touch "$log_file"

# Check if the log file was successfully created
if [ $? -ne 0 ]; then
    echo "Failed to create $log_file"
    exit 1
fi

# Define log function
log() {
    echo "$(date) - $1" >> "$script_dir/pipewire_server.log"
}

# Define function to add timestamp to command output and write to log file
log_output() {
    while read -r line; do
        echo "$(date) - $line" >> "$script_dir/pipewire_server.log"
    done
}

# update to remote repo
cd $HOME/pipewire/ && git pull | log_output

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    log "Failed to update remote repo"
    exit 1
fi

# rebuild with ninja incase there are any changes
cd $HOME/pipewire/builddir/ && ninja | log_output

if [ ${PIPESTATUS[1]} -ne 0 ]; then
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
cd $HOME/pipewire/builddir/ && log "Running pipewire server" && PIPEWIRE_DEBUG="D" make run >> $script_dir/pipewire_server.log 2>&1 

if [ $? -ne 0 ]; then
    log "Failed to run make"
    exit 1
fi

