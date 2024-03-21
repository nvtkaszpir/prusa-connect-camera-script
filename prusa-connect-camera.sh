#!/usr/bin/env bash

# basic config

# sleep time in seconds between image captures, notice that PrusaConnect accepts images at most every 10s or slower
: "${SLEEP:=10}"

# Printer address to ping
# if address is unreachable there is no point in sending an image
# set to 127.0.0.1 to always send images
# set to empty value to disable this feature
: "${PRINTER_ADDRESS:=127.0.0.1}"

# PrusaConnect API key
: "${PRUSA_CONNECT_CAMERA_TOKEN:=unset}"
# PrusaConnect camera fingerprint, use for example 'uuidgen' to generate it, it must be at least 16 alphanumeric chars, 40 max
: "${PRUSA_CONNECT_CAMERA_FINGERPRINT:=unset}"

# camera device to use, if you use camera attached to the CSI via camera ribbon then leave as is
: "${CAMERA_DEVICE:=/dev/video0}"

# camera setup command and params
# executed before taking image
# defualt is empty, because some cameras do not support it
# in general you want to use something like v4l2-ctl
# <setup_command>
# so for example:
# setup_command=v4l2-ctl --set-ctrl brightness=10,gamma=120 -d $CAMERA_DEVICE
# will translate to:
#   v4l2-ctl --set-ctrl brightness=10,gamma=120 -d /dev/video0
: "${CAMERA_SETUP_COMMAND:=}"

# avaliable options:
# rpicam-still - using CSI camera + modern Rasberry Pi operating systems since Debian 11 Bullseye
# raspistill - using CSI camera + older Raspberry Pi operating systems
# fswebcam - using USB camera + custom package 'fswebcam'
# anything else will be processed directly, so for example you could use 'ffmpeg' in here
: "${CAMERA_COMMAND:=rpicam-still}"

# extra params passed to the camera program, passed directly as <command> <extra-params> <output_file>
# libcamera (rpicam-still)
: "${CAMERA_COMMAND_EXTRA_PARAMS:=--immediate --nopreview --mode 2592:1944:12:P --lores-width 0 --lores-height 0 --thumb none -o }"
# raspistill
#: "${CAMERA_COMMAND_EXTRA_PARAMS:=--nopreview --mode 2592:1944:12:P -o }"
# fswebcam
#: "${CAMERA_COMMAND_EXTRA_PARAMS:=--resolution 1280x960 --no-banner }"
# ffmpeg, in this case CAMERA_DEVICE is ignored, use it directly in the extra params
#: "${CAMERA_COMMAND_EXTRA_PARAMS:=-f v4l2 -y -i /dev/video0 -f image2 -vframes 1 -pix_fmt yuvj420p }"

# where to save camera images (they will be overwritten every time
: "${TARGET_DIR:=/dev/shm}"
# extra params to curl when pushing an image
: "${CURL_EXTRA_PARAMS:=}"

## end of config, do not modify (unless you knw what you are doing)
: "${PRUSA_CONNECT_URL:=https://webcam.connect.prusa3d.com/c/snapshot}"

# validators
if ! [[ -w "${TARGET_DIR}" ]]; then
  echo "ERROR: ${TARGET_DIR} is not writable"
  echo "If you run in read only systems then ensure to mount ${TARGET_DIR} as write volume"
  exit 1
fi

if [[ "${PRUSA_CONNECT_CAMERA_TOKEN}" = "unset" ]]; then
  echo "ERROR: PRUSA_CONNECT_CAMERA_TOKEN env var is not set, please set it in the script or in the env vars"
  echo "Go to PrusaConnect site and add camera, copy Token and set in the script or in the env vars"
  exit 1
fi

if [[ "${PRUSA_CONNECT_CAMERA_FINGERPRINT}" = "unset" ]]; then
  echo "ERROR: PRUSA_CONNECT_CAMERA_FINGERPRINT env var is not set, please set it in the script or in the env vars"
  echo "You can use 'uuidgen' shell command to generate unique id, remember not to change it aferwards (or delete and add camera)"
  exit 1
fi

camera_id="${PRUSA_CONNECT_CAMERA_FINGERPRINT}"


if [[ ! -r "${CAMERA_DEVICE}" ]]; then
  echo "ERROR: Could not read camera device ${CAMERA_DEVICE}"
  echo "Are you sure current user can read that file?"
  echo "Did you enable camera in raspi-config and did reboot?"
  echo "Does the device exist? Check for missing kernel modules, disconnected cables..."
  echo "Use command "
  echo "  v4l2-ctl --list-devices"
  echo "to list available devices"
  echo "Also please see https://www.raspberrypi.com/documentation/computers/camera_software.html"
  exit 1
fi

# detect missing dependencies depending on camera capture method
if [[ "${CAMERA_COMMAND}" = "raspistill" ]]; then
  if type raspistill >/dev/null 2>/dev/null; then
    # older distros
    # ignoring CAMERA_DEVICE
    echo "Using raspistill"
    command_capture="raspistill"
  else
    echo "ERROR: Missing raspi-still command."
    echo "Run 'sudo apt install -y libraspberrypi-bin'"
    echo "Run 'raspi-config' and enable camera in the menu, then enable I2C and reboot device."
    exit 1
  fi
fi

if [[ "${CAMERA_COMMAND}" = "rpicam-still" ]]; then
  if type rpicam-still >/dev/null 2>/dev/null; then
    # newer distros
    # need to get number from device as camera_device
    camera_number=$(echo "${CAMERA_DEVICE}" | grep -oP '\d+')
    echo "Using libcamera"
    command_capture="rpicam-still --camera ${camera_number}"
  else
    echo "ERROR: Missing raspicam-still command."
    echo "Run 'sudo apt install -y rpicam-apps-lite'"
    echo "Run 'sudo raspi-config' and enable camera in the menu, then enable I2C and reboot device."
    exit 1
  fi
fi

if [[ "${CAMERA_COMMAND}" = "fswebcam" ]]; then
  if type fswebcam >/dev/null 2>/dev/null; then
    # newer distros
    echo "Using fswebcam"
    command_capture="fswebcam -d ${CAMERA_DEVICE}"
  else
    echo "ERROR: missing fswebcam package"
    echo "Run 'sudo install -y fswebcam'"
    exit 1
  fi
fi

if [[ -z "${command_capture}" ]]; then
  if type ${CAMERA_COMMAND} >/dev/null 2>/dev/null ; then
    echo "Using ${CAMERA_COMMAND}"
    command_capture="${CAMERA_COMMAND}"
  else
    echo "ERROR: missing ${CAMERA_COMMAND}"
    echo "No idea how to fix it because appareently this is a custom command."
    exit 1
  fi
fi


if [[ -z "${command_capture}" ]]; then
  echo "ERROR: Could not detect image capture method, aborting"
  exit 1
fi

CAMERA_SETUP_COMMAND
if [[ -n "${CAMERA_SETUP_COMMAND}" ]]; then
  echo "INFO: Running CAMERA_SETUP_COMMAND command"
  echo "${CAMERA_SETUP_COMMAND}"
  eval ${CAMERA_SETUP_COMMAND}
fi

echo "Camera capture command: ${command_capture} ${CAMERA_COMMAND_EXTRA_PARAMS} ${TARGET_DIR}/camera_${camera_id}.jpg"


trap "echo SIGINT received, exiting...; exit 0" INT

echo "Starting camera loop..."
while true; do
  if [[ -n "${PRINTER_ADDRESS}" ]]; then
    # check if printer is up
    if ! ping -q -4 -c1 -n -w 2 "${PRINTER_ADDRESS}" > /dev/null; then
      echo "WARNING: Printer not responding to ping at address ${PRINTER_ADDRESS}, skipping image capture"
      sleep "${SLEEP}"
      continue
    fi
  fi

  # clean up any old image to avoid some weird issues
  rm -f "${TARGET_DIR}/camera_${camera_id}.jpg"
  # perform image capture, write to /dev/shm to avoid killing slowly microSD card with writes
  eval "${command_capture}" ${CAMERA_COMMAND_EXTRA_PARAMS} "${TARGET_DIR}/camera_${camera_id}.jpg" \
    >"${TARGET_DIR}/camera_${camera_id}.stdout" \
    2>"${TARGET_DIR}/camera_${camera_id}.stderr"

  if ! [[ -r "${TARGET_DIR}/camera_${camera_id}.jpg" ]]; then
    echo "ERROR: Image not caputed!"
    cat "${TARGET_DIR}/camera_${camera_id}.stdout"
    cat "${TARGET_DIR}/camera_${camera_id}.stderr"
    echo "Please analyze above output and fix it. Aborting loop."
    exit 1
  fi

  # get captured image size, this is required by PrusaConnect API
  image_size=$(stat --printf="%s"  "${TARGET_DIR}/camera_${camera_id}.jpg")

  # push image to PrusaConnect, print return code, it should be 204 if all is ok, if not then you will see error message
  curl -X PUT "${PRUSA_CONNECT_URL}" \
    -H "Accept: text/plain" \
    -H "Content-type: image/jpg" \
    -H "Fingerprint: ${PRUSA_CONNECT_CAMERA_FINGERPRINT}" \
    -H "Token: ${PRUSA_CONNECT_CAMERA_TOKEN}" \
    -H "Content-length: ${image_size}" \
    --data-binary "@${TARGET_DIR}/camera_${camera_id}.jpg" \
    --no-progress-meter \
    --compressed \
    -w "%{http_code}\n" \
    ${CURL_EXTRA_PARAMS}

  sleep "${SLEEP}"
done
