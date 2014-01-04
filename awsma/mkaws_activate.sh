#!/bin/bash

load_profile_hook () {
    if [ ! -f $VIRTUAL_ENV/aws-config ]
    then 
	echo "AWS config $1 doesn't exist" 
        return 1
    fi

    if [ ! -f $VIRTUAL_ENV/ssh-config ]
    then 
	echo "SSH config for $1 doesn't exist at $VIRTUAL_ENV/ssh-config. Run mkaws_generate_ssh_config.sh to create one" 
    else
        cat ~/.ssh/config.default $VIRTUAL_ENV/ssh-config > $HOME/.ssh/config
    fi

    export AWS_ACCESS_KEY_ID=`cat $VIRTUAL_ENV/aws-config | jq -r '.AWS_ACCESS_KEY_ID'`
    export AWS_SECRET_ACCESS_KEY=`cat $VIRTUAL_ENV/aws-config  | jq -r '.AWS_SECRET_ACCESS_KEY'`
}

load_ssh_keys () {
    # this function must load all keys in $VIRTUAL_ENV/keys/
    eval `ssh-agent`
    ssh-add $VIRTUAL_ENV/ssh-keys/*.pem
}

load_bash_completions () {
    local list=`cat ~/.ssh/config | grep 'Host ' | cut -f2 -d' '`
    complete -W "`echo $list`" ssh
}

load_profile_hook $1
load_ssh_keys $1
load_bash_completions $1






