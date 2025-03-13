# Web Cam - HLS stream

HLS is extremely easy to set up and works over plain HTTP protocol, thus it
can be very easily proxied and accessed by other clients.

!!! warning

    **DO NOT use VLC to test streams**, there are unfortunately problems with it.
    Please use `ffplay` from `ffmpeg` package.

You should be able to test the stream locally with `ffplay` command.

For example, if your camera is reachable over address `192.168.0.20` and port `8888`
under endpoint `/stream` then below command should show the stream:

```shell
ffplay http://192.168.0.20:8888/stream/index.m3u8

```

If that works, then configuration should be pretty straightforward:

- copy `ffmpeg-mediamtx-hls.dist` as `.env`
- in copied file `.env` replace `token-change-me` with the value
  of the token you copied
- in copied file `.env` replace `fingerprint-change-me`
  with some random value, which is alphanumeric and has at least 16 chars
  (and max of 40 chars), for example set it to `fingerprint-myprinter4-camera-4`
- in copied file `.env` replace your RTSP device address `raspberry-pi`,
  port and stream id in `CAMERA_COMMAND_EXTRA_PARAMS` if needed
- save edited file `.env`

Next, [test config](./test.config.md).

## Real world example

My another Rpi Zero W named `hormex` has a camera:

- CSI

and I'm running `mediamtx` server to convert those to various streams,
one of them is HLS. More about mediamtx is [here](./stream.mediamtx.md).

So I can have config:

`.stream-hls-csi` over HLS:

<!-- markdownlint-disable line_length -->

```shell
PRINTER_ADDRESS=127.0.0.1
PRUSA_CONNECT_CAMERA_TOKEN=redacted
PRUSA_CONNECT_CAMERA_FINGERPRINT=62e8ab72-9766-4ad5-b8b1-174d389fc0d3
CAMERA_DEVICE=/dev/null
CAMERA_COMMAND=ffmpeg
CAMERA_COMMAND_EXTRA_PARAMS="-loglevel error -y -i "http://hormex:8888/cam/index.m3u8" -f image2 -vframes 1 -pix_fmt yuvj420p "
```
<!-- markdownlint-enable line_length -->
