# Configuration

Configs for devices are passed to the script as environment variables.

For more in-depth details (no need to repeat them here) please see the top of
the [prusa-connect-camera.sh](https://github.com/nvtkaszpir/prusa-connect-camera-script/blob/master/prusa-connect-camera.sh).

Short overview of actions:

- ensure printer is up and running and sending status to Prusa Connect
  (otherwise images will be discarded)
- add new camera to the existing printer in Prusa Connect, obtain token
- create config for prusa-connect-camera-script env vars
- test the config
- install script as service
