# Create config for prusa-connect-camera-script env vars

## Prusa Camera Token

`PRUSA_CONNECT_CAMERA_TOKEN` should be taken from [earlier step](./prusa.connect.md).

## Fingerprint

`PRUSA_CONNECT_CAMERA_FINGERPRINT` should be uniqe and set only once for each camera.

Fingerprint can be easily generated using command:

```shell
uuidgen
```

or via [online website](https://www.uuidgenerator.net/version4),
just copy/paste the output as fingerprint value into the config.

**Do not** change fingerprint after launching the script - thus camera is registered
and you may need to revert the change or delete and readd camera again and start
from scratch.

## Example devices

Other env vars are set depending on the camera device we want to use.

### Locally connected

- [Raspberry Pi CSI camera](./config.for.camera.csi.libcamera.md) - libcamera (recommended)
- [Raspberry Pi CSI camera](./config.for.camera.csi.legacy.md) - legacy
- [USB camera](./config.for.camera.usb.md)

### Web cams

#### Generic

- [Snapshot cams](./config.for.camera.snapshot.md) (recommended)
- [MJPG streaming cams](./config.for.camera.mjpg.md)
- [RTSP streaming cams](./config.for.camera.rtsp.md)

#### Specific example

- [ESPHome via camera snapshot](./config.for.camera.esphome.snapshot.md) (recommended)
- [ESPHome via camera stream](./config.for.camera.esphome.stream.md)

## Next

Next, [test config](./test.config.md).
