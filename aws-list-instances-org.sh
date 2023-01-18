#!/bin/bash

# Get a list of all accounts in the organization
accounts=$(aws organizations list-accounts --output json)

# Loop through each account
for account in $(echo "$accounts" | jq -r '.Accounts[].Id'); do
  # Switch to the current account using the --profile option
  export AWS_PROFILE="arn:aws:organizations::$account"

  # Get a list of all instances in the current account
  instances=$(aws ec2 describe-instances --output json)

  # Print the instance IDs
  echo "Instance IDs in account $account:"
  echo "$instances" | jq -r '.Reservations[].Instances[].InstanceId'
done
