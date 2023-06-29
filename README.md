# customPipewire

This repository contains a script for updating and restarting the PipeWire server. It assumes that PipeWire is already built from source.

## PipeWire Update and Restart Script

The `pipewire_server.sh` script automates the process of updating and restarting the PipeWire server. When run, the script performs the following actions:

1. Updates the PipeWire repository to the latest version.
2. Rebuilds the PipeWire project using `ninja`.
3. Stops the PipeWire services.
4. Runs `make run` to start the PipeWire server.

To set up the script to run automatically after login, you can either add it to your `.bashrc` file or create a desktop entry file in the `~/.config/autostart/` directory. For detailed instructions on how to do this, see the [Notes](#notes) section below.

## Usage

1. Clone this repository to your home directory.

2. Make sure the script is executable by running the following command:

    ```bash
    chmod +x $HOME/customPipewire/pipewire_server.sh
    ```

3. To run the script manually, use the following command:

    ```bash
    bash $HOME/customPipewire/pipewire_server.sh
    ```

The script will now run automatically at startup. You can check the log file at `$HOME/pipewire_server.log` to see if the script ran successfully.

## Notes

- To run the script at login, you can add it to your `.bashrc` file by running the following command:

    ```bash
    echo "bash $HOME/customPipewire/pipewire_server.sh" >> $HOME/.bashrc
    ```

- Alternatively, you can create a desktop entry file in the `~/.config/autostart/` directory to run the script when you log in to your desktop environment. To do this, create a new file named `pipewire_server.desktop` in the `~/.config/autostart/` directory with the following contents:

    ```ini
    [Desktop Entry]
    Type=Application
    Exec=bash $HOME/customPipewire/pipewire_server.sh
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
    Name[en_US]=pipewire_server
    Name=pipewire_server
    Comment[en_US]=Run pipewire_server.sh script after login
    Comment=Run pipewire_server.sh script after login
    ```

- **Note:** Do not add the script to your `.profile` file as it could break the shell `DISPLAY` variable.

