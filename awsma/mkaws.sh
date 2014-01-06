#!/bin/bash 

########################################################################
#   Setup hooks for the new env. 
#   Setup the AWS account in the env. 
########################################################################

mkaws_usage() {
    echo "Usage: $0 environment_name aws_config_file [ssh key files]" 1>&2; return 1;
}

mkaws () {

     if test -z "$1"; then
         echo "must specify environment name"
         return 1
     fi
     
     local VENV=$1

     if test -z "$2"; then
	 echo "AWS config not provided"    
#	 source $VIRTUAL_ENV/$VIRTUALENVWRAPPER_ENV_BIN_DIR/postmkvirtualenv $1
         mkaws_usage
	 return 1
     else
         if [ ! -f $2 ]; then 
            echo "The provided AWS config file $2 does not exist"
            return 1
         fi
     fi

     # Get a new virtualenv 
     mkvirtualenv --no-pip --no-setuptools --system-site-packages  $1

     # Setup hooks 
     echo source mkaws_mkenv.sh '$(basename $VIRTUAL_ENV)' >> $VIRTUAL_ENV/$VIRTUALENVWRAPPER_ENV_BIN_DIR/postmkvirtualenv
     echo source mkaws_activate.sh '$(basename $VIRTUAL_ENV)' >> $VIRTUAL_ENV/$VIRTUALENVWRAPPER_ENV_BIN_DIR/postactivate
     echo source mkaws_deactivate.sh >> $VIRTUAL_ENV/$VIRTUALENVWRAPPER_ENV_BIN_DIR/postdeactivate

     cp $2 $VIRTUAL_ENV/aws-config

     #copy in ssh keys
     mkdir $VIRTUAL_ENV/ssh-keys
     shift
     shift

     while test $# -gt 0
     do
         if [ ! -f $1 ]; then 
            echo "The specified ssh key $1 does not exist"
            return 1
         else 
            cp "$1" "$VIRTUAL_ENV/ssh-keys/."
         fi
	 shift
     done
     
     deactivate
     workon $VENV
#     mkaws_generate_ssh_config.sh > $VIRTUAL_ENV/ssh-config
#     deactivate 
#     workon $VENV
}


#mkaws $*


