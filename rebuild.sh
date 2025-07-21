#!/bin/bash

CONTAINER_NAME="sqlpharma"
IMAGE_NAME="sqlpharma"

echo " Stopping container..."
docker stop $CONTAINER_NAME 2>/dev/null || echo "Container not running."

echo " Removing container..."
docker rm $CONTAINER_NAME 2>/dev/null || echo "Container not found."

echo " Building image..."
docker build -t $IMAGE_NAME .

echo " Running container..."
docker run -d --name $CONTAINER_NAME -p 1433:1433 $IMAGE_NAME

echo " Done."
