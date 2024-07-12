# Running in kubernetes

Yes, because why not, especially if you run k3s :D

This is just an example but you should be able to adjust it to your needs.

See [directory](https://github.com/nvtkaszpir/prusa-connect-camera-script/tree/master/k8s)
for the content you can use with a [kustomize](https://kustomize.io/).

## Overview

- each camera should be a separate kubernetes deployment, easier to manage.

- in [configs](https://github.com/nvtkaszpir/prusa-connect-camera-script/tree/master/k8s/configs)
  there is a one file with env vars loaded per deployment,
  those env vars **MUST BE** changed as in env vars
  Also do not use double quotes the values.

- deployment possible using for example kustomize

## Examples

- [deployment-1.yaml](https://github.com/nvtkaszpir/prusa-connect-camera-script/blob/master/k8s/deployment-1.yaml)
  is an example to fetch image from a stream using ffmpeg and with custom
  prusa-connect-camera.sh for easier development/iteration

- [deployment-2.yaml](https://github.com/nvtkaszpir/prusa-connect-camera-script/blob/master/k8s/deployment-2.yaml)
  is an example how to run it on Raspberry Pi with USB camera using default parameters.
  You want to change `.spec.nodeName` and volumes to point to desired camera.

## More copies

If you want to add more cameras then you should:

- copy example config file from `config/` and adjust it
- copy desired deployment.yaml and adjust it
- update any `cam-x` references in the deployment.yaml
- update `.spec.nodeName` in the deployment.yaml
- if using direct camera update volumes -  `dev-video` hostpath to point to the desired
  camera device

- fine tune requests/limits to use less resources if needed

## Troubleshooting

- just look into the logs of the failing pods
- some hosts do not have predictable camera names, will have to think about udev
  rules how to handle it...

- not tested with any device operators
- not tested with istio/traefik whatever.
