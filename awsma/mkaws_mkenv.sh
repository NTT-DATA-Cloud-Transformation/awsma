#!/bin/bash

add_profile_hook () {
    echo "Enter IAM account username:"
    read AWS_IAM_USER
    echo "Enter AWS_ACCESS_KEY_ID:"
    read AWS_ACCESS_KEY_ID
    echo "Enter AWS_SECRET_ACCESS_KEY:"
    read AWS_SECRET_ACCESS_KEY
#    echo "Does client use a bastion server:"
#    read AWS_BASTION
    echo "
{
  \"AWS_IAM_USER\": \"$AWS_IAM_USER\",
  \"AWS_ACCESS_KEY_ID\": \"$AWS_ACCESS_KEY_ID\",
  \"AWS_SECRET_ACCESS_KEY\": \"$AWS_SECRET_ACCESS_KEY\"
}
" > $JAMOORA_PROFILES/$1/aws-config
}

add_profile_hook $1
