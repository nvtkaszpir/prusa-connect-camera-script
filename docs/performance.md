# Performance

- Raspberry Pi Zero W is able to process [CSI camera](./config.for.camera.csi.libcamera.md)
  (Rpi Cam v2) and [USB 2k](./config.for.camera.usb.md) camera
  but it has load average about 1.4, and CPU is quite well utilized, so you may
  need to [decrease resolution](./configuration.tuning.md) per camera to see how
  it goes.

- for webcams it is always better to choose [snapshot](./config.for.camera.snapshot.md)
  because it requires less computing both on camera and on the host,
  otherwise we need to use ffmpeg

- ffmpeg is usually noticeably slow and cpu intensive, especially if you do more
  complex operations
