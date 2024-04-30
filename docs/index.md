# Welcome to Prusa-Connect-Camera-Script

![logo](static/prusa-connect-cam.png)

This project aims to make it easier to use any camera to be used as
Prusa Connect camera.

## Features

- allows to read images from CSI cameras, USB cameras, RTSP streams, still images...
- do not send pictures if the printer is offline
- store data in memory to prevent MicroSD wear out
- verbose error messages to see if the image capture works
- ability to run multiple cameras in separate instances
- ability to run in docker containers (multi-platform  multi-arch)

## Architecture

```mermaid
sequenceDiagram
    script->>script: initial checks
    script->>script: start loop
    script->>camera_command: Call camera command
    camera_command->>image_on_disk: camera command writes image to disk
    image_on_disk->>script: script checks image from disk if exits etc
    script->>script: show errors if image_on_disk is missing
    script->>curl: run curl to post image to Prusa Connect API (pass image_on_disk)
    curl->>image_on_disk: curl reads image from disk
    curl->>PrusaConnect: send image to Prusa Connect
    PrusaConnect->>curl: return response code / messages
    script->>script: sleep + end loop

```

## Known limitations

- this script performs processing of the single camera, if you need more cameras
  then just create multiple copies with different settings (see below)
- Rpi Zero W or older devices may have CPU limitations to process remote streams
  or multiple cameras at once

- I was not able to test EVERY setting so this may still have some bugs
- Prusa Connect will not show camera image if the printer is not alive, this is
  Prusa Connect limitation.
- default settings are quire generic and thus low camera quality, you need to adjust
  them, see advanced configuration at the end
