# USB camera

This should work on any linux distro with any sane camera that you have.

## How to get info which cameras are available?

Run `v4l2-ctl --list-devices`.

## How to get what modes are available for the camera?

Run `v4l2-ctl --list-formats-ext -d /dev/video0` where `/dev/video0` is a device
listed from command above.

Notice not every device is an actual camera.

## Prepare config

- copy `usb.dist` as `.env`
- in copied file `.env` replace `token-change-me` with the value of the token
  you copied
- in copied file `.env` replace `fingerprint-change-me` with some random value,
  which is alphanumeric and has at least 16 chars (and max of 40 chars),
  for example set it to `fingerprint-myprinter2-camera-2`
- in copied file `.env` replace  `/dev/video0` with desired device in `CAMERA_DEVICE`
- save edited file `.env`

Next, [test config](./test.config.md).
