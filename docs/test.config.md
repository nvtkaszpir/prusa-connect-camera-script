# Test the config

- ensure to turn on the 3D Printer so that it sends telemetry, otherwise images
  will sent and you will get successful image uploads but on PrusaConnect page
  they will not be available
- run below commands, we assume `.env` is the camera config we defined earlier

```shell
set -o allexport; source .env; set +o allexport
./prusa-connect-camera.sh
```

Above commands will load env vars and will start the script.
In the beginning script shows some commands that will be executed, for example
command to fetch the image from camera, example log line:

<!-- markdownlint-disable line_length -->
```text
Camera capture command: fswebcam -d /dev/video0 --resolution 640x480 --no-banner /dev/shm/camera_87299de9-ea57-45be-b6ea-4d388a52c954.jpg
```

so you should run:

```shell
fswebcam -d /dev/video0 --resolution 640x480 --no-banner /dev/shm/camera_87299de9-ea57-45be-b6ea-4d388a52c954.jpg
```

<!-- markdownlint-enable line_length -->

and get the outputs from the command, and also it should write an image.

Check for errors, if any, if everything is ok you should see a lot of `204`
every 10s.

If not, well, raise an [issue on GitHub](https://github.com/nvtkaszpir/prusa-connect-camera-script/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc).
