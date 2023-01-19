#!/bin/bash

# Set the registry URL
REGISTRY_URL=myregistry.com

# Create a new file to store the output
touch output.txt

# Get a list of all images in the registry
IMAGES=$(curl -s $REGISTRY_URL/v2/_catalog | jq -r '.repositories[]')

# Loop through each image
for IMAGE in $IMAGES; do
  # Get the base image for the current image
  BASE_IMAGE=$(curl -s $REGISTRY_URL/v2/$IMAGE/tags/list | jq -r '.name')

  # Append the current image and its base image to the output file
  echo "$IMAGE: $BASE_IMAGE" >> output.txt
done

echo "Base images for all images in registry have been written to output.txt"
