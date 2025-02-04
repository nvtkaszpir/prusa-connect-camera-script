# Known Limitations

## old curl version

Curl would complain about each option and it would not upload.
The error would read something like:

- `curl: option --no-progress-meter: is unknown`
- `curl: option --compressed: is unknown`
- `curl: option --w: is unknown`

Usually it means your operating system distribution has quite old curl version,
and thus certain options are not available - for example you run Raspbian 10 Buster
on older Raspberry Pi (see `cat /etc/os-release`)

Fix:
you can comment out (or remove) in `prusa-connect-camera.sh` script lines
containing those options by just removing them, until it works.
Frankly speaking you REALLY should think about upgrading your operating system.
