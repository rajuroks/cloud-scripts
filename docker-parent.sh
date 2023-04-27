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



index="index1" cve!="" 
| stats values(cve) as cve_values
| eval cve_not_in_index2=mvjoin(cve_values, ",", "index2", "key", "!=")
| where cve_not_in_index2!="" 
| table cve_not_in_index2



######


import requests

class API:
    def __init__(self, url):
        self.url = url
    
    def get_data(self):
        response = requests.get(self.url)
        if response.status_code == 200:
            data = response.json()
            return data['data']
        else:
            return None

api_url = 'https://example.com/api/data'
api = API(api_url)
data = api.get_data()
if data:
    for item in data:
        print(item)
else:
    print('Failed to retrieve data from API.')
    
    
    
############# ######
import requests

class ApiData:
    def __init__(self, url):
        self.url = url
    
    def get_data(self):
        response = requests.get(self.url)
        if response.status_code == 200:
            json_data = response.json()
            data = json_data.get('data')
            if data:
                for item in data:
                    value_1 = item[0]
                    value_2 = item[1]
                    value_3 = item[2]
                    value_4 = item[3]
                    value_5 = item[4]
                    
                    print(f"Value 1: {value_1}")
                    print(f"Value 2: {value_2}")
                    print(f"Value 3: {value_3}")
                    print(f"Value 4: {value_4}")
                    print(f"Value 5: {value_5}")
                    
        else:
            print(f"Error retrieving data. Status code: {response.status_code}")
        
api = ApiData('https://example.com/api')
api.get_data()


###########
#########
    
    ###########
    
    
    Here is an example of a class in Python:

python
Copy code
class Car:
    def __init__(self, make, model, year):
        self.make = make
        self.model = model
        self.year = year
        self.mileage = 0

    def drive(self, miles):
        self.mileage += miles

    def get_description(self):
        return f"{self.year} {self.make} {self.model}"

    def get_mileage(self):
        return self.mileage
In this example, we define a Car class that has four attributes: make, model, year, and mileage. The __init__ method is a constructor that initializes the attributes with the values passed as arguments when the object is created.

The class also has three methods: drive, get_description, and get_mileage. The drive method takes a miles parameter and increments the mileage attribute by that amount. The get_description method returns a string with the car's make, model, and year. The get_mileage method returns the current mileage of the car.

With this class definition, we can create instances of Car objects and call their methods:

python
Copy code
my_car = Car("Toyota", "Corolla", 2021)
my_car.drive(100)
print(my_car.get_description())
print(my_car.get_mileage())
This code creates an instance of a Car object named my_car with a make of "Toyota", a model of "Corolla", and a year of 2021. It then calls the drive method to increment the mileage by 100 miles, and prints the car's description and mileage.




raju.roks@gmail.com
how the above example used to get car data from api
To use the Car class to get car data from an API, you would typically write a separate class that handles the API communication and data parsing. Here's an example:

python
Copy code
import requests

class CarApi:
    def __init__(self, api_url):
        self.api_url = api_url

    def get_car_data(self):
        response = requests.get(self.api_url)
        data = response.json()["data"]
        cars = []
        for car_data in data:
            make, model, year, mileage = car_data
            car = Car(make, model, year)
            car.drive(mileage)
            cars.append(car)
        return cars
In this example, we define a CarApi class that takes an API URL as an argument when it is instantiated. The get_car_data method sends a GET request to the API URL and parses the JSON response using the json method of the response object.

The method then creates a list of Car objects based on the data returned by the API. For each car data, it extracts the make, model, year, and mileage attributes, creates a new Car object with these attributes using the __init__ method of the Car class, and calls the drive method of the Car object to set the initial mileage. Finally, the method appends the Car object to the cars list and returns it.

To use the CarApi class to get car data from an API, you would instantiate a CarApi object with the API URL, and then call its get_car_data method:

python
Copy code
api_url = "https://example.com/api/cars"
car_api = CarApi(api_url)
cars = car_api.get_car_data()
for car in cars:
    print(car.get_description())
    print(car.get_mileage())
This code creates a CarApi object with the API URL and calls its get_car_data method to retrieve the car data. It then iterates over the list of Car objects returned by the method and prints the description and mileage of each car.




class vad:
    def __init__(self):
        self.values = [1, 3, 2, None]

class matrix:
    def __init__(self):
        self.values = [1, 2, None]

# Create instances of the two classes
v = vad()
m = matrix()

# Compare the two lists and print the values that are in matrix but not in vad
difference = set(m.values).difference(set(v.values))
for value in difference:
    print(value)
    
    
    ######
    
    
    
    # Find the set of values that are in matrix output but not in vad output
missing_values = matrix_set - vad_set

# Find the set of values that are in both vad and matrix output
common_values = vad_set & matrix_set

# Find the set of all values in vad and matrix output
all_values = vad_set | matrix_set

# Print the vad and matrix outputs and the missing values
print("VAD output:")
print(vad_output)
print("Matrix output:")
print(matrix_output)
print("Missing values:")
print(sorted(missing_values))

# Print the common and total values
print("Common values:")
print(sorted(common_values))
print("Total values:")
print(sorted(all_values))



{% extends 'base.html' %}

{% block content %}
  <h1>Missing Values</h1>
  <ul>
    {% for vaddiff in missing_values %}
      <li>{{ vaddiff.missing_value }}</li>
    {% empty %}
      <li>No missing values found.</li>
    {% endfor %}
  </ul>
{% endblock %}


<ul>
  {% for vaddiff in missing_values %}
    <li>{{ vaddiff.missing_value.split(':')[1] }}</li>
  {% endfor %}
</ul>


