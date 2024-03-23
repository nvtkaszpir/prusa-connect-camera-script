# Requirements

## Hardware

Physical host or virtual machine or container:

- probably something like Raspberry Pi Zero W at least, can be without camera
- more cameras usually requires more compute power

Camera such as:
<!-- markdown-link-check-disable -->
- Raspberry Pi CSI cameras such as [Raspberry Pi Cam](https://www.raspberrypi.com/documentation/accessories/camera.html)
<!-- markdown-link-check-enable -->
- most of USB cameras if they work under Linux
- esphome cameras using `esp32_camera_web_server` with `snapshot` module
- esphome cameras using `esp32_camera_web_server` with `stream` module using `ffmpeg`
- probably any camera if using `ffmpeg`

## Software

Linux operating system.
Debian based preferred, for example Raspberry Pi OS Lite if you run Raspberry Pi.
I use also laptop with Ubuntu 22.04, but I believe with minor tweaks it should
work on most distributions (mainly package names are different).

Below list uses Debian package names.

## Generic system packages

- `bash` 5.x (what year is it?)
- `git` (just to install scripts from this repo)
- `curl`
- `iputils-ping`
- `uuid-runtime` to make generation of camera fingerprint easier

## Optional packages

- `v4l-utils` - to detect camera capabilities
- `libraspberrypi-bin` or `rpicam-apps-lite` for Rpi CSI cameras
  (should be already installed on Rpi OS)
- `fswebcam` - for generic USB cameras
- `ffmpeg` - for custom commands for capturing remote streams
- you-name-it - for custom commands beyond my imagination
