# mediamtx

Use [mediamtx](https://github.com/bluenviron/mediamtx) on another Raspberry Pi
to create RTSP camera stream for test.

Assuming you run [mediamtx with Raspberry Pi CSI camera](https://github.com/bluenviron/mediamtx#raspberry-pi-cameras)
and that `raspberry-pi` is the hostname of your device and that you expose two cams:

- CSI Rasberry Pi camera under /dev/video0
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
