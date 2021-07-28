#! /bin/bash

# EXPEDITOR_VERSION exists within the artifact_published workload

export DOCKER_CLI_EXPERIMENTAL=enabled

echo "--- Creating manifest for ${EXPEDITOR_TARGET_CHANNEL}"
docker manifest create "chef/chef:${EXPEDITOR_TARGET_CHANNEL}" \
  --amend "chef/chef:${EXPEDITOR_VERSION}-arm64" \
  --amend "chef/chef:${EXPEDITOR_VERSION}-amd64"

echo "--- Pushing manifest for ${EXPEDITOR_TARGET_CHANNEL}"
docker manifest push "chef/chef:${EXPEDITOR_TARGET_CHANNEL}"

if [[ $EXPEDITOR_TARGET_CHANNEL == "stable" ]]; then
  echo "--- Creating manifest for latest"
  docker manifest create "chef/chef:latest" \
    --amend "chef/chef:${EXPEDITOR_VERSION}-arm64" \
    --amend "chef/chef:${EXPEDITOR_VERSION}-amd64"

  echo "--- Pushing manifest for latest"
  docker manifest push "chef/chef:latest"

  # split the version and add the tags for major and major.minor
  version=(${EXPEDITOR_VERSION//./ })

  echo "--- Creating manifest for ${version[0]}"
  docker manifest create "chef/chef:${version[0]}" \
    --amend "chef/chef:${EXPEDITOR_VERSION}-arm64" \
    --amend "chef/chef:${EXPEDITOR_VERSION}-amd64"

  echo "--- Pushing manifest for ${version[0]}"
  docker manifest push "chef/chef:${version[0]}"

  echo "--- Creating manifest for ${version[0]}.${version[1]}"
  docker manifest create "chef/chef:${version[0]}.${version[1]}" \
    --amend "chef/chef:${EXPEDITOR_VERSION}-arm64" \
    --amend "chef/chef:${EXPEDITOR_VERSION}-amd64"

  echo "--- Pushing manifest for ${version[0]}.${version[1]}"
  docker manifest push "chef/chef:${version[0]}.${version[1]}"
fi