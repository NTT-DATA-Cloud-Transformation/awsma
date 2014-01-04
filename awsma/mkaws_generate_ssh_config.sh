#!/bin/bash

mkaws_generate_ssh_config () {
    local BASTION=$1
    local USERNAME=$2

    local VENV=$(basename $VIRTUAL_ENV)
    
    echo '
DISCLAIMER: This config is a best effort. Every setup is different
so validate the config file after it has been created'
    
    aws ec2 describe-instances | jq -r --arg bastion $BASTION --arg username $USERNAME -f generate_ssh_config_filter.jq > $VIRTUAL_ENV/ssh-config
    
#    deactivate 
#    workon $VENV 

    echo "The ssh-config file has been created and loaded"
}

mkaws_generate_ssh_config $*
