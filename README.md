# prusa-connect-camera-script

![prusa-connect-cam](docs/static/prusa-connect-cam.png)

Linux shell script to send still camera images to Prusa Connect

See [docs here](https://nvtkaszpir.github.io/prusa-connect-camera-script)

## Quick start

RaspberryPi with CSI camera with libcamera:

```shell
# go to Prusa Connect site, add camera, copy token, turn on your 3D printer

cp csi.dist .env
# edit .env file, set token and fingerprint

set -o allexport; source .env; set +o allexport

./prusa-connect-camera.sh

```

Any linux host with ffmpeg and RTSP camera:

```shell
# go to Prusa Connect site, add camera, copy token, turn on your 3D printer

cp ffmpeg-mediamtx-rtsp-tcp.dist .env
# edit .env file, set token and fingerprint
# change 'rtsp://raspberry-pi:8554/cam' to rtsp://<username>:<password>@<camera-ip-address>/<stream-name>

set -o allexport; source .env; set +o allexport

./prusa-connect-camera.sh

```

## Docs

```shell
pip install -r requirements.txt
mkdocs serve

```

Auto-published by github action when pushed to master.

## Code commits

```shell
npm install -g markdown-link-check
pip install pre-commit

pre-commit install
git add .
pre-commit run --all
```

## Docker container build

```shell
make quay
make quay_multiarch
```
