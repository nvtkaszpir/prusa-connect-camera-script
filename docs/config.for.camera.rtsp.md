# RTSP cameras

## Caution

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
  port and stream identificator in `CAMERA_COMMAND_EXTRA_PARAMS` if needed
- save edited file `.env`

You can try with `UDP`, but you may not get it ;-)

Next, [test config](./test.config.md).
