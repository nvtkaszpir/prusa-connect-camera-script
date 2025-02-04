# Install script as docker container

You can run the app as container.

Multi-platform images are available at [quay.io/kaszpir/prusa-connect-script](https://quay.io/kaszpir/prusa-connect-script).

Currently available platforms (your system should download desired architecture
automatically):

- linux/amd64 (64bit)
- linux/arm64 (64bit)
- linux/arm/v7 (32bit)

## Preparation of the host

Install [docker on Debian](https://docs.docker.com/engine/install/debian/).

Optional - you may want to make sure current user is in docker group so it is possible
to run containers without using `sudo`:

```shell
sudo usermod -a -G docker $(whoami)
```

logout and login again, or reboot Raspberry Pi.

## Preparation of env files for docker command

Notice - you may not have to do it if you use docker-compose (I think...).

If you use `docker` command directly you need to edit env files
and **remove quotation marks** from the files (this is a [limitation of the Docker](https://github.com/docker/cli/issues/3630))

For example:

```shell
CAMERA_COMMAND_EXTRA_PARAMS="--immediate --nopreview --thumb none -o"
```

becomes

```shell
CAMERA_COMMAND_EXTRA_PARAMS=--immediate --nopreview --thumb none -o

```

## Raspberry Pi CSI or USB camera

We assume that `.csi` is a env file with example variables after edit, it is
possible to run below command and have screenshots sent to the Prusa Connect.

<!-- markdownlint-disable line_length -->
```shell
docker run --env-file .csi -v /run/udev:/run/udev:ro -v /dev/:/dev/ --device /dev:/dev --read-only quay.io/kaszpir/prusa-connect-script:03c4886
```
<!-- markdownlint-enable line_length -->

### Raspberry Pi and remote cams

If you use remote camera you can make command even shorter:

```shell
docker run --env-file .esp32 --read-only quay.io/kaszpir/prusa-connect-script:03c4886
```

### Other examples

<!-- markdownlint-disable line_length -->
```shell
docker run --env-file .docker-csi --device /dev:/dev -v /dev/:/dev/ -v /run/udev:/run/udev:ro -it quay.io/kaszpir/prusa-connect-script:03c4886-arm64

docker run --env-file .docker-esphome-snapshot --read-only quay.io/kaszpir/prusa-connect-script:03c4886-amd64
docker run --env-file .docker-video0 --device /dev:/dev -v /dev/:/dev/ -v /run/udev:/run/udev:ro -it quay.io/kaszpir/prusa-connect-script:03c4886
```
<!-- markdownlint-enable line_length -->

### Running multiple cameras at once

Create env file per camera and run each container separately.

## docker-compose

Instead of running single command per container, you can manage them using
docker-compose. Example `docker-compose.yaml` contains some examples.
Some sections are commented out, though.

Notice they still require proper env files to work, for example
copy usb.dist as .usb, edit its parameters and run `docker-compose up`

Notice that you may need to change remote cameras addresses from hostnames
to IP addresses.

Another notice that sharing `/dev/` or `/dev/shm` across different containers
with different architectures may be problematic.
