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


##########


#!/bin/bash

# Get a list of all images in the registry
images=$(docker images --format "{{.Repository}}:{{.Tag}}")

# Create a file to write the output
output_file="parent_images.txt"
touch $output_file

# Iterate through each image and write the parent image to the output file
for image in $images; do
  parent=$(docker inspect --format='{{.Parent}}' $image)
  echo "$image: $parent" >> $output_file
done

echo "Output written to $output_file"


########



curl -X GET -H "Accept: application/json" http://localhost:2375/images/nginx/history

docker history --no-trunc --format '{{.CreatedBy}}' <image> | grep -v '#(nop)' | tac


docker history --no-trunc $argv  | tac | tr -s ' ' | cut -d " " -f 5- | sed 's,^/bin/sh -c #(nop) ,,g' | sed 's,^/bin/sh -c,RUN,g' | sed 's, && ,\n  & ,g' | sed 's,\s*[0-9]*[\.]*[0-9]*\s*[kMG]*B\s*$,,g' | head -n -1


#######



#!/bin/bash

# Set the image name
image_name="nginx"

# Get the image ID
image_id=$(docker inspect --format='{{.Id}}' $image_name)

# Get the number of layers in the image
num_layers=$(docker history --format='{{.CreatedBy}}' $image_name | wc -l)

# Loop through each layer
for ((i=1; i<=$num_layers; i++)); do
  # Get the layer ID
  layer_id=$(docker history --format='{{.Id}}' $image_name | head -n $i | tail -n 1)

  # Get the commands used to create the layer
  commands=$(docker inspect --format='{{json .ContainerConfig.Cmd}}' $layer_id)

  # Display the layer ID and commands
  echo "Layer ID: $layer_id"
  echo "Commands: $commands"
  echo ""
done


resources
| where type == "microsoft.compute/virtualmachines"
| extend vm = tostring(id)
| join (resources
    | where type == "microsoft.security/securityagents"
    | where properties.productName == "Azure Security Center for VMs"
    | extend vm = tostring(properties.virtualMachineId)) on vm
| project vm, name


####

index=idata OR index=tldata
| eval index=if(index=="idata",1,2)
| stats values(key) as key by cve, index
| join type=left cve [search index=idata | stats values(key) as key by cve]
| eval missing=if(isnull(key), key2, "")
| search missing!=""
| table cve index key key2 missing



index=index1 OR index=index2
| eval index=if(index=="index1",1,2)
| stats values(<field1>) as <field1> by <field2>, index
| join type=left <field2> [search index=index1 OR index=index2 | stats values(<field2>) as <field2> by <field1>, index]
| eval missing=if(isnull(<field2>), <field1>, ""), missing2=if(isnull(<field1>), <field2>, "")
| search missing!="" OR missing2!=""
| table <field1> <field2> index missing missing2



index=index1
| eval index=1
| stats values(cve) as cve by key, index
| join type=left cve [search index=index2 | stats values(cve) as cve by key, index]
| eval missing=if(isnull(cve), key, "")
| search missing!=""
| table key cve index missing



index=index1
| eval index=1
| stats values(cve) as cve_index1 by cve, index
| join type=left cve [inputlookup cve_lookup | stats values(cve) as cve_lookup by cve, index]
| eval missing=if(isnull(cve_lookup), cve_index1, "")
| search missing!=""
| table cve_index1 index missing


index1 sourcetype="cve" NOT [search index2 sourcetype="key" | rename key as cve_key | fields cve_key]

