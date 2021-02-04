#!/bin/bash

set -ex


tag="1bpComplexVar"

AWS_ECR="267795504649.dkr.ecr.us-east-1.amazonaws.com"

ssh_pub_key=$(cat ~/.ssh/id_rsa_sema4.pub)
ssh_prv_key=$(cat ~/.ssh/id_rsa_sema4)

docker build . -t $AWS_ECR/s4-frankenstein:$tag --build-arg ssh_prv_key="$ssh_prv_key" --build-arg ssh_pub_key="$ssh_pub_key"

docker push $AWS_ECR/s4-frankenstein:$tag
