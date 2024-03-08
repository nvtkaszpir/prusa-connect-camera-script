# Configuration tuning

Assuming you already have a working camera with basic setup, we can tune it further.

Below steps depend on the camera capabilities, thus your mileage may vary.

## Getting higher quality camera images

Use `v4l2-ctl` to get the list of available resolutions that camera provides
and then update it in the env var configs.

Remember to [test config](./test.config.md).

Notice that Prusa Connect has file size limit something about 8MB of the image uploaded.

For Raspberry Cam v2 you could use `csi.dist` as ssource and add
`--mode 2592:1944:12:P` to the `CAMERA_COMMAND_EXTRA_PARAMS`.

For certain USB cameras (such as Tracer Endoscope) you shoudl use `usb.dist` and
you should be able to add `--resolution 1280x960` to the `CAMERA_COMMAND_EXTRA_PARAMS`.

## Setting up video camera controls

Get device capabilities, especially User controls

```shell
v4l2-ctl -d /dev/video0 --all
```

and set accordingly parameters you want in `CAMERA_SETUP_COMMAND` env var, for example:

```shell
CAMERA_SETUP_COMMAND="v4l2-ctl --set-ctrl brightness=64,gamma=300 -d $CAMERA_DEVICE"
```

remember to restart given camera service.

You can try to use `guvcview` desktop application to check prams in realtime.

## Image flip and rotation

You can pass on params to rpicam-still or fswebcam as you want.

### rpicam-still

See `rpicam-still --help`

```text
  --hflip      Read out with horizontal mirror
  --vflip      Read out with vertical flip
  --rotation   Use hflip and vflip to create the given rotation <angle>
```

so for example:

```shell
CAMERA_COMMAND=rpicam-still
CAMERA_COMMAND_EXTRA_PARAMS="--rotation 90 --immediate --nopreview --thumb none -o"
```

### fswebcam

See `fswebcam --help`

```text
  --flip <direction>       Flips the image. (h, v)
  --crop <size>[,<offset>] Crop a part of the image.
  --scale <size>           Scales the image.
  --rotate <angle>         Rotates the image in right angles.
```

so for example:

```shell
CAMERA_COMMAND=fswebcam
CAMERA_COMMAND_EXTRA_PARAMS="--flip v --resolution 640x480 --no-banner"
```

## ffdshow

When curl is not enough and you don't really want to physically turn your camera,
then use ffdshow.
You can process static images with it, load v4l2 devices... whatever.

With ffdshow you can do interesting things with filters, it will just require
more computing power.

See [here](https://superuser.com/questions/578321/how-can-i-rotate-a-video-180-with-ffmpeg)
for basic ones.

You probably want to use `-vf "transpose=1"` to rotate image 90 degrees clockwise:
<!-- markdownlint-disable line_length -->
```shell
CAMERA_COMMAND=ffmpeg
CAMERA_COMMAND_EXTRA_PARAMS="-y -i 'http://esp32-wrover-0461c8.local:8080/' -vf 'transpose=1' -vframes 1 -q:v 1 -f image2 -update 1 "
```
<!-- markdownlint-disable line_length -->

Frankly speaking you can do anything you want with ffdshow, for example

`-vf transpose=1,shufflepixels=m=block:height=16:width=16`

Why? why not :D
