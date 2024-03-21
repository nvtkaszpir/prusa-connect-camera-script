# Create config for prusa-connect-camera-script env vars

Notice that each camera should have different fingerprint and token.

Fingerprint can be easily generated using command:

```shell
uuidgen
```

just copy/paste the output as fingerprint value into the config.

## Note

**Do not** change fingerprint after launching the script - thus camera is registered
and you may need to revert the change or delete and readd camera again and start
from scratch.

## Example devices

- [Raspberry Pi CSI camera](./config.for.camera.csi.libcamera.md) - libcamera (recommended)
- [Raspberry Pi CSI camera](./config.for.camera.csi.legacy.md) - legacy

- [USB camera](./config.for.camera.usb.md)

- [ESPHome via camera snapshot](./config.for.camera.esphome.snapshot.md) (recommended)
- [ESPHome via camera stream](./config.for.camera.esphome.stream.md)

- [RTSP streaming cams](./config.for.camera.rtsp.md)

Next, [test config](./test.config.md).
