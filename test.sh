#!/bin/bash

REGISTRY_STORE=localhost:5000
REGISTRY_PASSTHRU=localhost:5001
CONTAINER_NAME=foo/test-container-${RANDOM}


docker pull library/alpine

docker tag library/alpine ${REGISTRY_STORE}/${CONTAINER_NAME}

docker push ${REGISTRY_STORE}/${CONTAINER_NAME}

echo "Request the manifest to the passthru registry fails:"

curl ${REGISTRY_PASSTHRU}/v2/${CONTAINER_NAME}/manifests/latest

read -p "Press any key" x

echo "Request the manifest to the passthru registry works if you pass a accept v2:"

curl ${REGISTRY_PASSTHRU}/v2/${CONTAINER_NAME}/manifests/latest \
	-H 'Accept: application/vnd.docker.distribution.manifest.v2+json'

echo "But without fails"

curl ${REGISTRY_PASSTHRU}/v2/${CONTAINER_NAME}/manifests/latest

read -p "Press any key" x

echo "Request the manifest to the store registry DOES work:"

curl ${REGISTRY_STORE}/v2/${CONTAINER_NAME}/manifests/latest

read -p "Press any key" x

echo "After that, it also works in the passthru one:"

curl ${REGISTRY_PASSTHRU}/v2/${CONTAINER_NAME}/manifests/latest

