# customPipewire
### PipeWire Update and Restart Script

This script updates the PipeWire repository, rebuilds the project, stops the PipeWire services, and runs `make run` to start the PipeWire server.

## Usage

1. Make sure the script is executable by running `chmod +x /path/to/pipewire_server.sh`.
2. Open the crontab for the user that will run the script by running `crontab -e`.
3. Add a new line to the crontab with the following content: `@reboot bash /path/to/pipewire_server.sh`. This will run the script at startup.
4. Save and close the crontab.

## Manually use

1. Make sure the script is executable by running

```
chmod +x /path/to/pipewire_server.sh
```

2. To run the script manually, use the following command:

```
./pipewire_server.sh
```

The script will now run automatically at startup. You can check the log file at `$HOME/pipewire_server.log` to see if the script ran successfully.

## Notes

- Make sure to replace `/path/to/script.sh` with the actual path to the script.
- If you want to run the script as the `root` user, you can open the crontab for `root` by running `sudo crontab -e -u root`.
- Make sure that all environment variables and paths used in the script are set correctly and available to the cron job, especially for root's crontab use the abs path to home.
