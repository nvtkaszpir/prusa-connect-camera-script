# Configuration Overview

Short overview of actions:

* ensure printer is up and running and sending status to Prusa Connect
  (otherwise images will be discarded)
* [add new camera](./prusa.connect.md) to the existing printer in Prusa Connect,
  obtain token and generate fingerprint
* create config for prusa-connect-camera-script [env vars](./config.for.camera.md)
* [test the config](./test.config.md)
* install script as systemd [service](./service.systemd.md)
* [tuning config](./configuration.tuning.md)
