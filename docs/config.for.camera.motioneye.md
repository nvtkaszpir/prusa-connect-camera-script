# MotionEye

MotionEye allows to expose current image or a stream per camera.

## Camera configuration

* Go to selected camera, click on its settings (top right corner icon)
* on the left scroll down to `Video streaming` section and make sure it is enabled
(there is a slider on the left and it should show `[I]`).
* select `Streaming Port` and set `Authentication mode` to `Disabled`.

Now there are `Useful URLs` which can be used in two ways to get images

* `Snapshot URL` - the easiest, and recommended
* `Streaming URL` - this one is more cpu consuming, and it's mjpeg

## Snapshot URL

First camera snapshot should be available under address such as

`http://<motioneye-ip>:8765/picture/1/current/`

If you click on the URL in incognito mode it should present the image.

If that works, then please see [snapshot](./config.for.camera.snapshot.md#motioneye)

## Streaming URL

Camera stream for the first camera instance should be available under address
such as

`http://<motioneye-ip>:9081/`

If you click on the URL in incognito mode it should present the stream.

Optionally you could try `ffplay http://<motioneye-ip>:9081/` to test the video.

If that works, then please see [mjpg](./config.for.camera.mjpg.md#motioneye).
