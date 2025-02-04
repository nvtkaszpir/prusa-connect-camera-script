# Install script as systemd service

Depending on the distro there are various options to configure scripts as service.
On newer distros Raspberry Pi runs systemd, we will use that.

```shell
cd /home/pi/src/prusa-connect-camera-script
sudo cp -f prusa-connect-camera@.service /etc/systemd/system/prusa-connect-camera@.service
sudo systemctl daemon-reload
```

## Configuring single camera

Assuming that `/home/pi/src/prusa-connect-camera-script/.env` file was created in
previous steps, we use that `.env` file as example camera config.

Notice there is no dot before `env` in the commands below:

```shell
sudo systemctl enable prusa-connect-camera@env.service
sudo systemctl start prusa-connect-camera@env.service
sudo systemctl status prusa-connect-camera@env.service
```

Above commands will enable given service on device restart (reboot),
start the service and show current status.

## Configure multiple cameras

This project allows spawning multiple systemd units.
The suffix after `@` defines what env file to load from given path.
For example if you set unit file name to `prusa-connect-camera@csi.service`
then systemd will load env vars from the file under path
`/home/pi/src/prusa-connect-camera-script/.csi`

So in short:

- copy `csi.dist` as `.csi` and edit it
- copy `prusa-connect-camera@.service` as `prusa-connect-camera@csi.service`
- you may additionally edit unit file if you use different config paths
- run systemctl daemon-reload
- enable systemd service
- start systemd service

```shell
cd /home/pi/src/prusa-connect-camera-script/
cp csi.dist .csi
# edit .csi and set custom command params, token and fingerprint etc...
sudo systemctl enable prusa-connect-camera@csi.service
sudo systemctl start prusa-connect-camera@csi.service
sudo systemctl status prusa-connect-camera@csi.service
```

For another camera, let say for another camera attached over USB

```shell
cd /home/pi/src/prusa-connect-camera-script/
cp usb.dist .usb1
# edit .usb1 and set device, token and fingerprint etc...
sudo systemctl enable prusa-connect-camera@usb1.service
sudo systemctl start prusa-connect-camera@usb1.service
sudo systemctl status prusa-connect-camera@usb1.service
```

For esphome camera, for static images:

```shell
cd /home/pi/src/prusa-connect-camera-script/
cp esphome-snapshot.dist .esphome1
# edit .esphome1 and set device, token and fingerprint etc...
sudo systemctl enable prusa-connect-camera@esphome1.service
sudo systemctl start prusa-connect-camera@esphome1.service
sudo systemctl status prusa-connect-camera@esphome1.service
```

I hope you get the idea...

## Uninstall systemd service

Just run two commands per camera (where `csi` is a camera config):

```shell
sudo systemctl stop prusa-connect-camera@csi.service
sudo systemctl disable prusa-connect-camera@csi.service
```

After removing all cameras remove systemd service definition and reload daemon:

```shell
sudo rm -f /etc/systemd/system/prusa-connect-camera@.service
sudo systemctl daemon-reload
```
