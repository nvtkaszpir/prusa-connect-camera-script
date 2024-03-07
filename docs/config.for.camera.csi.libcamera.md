# CSI camera on Raspberry Pi

Example for newer operating systems (commands `libcamera` or `rpicam-still`):

- copy `csi.dist` as `.env` if you want to use Raspberry Pi camera
- in copied file `.env` replace `token-change-me` with the value of the token
  you copied
- in copied file `.env` replace `fingerprint-change-me` with some random value,
  which is alphanumeric and has at least 16 chars (and max of 40 chars),
  for example set it to `fingerprint-myprinter-camera-1`
- save edited file `.env`

Next, [test config](./test.config.md).
