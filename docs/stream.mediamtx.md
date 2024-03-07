# mediamtx

Use mediamtx on antoher Raspberry Pi to create RTSP camera stream for test.

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
    runOnInit: ffmpeg -f v4l2 -i /dev/video1 -pix_fmt yuv420p -preset ultrafast -b:v 600k -f rtsp rtsp://localhost:$RTSP_PORT/$MTX_PATH
    runOnInitRestart: yes

```

<!-- markdownlint-enable line_length -->

Start mediamtx server:

```shell
./mediamtx
```

This should allow us to reach two streams, replace `rpi-address` with the name
of your Raspberry Pi hostname or IP address

```shell
ffplay rtsp://rpi-address:8554/cam
ffplay rtsp://rpi-address:8554/endoscope
```
