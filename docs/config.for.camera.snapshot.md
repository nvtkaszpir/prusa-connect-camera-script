# Web Cam - snapshot

Some cameras expose single image snapshot under specific URL.
we can use the ultimate power of `curl` command to fetch the image from the camera.

This is the preferred way to use web cams because right now Prusa Connect do not
support streams, and thus there is no point in wasting CPU on that.

The best option to check what is the URL is in the camera manual, or if you
open web UI of the camera and see the still image then right click on the image
and select Inspect to see the URL for the image - copy that URL.

You should be able to test the stream locally with `ffplay` command.

For example, if your camera is reachable over address `192.168.0.20` and port `8001`
under endpoint `/snap.jpg` then below command should show the image:

```shell
curl -vvv http://another-cam.local:8081/snap.jpg -o snap.jpg
```

then you should see in the output something like `Content-Type: image/jpeg`,
then you are good - see `snap.jpg` in the folder you executed the command.

## Create config for script

- copy `snapshot.dist` as `.env`
- in copied file `.env` replace `token-change-me` with the value
  of the token you copied
- in copied file `.env` replace `fingerprint-change-me` with some
  random value, which is alphanumeric and has at least 16 chars (and max of 40 chars),
  for example set it to `fingerprint-myprinter3-camera-3`
- in copied file `.env` replace your esphome device address and port
  in `CAMERA_COMMAND_EXTRA_PARAMS`
- save edited file `.env`

Next, [test config](./test.config.md).

## Real world example

### esp32 with esphome

For more in-depth details see [esphome snapshot](./config.for.camera.esphome.snapshot.md).

I have esp32-wrover-dev board with camera + esphome + web ui for camera exposing
snapshot frame on port `8081`.

We can use curl to fetch it.

```shell
PRINTER_ADDRESS=127.0.0.1
PRUSA_CONNECT_CAMERA_TOKEN=redacted
PRUSA_CONNECT_CAMERA_FINGERPRINT=06f47777-f179-4025-bd80-9e4cb8db2aed
CAMERA_DEVICE=/dev/null
CAMERA_COMMAND=curl
CAMERA_COMMAND_EXTRA_PARAMS=http://esp32-wrover-0461c8.local:8081/ -o
```

### Beagle Camera

This is not tested, I do not own such camera so hard to tell if this is right.

Camera URL for snapshot `http://192.168.2.92/images/snapshot0.jpg` so the config
should be like below:

```shell
PRINTER_ADDRESS=127.0.0.1
PRUSA_CONNECT_CAMERA_TOKEN=redacted
PRUSA_CONNECT_CAMERA_FINGERPRINT=06f47777-f179-4025-bd80-9e4cb8db2aed
CAMERA_DEVICE=/dev/null
CAMERA_COMMAND=curl
CAMERA_COMMAND_EXTRA_PARAMS=http://192.168.2.92/images/snapshot0.jpg -o
```

### MotionEye

First, please see [MotionEye](./config.for.camera.motioneye.md) in order to
to configure the camera.

Assuming you want to get first camera snapshot (camera number `1`):

```shell
PRINTER_ADDRESS=127.0.0.1
PRUSA_CONNECT_CAMERA_TOKEN=redacted
PRUSA_CONNECT_CAMERA_FINGERPRINT=06f47777-f179-4025-bd80-9e4cb8db2aed
CAMERA_DEVICE=/dev/null
CAMERA_COMMAND=curl
CAMERA_COMMAND_EXTRA_PARAMS=http://motioneye-ip:8765/picture/1/current/ -o
```

If you run the script on the same host as MotionEye you could just use
`localhost` or `0.0.0.0` for the host, keeping the port as is.
