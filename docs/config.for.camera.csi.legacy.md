# CSI camera on Raspberry Pi (legacy)

Example for older operating systems (those with command `raspistill`):

- copy `csi-legacy.dist` as `.env` if you want to use Raspberry Pi camera
- in copied file `.env` replace `token-change-me` with the value of the token
  you copied
- in copied file `.env` replace `fingerprint-change-me` with some random value,
  which is alphanumeric and has at least 16 chars (and max of 40 chars),
  for example set it to `fingerprint-myprinter-camera-1`
- save edited file `.env`

Next, [test config](./test.config.md).

## Real world scenario

Some older Rpi 3 with older Debian with basic cam:

```shell
PRINTER_ADDRESS=127.0.0.1
PRUSA_CONNECT_CAMERA_TOKEN=token-change-me
PRUSA_CONNECT_CAMERA_FINGERPRINT=trash-cam-night-video-wide-1
CAMERA_DEVICE=/dev/video0
CAMERA_COMMAND=raspistill
CAMERA_COMMAND_EXTRA_PARAMS="--nopreview --mode 640:480 -o"
```
