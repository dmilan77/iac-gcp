#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPTPATH/../terraform

rm -rf  .terraform
terraform init
terraform plan -out tfout
terraform apply "tfout"
 


