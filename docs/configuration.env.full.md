# Configuration Env Vars

Config for camera is to the script as environment variables (env vars).

* `SLEEP` - sleep time in seconds between image captures,
  notice that PrusaConnect accepts images at most every 10s or slower.
  Default value `10`.

* `PRINTER_ADDRESS` - Printer address to ping, if address is unreachable there
  is no point in sending an image. Set to `127.0.0.1` to always send images.
  Set to empty value to disable ping check and always send images.
  Default value `127.0.0.1`.

* `PRUSA_CONNECT_CAMERA_TOKEN` - required, PrusaConnect API key

* `PRUSA_CONNECT_CAMERA_FINGERPRINT` - required, PrusaConnect camera fingerprint,
  use for example cli `uuidgen` or [web](https://www.uuidgenerator.net/version4)
  to generate it, it must be at least 16 alphanumeric chars, 40 max.
  Remember not to change this if it was already set, otherwise you need to
  remove and add the camera again.

* `CAMERA_DEVICE` - camera device to use, if you use Raspberry Pi camera
  attached to the CSI via camera ribbon then leave as is
  Default `/dev/video0` which points to first detected camera.
  If you have more cameras you probably want to use device
  by-id or by-path, see [tuning](./configuration.tuning.md) for more details.

* `CAMERA_SETUP_COMMAND` - camera setup command and params executed before
  taking image, default value is empty, because some cameras do not support it,
  in general you want to use something like v4l2-ctl parameters, so
  so for example
  `setup_command=v4l2-ctl --set-ctrl brightness=10,gamma=120 -d $CAMERA_DEVICE`
  will translate to:
  `v4l2-ctl --set-ctrl brightness=10,gamma=120 -d /dev/video0`

* `CAMERA_COMMAND` - command used to invoke image capture,
  default is `rpicam-still`
  available options:
  * rpicam-still - using CSI camera + modern Raspberry Pi operating systems since
    Debian 11 Bullseye
  * raspistill - using CSI camera + older Raspberry Pi operating systems
  * fswebcam - using USB camera + custom package 'fswebcam'
  * anything else will be processed directly, so for example you could use
    'ffmpeg' in here

* `CAMERA_COMMAND_EXTRA_PARAMS` -extra params passed to the camera program,
  passed directly as `<command> <extra-params> <output_file>`
  example values per specific camera:
  <!-- markdownlint-disable line_length -->

  * libcamera (rpicam-still)
    `--immediate --nopreview --mode 2592:1944:12:P --lores-width 0 --lores-height 0 --thumb none -o`
  * raspistill
    `--nopreview --mode 2592:1944:12:P -o`
  * fswebcam
    `--resolution 1280x960 --no-banner`
  * ffmpeg, in this case CAMERA_DEVICE is ignored, use it directly in the extra params
    `-f v4l2 -y -i /dev/video0 -f image2 -vframes 1 -pix_fmt yuvj420p`

  <!-- markdownlint-enable line_length -->

* `TARGET_DIR` -  directory where to save camera images, image per camera will
  be overwritten per image capture,
  default value `/dev/shm` so that we do not write to microSD cards or read only
  filesystems/containers. `/dev/shm` is a shared memory space. if you have more
  printers you may need to increase this value on system level.

* `CURL_EXTRA_PARAMS` - extra params to curl when pushing an image,
  default empty value, but you could for example add additional params if needed
  such as `-k` if using tls proxy with self-signed certificate

* `PRUSA_CONNECT_URL` - Prusa Connect endpoint where to post images,
  default value `https://webcam.connect.prusa3d.com/c/snapshot`
  You could put here Prusa Connect Proxy if you use one.

For more in-depth details (no need to repeat them here) please see the top of
the [prusa-connect-camera.sh](https://github.com/nvtkaszpir/prusa-connect-camera-script/blob/master/prusa-connect-camera.sh).
