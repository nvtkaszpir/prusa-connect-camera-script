# Web Cam - MJPG stream

This processing requires ffmpeg package.

Most standalone webcams are actually mjpg cams, they send infinite motion jpeg stream
over specific URL.

The best option to check what is the URL is in the camera manual, or if you
open web UI of the camera and see the stream image then right click on the image
and select Inspect to see the URL for the image - copy that URL.

You should be able to test the stream locally with `ffplay` command.

For example, if your camera is reachable over address `192.168.0.20` and port `8000`
under endpoint `/ipcam/mjpeg.cgi` then below command should show the stream:

```shell
ffplay http://192.168.0.20:8000/ipcam/mjpeg.cgi

```

There may be some user and password in the URL.

If that works, then configuration should be pretty straightforward:

- copy `ffmpeg-mjpg-stream.dist` as `.env`
- in copied file `.env` replace `token-change-me` with the value
  of the token you copied
- in copied file `.env` replace `fingerprint-change-me`
  with some random value, which is alphanumeric and has at least 16 chars
  (and max of 40 chars), for example set it to `fingerprint-myprinter4-camera-4`
- in copied file `.env` replace your RTSP device address `raspberry-pi`,
  port and stream id in `CAMERA_COMMAND_EXTRA_PARAMS` if needed
- save edited file `.env`

Next, [test config](./test.config.md).

## Unverified example

Beagle Camera stream - if I remember correctly, the camera URL to the stream
is something like `http://192.168.2.92/ipcam/mjpeg.cgi`

Replace `192.168.2.92` with your address in the example below.

<!-- markdownlint-disable line_length -->
```shell
PRINTER_ADDRESS=127.0.0.1
PRUSA_CONNECT_CAMERA_TOKEN=token-change-me
PRUSA_CONNECT_CAMERA_FINGERPRINT=fingerprint-change-me
CAMERA_DEVICE=/dev/null
CAMERA_COMMAND=ffmpeg
CAMERA_COMMAND_EXTRA_PARAMS="-y -i 'http://192.168.2.92/ipcam/mjpeg.cgi' -vframes 1 -q:v 1 -f image2 -update 1 "
```
<!-- markdownlint-enable line_length -->

Notice that it is better to use a snapshot instead of stream if available,
see [here](./config.for.camera.snapshot.md#beagle-camera).

## MotionEye

First, please see [MotionEye](./config.for.camera.motioneye.md) in order to
to configure the camera.

Notice that maybe you should switch to a [snapshot](./config.for.camera.snapshot.md#motioneye),
which is much more convenient.

Assuming you want to get first camera stream on port `9081`:

<!-- markdownlint-disable line_length -->
```shell
PRINTER_ADDRESS=127.0.0.1
PRUSA_CONNECT_CAMERA_TOKEN=redacted
PRUSA_CONNECT_CAMERA_FINGERPRINT=06f47777-f179-4025-bd80-9e4cb8db2aed
CAMERA_DEVICE=/dev/null
CAMERA_COMMAND=ffmpeg
CAMERA_COMMAND_EXTRA_PARAMS="-y -i 'http://motion-eye.local:9081' -vframes 1 -q:v 1 -f image2 -update 1 "
```
<!-- markdownlint-enable line_length -->

If you run the script on the same host as MotionEye you could just use
`localhost` or `0.0.0.0` for the host, keeping the port as is.
