# Troubleshooting

Things to check if it does not work.

## General

- some USB cameras require physical unplung/plug-in AFTER
  the Rasberry Pi was turned on, there is no fix for this yet, see
  [raspberrypi/linux/issues/6255](https://github.com/raspberrypi/linux/issues/6255)
  for such example

- check `/dev/shm/camera_*.stdout` and `/dev/shm/camera_*.stderr`
  files for more details - if they still that 'everything is okay'
  then probably you have issues with permissions when running script
  for the second time (see below)

- if you use feature to ping the printer then ensure printer is up and running
  and responds to ping, or just disable the feature (set `PRINTER_ADDRESS=""` or
  to `PRINTER_ADDRESS=127.0.0.1`)

- check if the camera actually works - check cables if they are not damaged,
  if the cables are properly plugged, if the camera connects to the network...

- check if the camera supports passed parameters such as resolution and codec,
  especially after replacing the camera - see [tuning](./configuration.tuning.md)
  how to use `v4l2-ctl` to see available camera options.

- check if any other app is not accessing the camera - especially local cameras
  are locked by another processes.

  If another application is accessing camera then unfortunately **only one app can
  access the camera** and you must decide which app to run.

  This means if you have something like Klipper/Obico/PrusaLink/motioneye/frigate
  (and so on) accessing the directly attached device to the Raspberry Pi
  then it will not work.

  In such case you can try to find the process
  using `fuser` package, assuming `/dev/video0` is your camera:

  ```shell
  sudo apt install -y psmisc
  fuser /dev/video0
  ```

  See [StackOverflow](https://stackoverflow.com/questions/24554614/how-find-out-which-process-is-using-a-file-in-linux)
  for more details.

  In general you [could create a loopback camera device](https://forums.raspberrypi.com/viewtopic.php?t=121901)
  but this is quite a lot of work to do.

- check IP/domain names for remote camera - try that you can access camera over
  IP address, otherwise you have a [DNS issues](https://www.reddit.com/r/homelab/comments/5i6kza/a_haiku_about_dns/).

- file permissions - check files under `/dev/shm/camera*` and `/dev/video0`

  ```shell
  ls -la /dev/shm/camera* /dev/video*
  ```

  and compare them with the current user executing the script or the user that
  is running docker (see below) or systemd service (see section below).

  The quickest fix is just to delete files in `/dev/shm/camera_*`
  to fix only specific permission issues:

  ```shell
  sudo systemctl stop prusa-connect-camera@env.service
  sudo rm -f /dev/shm/camera_*
  sudo systemctl start prusa-connect-camera@env.service
  ```

  and see if the issue is resolved.

  If you still have issues due to accessing `/dev/video*` then ensure the user
  is added to `video` group.

## Docker troubleshooting

- dockerized script - ensure you restart the pi after adding docker,
  check user permissions to the mounted files and devices (unfortunately this can
  get very messy with direct access to the devices and files on the host)

- check IP/domain names for remote camera - ensure that you can access camera
  over IP address (or fully qualified domain name), because `.local` or `.lan`
  domains are not resolved. Another option is to reconfigure docker to use proper
  local DNS servers and not generic `8.8.8.8`.

  You can also try to run container with [--add-host](https://docs.docker.com/reference/cli/docker/container/run/#add-host)
  or
  [extra_hosts](https://docs.docker.com/compose/compose-file/05-services/#extra_hosts)
  in docker-compose.

  Another option is to run container with [--network="host"](https://docs.docker.com/reference/cli/docker/container/run/#network)
  or
  [network_mode: "host"](https://docs.docker.com/compose/compose-file/05-services/#network_mode)
  in docker-compose.

## Systemd troubleshooting

### Get systemd logs

If the script runs locally but service is not running then you can get the logs
like below, ensure to replace `env` with the name your camera is using:

- stop service

  ```shell
  sudo systemctl stop prusa-connect-camera@env.service
  ```

- open new terminal and type:

  ```shell
  sudo journalctl -f -u prusa-connect-camera
  ```

  and keep it open

- get back to the first terminal and write commands:

  ```shell
  sudo systemctl start prusa-connect-camera@env.service
  sleep 10
  sudo systemctl stop prusa-connect-camera@env.service
  ```

- get back to the terminal with running journalctl and see the logs
  and look carefully at the errors described there

- copy the output from `starting` to the another `starting` command and paste
  on GitHub

### Permissions issues

- check if the user used in systemd file is the same as the one which executed
  test command - and you can edit systemd unit file via `nano` editor

  ```shell
  sudo nano /etc/systemd/system/prusa-connect-camera@.service
  ```

  and replace `User=pi` and `Group=pi` with the current user and group,
  then reload systemd and start service again

  ```shell
  sudo systemctl daemon-reload
  sudo systemctl start prusa-connect-camera@env.service
  ```

  This way it will use your user account to access camera device and write files.
