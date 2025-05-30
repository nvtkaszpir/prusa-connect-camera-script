# Running in Kubernetes

Yes, because why not, especially if you run [k3s](https://k3s.io/) :D

This is just an example but you should be able to adjust it to your needs.

See [directory](https://github.com/nvtkaszpir/prusa-connect-camera-script/tree/master/k8s)
for the content you can use with a [kustomize](https://kustomize.io/).

## Overview

- each camera should be a separate kubernetes deployment (or daemonset),
  easier to manage.

- in [configs](https://github.com/nvtkaszpir/prusa-connect-camera-script/tree/master/k8s/configs)
  there is a one file with env vars loaded per deployment,
  those env vars **MUST BE** changed as in env vars.
  Also do not use double quotes inside the values.

- deployment possible using for example [kustomize](https://kustomize.io/)

- camera device - if you have more cameras you probably want to use device
  by-id or by-path, see [tuning](./configuration.tuning.md) for more details

## Examples

- [deployment-1.yaml](https://github.com/nvtkaszpir/prusa-connect-camera-script/blob/master/k8s/deployment-1.yaml)
  is an example to fetch image from a stream using ffmpeg and with custom
  prusa-connect-camera.sh for easier development/iteration.
  This is also preferred option when you are not using cameras that are directly
  attached to the hosts, but rely on using ffmpeg to fetch images from remote
  streams or static images via curl.

- [deployment-2.yaml](https://github.com/nvtkaszpir/prusa-connect-camera-script/blob/master/k8s/deployment-2.yaml)
  is an example how to run it on Raspberry Pi with USB camera using default parameters.
  You want to change `.spec.nodeName` and volumes to point to desired host with
  the attached camera.

- [daemonset.yaml](https://github.com/nvtkaszpir/prusa-connect-camera-script/blob/master/k8s/daemonset.yaml)
  is an example how to run it on Raspberry Pi with USB camera using default parameters.
  You want to change `.spec.nodeName` and volumes to point to desired host with
  the attached camera.

The difference between the DaemonSet and Deployment is that with the Deployment
kubernetes will try to spawn new pods even if node is not available.
DaemonSet it is better when you have to use directly attached devices to the hosts.

Of course in that case you will need a daemonset per camera per host,
and separate config for each camera/host, and you would need the same with
a deployment, but at least when node is gone you are not getting non-schedulable
pod every few minutes - imagine hundreds of pods when I turned off one of my
Raspberry Pi for a week...
With a daemonset when node is gone, then pod is gone
and k8s is not trying to spawn new pods.

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
