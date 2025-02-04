# mediamtx

Use [mediamtx](https://github.com/bluenviron/mediamtx) on another Raspberry Pi
to create RTSP camera stream for test.

Assuming you run [mediamtx with Raspberry Pi CSI camera](https://github.com/bluenviron/mediamtx#raspberry-pi-cameras)
and that `raspberry-pi` is the hostname of your device and that you expose two cams:

- CSI Raspberry Pi camera under /dev/video0
- USB camera under /dev/video1

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

This should allow us to reach two streams, replace `rpi-address` with the name
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

## Example with single camera over USB

Raspberry Pi Zero 2 + Logitech C920, thanks to [user [&] undso.io](https://forum.prusa3d.com/forum/profile/undso-io/)
for working example.

Allows to have a camera live stream and prusa camera script to use that stream
as source of the images to send to Prusa Connect.

<!-- markdownlint-disable line_length -->
mediamtx config fragment

```yaml
paths:
  cam:
    runOnInit: ffmpeg -f v4l2 -i /dev/video0 -pix_fmt yuv420p -video_size 1920x1080 -framerate 30 -preset ultrafast -c:v libx264 -b:v 6000k -f rtsp rtsp://localhost:$RTSP_PORT/$MTX_PATH
    runOnInitRestart: yes
```

env file for prusa connect script, remember to replace `[rpizero-ip]` with
device address (or try `127.0.0.1` or `0.0.0.0` if script runs on the same host where mediamtx runs)

```shell
PRINTER_ADDRESS=...
PRUSA_CONNECT_CAMERA_TOKEN=...
PRUSA_CONNECT_CAMERA_FINGERPRINT=...
CAMERA_DEVICE=/dev/null
CAMERA_COMMAND=ffmpeg
CAMERA_COMMAND_EXTRA_PARAMS="-loglevel error -y -rtsp_transport udp -i 'rtsp://[rpizero-ip]:8554/cam' -f image2 -vframes 1 -pix_fmt yuv420p "
```

<!-- markdownlint-enable line_length -->
