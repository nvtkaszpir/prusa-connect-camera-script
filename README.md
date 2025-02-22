# prusa-connect-camera-script

![prusa-connect-cam](docs/static/prusa-connect-cam.png)

Linux shell script to send still camera images to Prusa Connect

## Documentation

See [docs here](https://nvtkaszpir.github.io/prusa-connect-camera-script) for:

* feature list
* requirements
* general step-by-step install
* example configs
* advanced tweaks

## Development

Those are generally notes to myself :)

### Docs

Preview documentation locally

```shell
pip install -r requirements.txt
mkdocs serve

```

Auto-published by github action when pushed to master.

### Code commits

ensure to have [pre-commit](https://pre-commit.com/) installed.

```shell
npm install -g markdown-link-check
pip install pre-commit

pre-commit install
git add .
pre-commit run --all
```

### Docker container build

```shell
make quay
make quay_multiarch
make quay_multiarch_latest

```
