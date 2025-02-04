# Web Cam - RTSP stream

!!! warning

    **DO NOT use VLC to test streams**, there are unfortunately problems with it.
    Please use `ffplay` from `ffmpeg` package.

You have some options such as TCP or UDP stream (whatever..).
This should work with any other camera (usually there is a different port per stream)

You should be able to test the stream locally with `ffplay` command.

For example, if your camera is reachable over address `192.168.0.20` and port `8000`
under endpoint `/stream` then below command should show the stream:

```shell
ffplay rtsp://192.168.0.20:8000/stream

```

If that works, then configuration should be pretty straightforward:

- copy `ffmpeg-mediamtx-rtsp-tcp.dist` as `.env`
- in copied file `.env` replace `token-change-me` with the value
  of the token you copied
- in copied file `.env` replace `fingerprint-change-me`
  with some random value, which is alphanumeric and has at least 16 chars
  (and max of 40 chars), for example set it to `fingerprint-myprinter4-camera-4`
- in copied file `.env` replace your RTSP device address `raspberry-pi`,
  port and stream id in `CAMERA_COMMAND_EXTRA_PARAMS` if needed
- save edited file `.env`

You can try with `UDP`, but you may not get it ;-)

Next, [test config](./test.config.md).

## Real world example

My another Rpi Zero W named `hormex` has two cameras:

- CSI
- endoscope on /dev/video

and I'm running `mediamtx` server to convert those to RTSP streams.
More about mediamtx is [here](./stream.mediamtx.md).

So I can have two configs:

`.stream-csi` over UDP:

<!-- markdownlint-disable line_length -->

```shell
PRINTER_ADDRESS=127.0.0.1
PRUSA_CONNECT_CAMERA_TOKEN=redacted
PRUSA_CONNECT_CAMERA_FINGERPRINT=62e8ab72-9766-4ad5-b8b1-174d389fc0d3
CAMERA_DEVICE=/dev/null
CAMERA_COMMAND=ffmpeg
CAMERA_COMMAND_EXTRA_PARAMS="-loglevel error -y -rtsp_transport udp -i "rtsp://hormex:8554/cam" -f image2 -vframes 1 -pix_fmt yuvj420p "
```
<!-- markdownlint-enable line_length -->

`.stream-endo` over TCP:

<!-- markdownlint-disable line_length -->
```shell
PRINTER_ADDRESS=127.0.0.1
PRUSA_CONNECT_CAMERA_TOKEN=redacted
PRUSA_CONNECT_CAMERA_FINGERPRINT=01a67af8-86a3-45c7-b6e2-39e9d086b367
CAMERA_DEVICE=/dev/null
CAMERA_COMMAND=ffmpeg
CAMERA_COMMAND_EXTRA_PARAMS="-loglevel error -y -rtsp_transport tcp -i "rtsp://hormex:8554/endoscope" -f image2 -vframes 1 -pix_fmt yuvj420p "

```
<!-- markdownlint-enable line_length -->
