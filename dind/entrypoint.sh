#!/bin/sh

ROS2_DISTRO="${1}"
APT_PACKAGES="${2}"
PIP_PACKAGES="${3}"
ADDITIONAL_CMAKE="${4}"
ADDITIONAL_CMAKE_COMMAND="${5}"
EXTERNAL_REPOS="${6}"
PRE_INSTALL="${7}"
POST_INSTALL="${8}"
PRE_BUILD="${9}"
POST_BUILD="${10}"
PRE_TEST="${11}"
POST_TEST="${12}"
SPECIFIC_PACKAGE="${13}"
echo ''
echo '======== Running the Docker daemon ========'
echo ''

dockerd-entrypoint.sh &
sleep 10

mkdir "/ros2/ws" && cp -r "${GITHUB_WORKSPACE}" "/ros2/ws/repo" || exit $?

echo ''
echo '======== Building the ROS 2 image ========'
echo ''


docker build \
  --build-arg ROS2_DISTRO="${ROS2_DISTRO}" \
  -t ros2-ci:latest /ros2 || exit $?

echo ''
echo '======== Running the ROS 2 container ========'
echo ''

docker run \
  --env APT_PACKAGES="${APT_PACKAGES}" \
  --env PIP_PACKAGES="${PIP_PACKAGES}" \
  --env ADDITIONAL_CMAKE="${ADDITIONAL_CMAKE}" \
  --env ADDITIONAL_CMAKE_COMMAND="${ADDITIONAL_CMAKE_COMMAND}" \
  --env EXTERNAL_REPOS="${EXTERNAL_REPOS}" \
  --env PRE_INSTALL="${PRE_INSTALL}" \
  --env POST_INSTALL="${POST_INSTALL}" \
  --env PRE_BUILD="${PRE_BUILD}" \
  --env POST_BUILD="${POST_BUILD}" \
  --env PRE_TEST="${PRE_TEST}" \
  --env POST_TEST="${POST_TEST}" \
  --env SPECIFIC_PACKAGE="${SPECIFIC_PACKAGE}" \
  --rm ros2-ci:latest || exit $?
