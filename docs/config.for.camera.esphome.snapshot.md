# ESPHome camera snapshot

With esphome camera with snapshot we can use the ultimate power of `curl`
command to fetch the image from the camera.

## Prepare esphome device

Configure esphome device:

- install esphome [camera](https://esphome.io/components/esp32_camera.html)
  on the device and add `esp32_camera` and `esp32_camera_web_server` with
  `snapshot` modules:

  ```yaml
  esp32_camera:
  ... (skipped due to the fact there are different modules)

  esp32_camera_web_server:
    - port: 8081
      mode: snapshot
  ```

Flash the device and wait until it boots and is available.

## Create config for script

- copy `esphome-snapshot.dist` as `.env`
- in copied file `.env` replace `token-change-me` with the value
  of the token you copied
- in copied file `.env` replace `fingerprint-change-me` with some
  random value, which is alphanumeric and has at least 16 chars (and max of 40 chars),
  for example set it to `fingerprint-myprinter3-camera-3`
- in copied file `.env` replace your esphome device address and port
  in `CAMERA_COMMAND_EXTRA_PARAMS`
- save edited file `.env`

Next, [test config](./test.config.md).
