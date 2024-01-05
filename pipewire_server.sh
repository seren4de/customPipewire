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

# Find the pipewire git repository anywhere in the home directory
pipath=$(find ~/ -type d -name pipewire -exec test -e '{}/.git' ';' -print | head -1)

echo $pipath
# update to remote repo
cd $pipath && git pull | log_output

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    log "[-] pulling remote failed"
    exit 1
fi

# clean before build
ninja -C builddir clean | log_output

if [ ${PIPESTATUS[1]} -ne 0 ]; then
    log "[-] clean with ninja failed"
    exit 1
fi

# rebuild with meson incase there are any changes
cd $pipath && meson setup builddir | log_output

if [ ${PIPESTATUS[1]} -ne 0 ]; then
    log "[-] rebuild with meson failed"
    exit 1
fi

# invoke the build
cd $pipath && meson compile -C builddir | log_output

if [ ${PIPESTATUS[1]} -ne 0 ]; then
    log "[-] compilation with meson failed"
    exit 1
fi

# Stop pipewire services
systemctl --user stop pipewire.service \
                      pipewire.socket \
                      pipewire-media-session.service \
                      pipewire-pulse.service \
                      pipewire-pulse.socket

if [ $? -ne 0 ]; then
    log "[-] failed to stop pipewire services"
    exit 1
fi

# Change directory to the build directory and set the PIPEWIRE_DEBUG environment variable and run make
cd $pipath/builddir/ && log "Running pipewire server" && PIPEWIRE_DEBUG="D" make run >> $script_dir/pipewire_server.log 2>&1 

if [ $? -ne 0 ]; then
    log "[-] failed to make"
    exit 1
fi

