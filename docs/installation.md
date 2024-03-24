# Installation

Install system packages - assuming Debian based distros on Raspberry Pi OS, which
also come in with some pre-installed packages.

Below commands should be executed in shell/terminal (on the Raspberry Pi).

For most Raspberry Pi Cameras (CSI/USB):

```shell
sudo apt-get update
sudo apt-get install -y curl libcamera0 fswebcam git iputils-ping v4l-utils uuid-runtime
```

Additional packages for remote cameras - especially the one that are used for streaming:

```shell
sudo apt-get install -y ffmpeg
```

Download this script:

```shell
mkdir -p /home/pi/src
cd /home/pi/src
git clone https://github.com/nvtkaszpir/prusa-connect-camera-script.git
cd prusa-connect-camera-script
```
