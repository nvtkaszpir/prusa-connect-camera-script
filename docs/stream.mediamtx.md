# mediamtx

Use [mediamtx](https://github.com/bluenviron/mediamtx) on another Raspberry Pi
to create RTSP camera stream for test.

## Exposing Raspberry Pi CSI camera

Assuming you run [mediamtx with Raspberry Pi CSI camera](https://github.com/bluenviron/mediamtx#raspberry-pi-cameras)
and that `rpi-address` is the hostname of your device and that you want to
expose integrated CSI camera:

- CSI Raspberry Pi camera under /dev/video0

so your `mediamtx.yml` has config fragment such as:

<!-- markdownlint-disable line_length -->
```yaml
paths:
  cam:
    source: rpiCamera
    rpiCameraWidth: 1920
    rpiCameraHeight: 1080
    rpiCameraHFlip: true
    rpiCameraVFlip: true
    # rpiCameraSaturation: 0 # uncomment if you have NoIR camera and you want to remove pink color overlay
```
<!-- markdownlint-enable line_length -->

Start mediamtx server:

```shell
./mediamtx
```

This should allow us to reach the stream, replace `rpi-address` with the name
of your Raspberry Pi hostname or IP address. The ports are default for mediamtx.

On another host see the stream:

```shell
ffplay rtsp://rpi-address:8554/cam
```

Or you could watch it via web browser under endpoints such as

```text
http://rpi-address:8889/cam
```

Now, in prusa-connect-camera-script you need to set up config like below:

<!-- markdownlint-disable line_length -->
```shell
PRINTER_ADDRESS=...
PRUSA_CONNECT_CAMERA_TOKEN=...
PRUSA_CONNECT_CAMERA_FINGERPRINT=...
CAMERA_DEVICE=/dev/null
CAMERA_COMMAND=ffmpeg
CAMERA_COMMAND_EXTRA_PARAMS="-loglevel error -y -i 'rtsp://rpi-address:8554/cam' -f image2 -vframes 1 -pix_fmt yuv420p "
```
<!-- markdownlint-enable line_length -->

and that's it.

## Example with single camera over USB

Raspberry Pi Zero 2 + Logitech C920, thanks to [user [&] undso.io](https://forum.prusa3d.com/forum/profile/undso-io/)
for working example. Rpi zero hostname is `rpizero-ip`.

Allows to have a camera live stream and prusa camera script to use that stream
as source of the images to send to Prusa Connect.

<!-- markdownlint-disable line_length -->
mediamtx config fragment

```yaml
paths:
  camusb:
    runOnInit: ffmpeg -f v4l2 -i /dev/video0 -pix_fmt yuv420p -video_size 1920x1080 -framerate 30 -preset ultrafast -c:v libx264 -b:v 6000k -f rtsp rtsp://localhost:$RTSP_PORT/$MTX_PATH
    runOnInitRestart: yes
```
<!-- markdownlint-enable line_length -->

So now you camera over usb should be available via `rtsp://rpizero-ip:8554/camusb`

Below is an env file for prusa connect script, remember to replace `rpizero-ip` with
device address (or try `127.0.0.1` or `0.0.0.0` if script runs on the same host
where mediamtx runs):

<!-- markdownlint-disable line_length -->
```shell
PRINTER_ADDRESS=...
PRUSA_CONNECT_CAMERA_TOKEN=...
PRUSA_CONNECT_CAMERA_FINGERPRINT=...
CAMERA_DEVICE=/dev/null
CAMERA_COMMAND=ffmpeg
CAMERA_COMMAND_EXTRA_PARAMS="-loglevel error -y -i 'rtsp://rpizero-ip:8554/camusb' -f image2 -vframes 1 -pix_fmt yuv420p "
```
<!-- markdownlint-enable line_length -->

## Exposing two cameras

Assuming you run [mediamtx with Raspberry Pi CSI camera](https://github.com/bluenviron/mediamtx#raspberry-pi-cameras)
and that `rpi-address` is the hostname of your device and that you expose two cams:

- CSI Raspberry Pi camera under /dev/video0 (referenced as cam)
- USB camera under /dev/video1 (referenced as endoscope)

so your `mediamtx.yml` has config fragment such as:

<!-- markdownlint-disable line_length -->
```yaml
paths:
  cam:
    source: rpiCamera

  endoscope:
    runOnInit: ffmpeg -f v4l2 -pix_fmt mjpeg -video_size 1280x960 -framerate 30 -i /dev/video1 -c:v libx264 -preset ultrafast -b:v 6000k -f rtsp rtsp://localhost:$RTSP_PORT/$MTX_PATH
    runOnInitRestart: yes

```
<!-- markdownlint-enable line_length -->

Start mediamtx server:

```shell
./mediamtx
```

This should allow you to reach two streams, replace `rpi-address` with the name
of your Raspberry Pi hostname or IP address. The ports are default for mediamtx.

```shell
ffplay rtsp://rpi-address:8554/cam
ffplay rtsp://rpi-address:8554/endoscope
```

Or you could watch it via web browser under endpoints such as

```text
http://rpi-address:8889/cam
http://rpi-address:8889/endoscope
```

Now you can spawn two separate prusa-connect-camera-script instances with
a separate env file for each, notice they differ only with the path to the rtsp
stream url.

CSI camera:

<!-- markdownlint-disable line_length -->
```shell
PRINTER_ADDRESS=...
PRUSA_CONNECT_CAMERA_TOKEN=...
PRUSA_CONNECT_CAMERA_FINGERPRINT=...
CAMERA_DEVICE=/dev/null
CAMERA_COMMAND=ffmpeg
CAMERA_COMMAND_EXTRA_PARAMS="-loglevel error -y -i 'rtsp://rpi-address:8554/cam' -f image2 -vframes 1 -pix_fmt yuv420p "
```
<!-- markdownlint-enable line_length -->

Endoscope camera:

<!-- markdownlint-disable line_length -->
```shell
PRINTER_ADDRESS=...
PRUSA_CONNECT_CAMERA_TOKEN=...
PRUSA_CONNECT_CAMERA_FINGERPRINT=...
CAMERA_DEVICE=/dev/null
CAMERA_COMMAND=ffmpeg
CAMERA_COMMAND_EXTRA_PARAMS="-loglevel error -y -i 'rtsp://rpi-address:8554/endoscope' -f image2 -vframes 1 -pix_fmt yuv420p "
```
<!-- markdownlint-enable line_length -->

## Formats

Below examples are via rtsp protocol.

FFmpeg does not support WebRTC (as of the moment of writing).

If you want to use HLS then try something like
`http://rpi-address:8554/cam/index.m3u8` as an input
(just use `http://` and add `index.m3u8`).

## mediamtx in docker

See [this PR](https://github.com/bluenviron/mediamtx/pull/4324)
or the code in [here](https://github.com/nvtkaszpir/prusa-connect-camera-script/tree/master/hack/mediamtx).
