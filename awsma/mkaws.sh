#!/bin/bash 

########################################################################
#   Setup hooks for the new env. 
#   Setup the AWS account in the env. 
########################################################################

mkaws () {

     if test -z "$1"; then
         echo "must specify environment name"
         return 1
     fi

     # Get a new virtualenv created 
     SAVE=$VIRTUALENVWRAPPER_HOOK_DIR
     export VIRTUALENVWRAPPER_HOOK_DIR=$JAMOORA/virtualenv/hooks
     export JAMOORA_PROFILES=$WORKON_HOME
     mkvirtualenv --no-pip --no-setuptools $1
     export VIRTUALENVWRAPPER_HOOK_DIR=$SAVE


     # Setup hooks 

     HOOK_PATH=/usr/local/bin
     echo 'source $HOOK_PATH/mkaws_mkenv.sh $(basename $VIRTUAL_ENV)' >> $VIRTUAL_ENV/$VIRTUALENVWRAPPER_ENV_BIN_DIR/postmkvirtualenv
     echo 'source $HOOK_PATH/mkaws_activate.sh $(basename $VIRTUAL_ENV)' >> $VIRTUAL_ENV/$VIRTUALENVWRAPPER_ENV_BIN_DIR/postactivate
     echo 'source $HOOK_PATH/mkaws_deactivate.sh' >> $VIRTUAL_ENV/$VIRTUALENVWRAPPER_ENV_BIN_DIR/postdeactivate


     # setup AWS config  
     echo $2
     if test -z "$2"; then
	 echo "AWS config not provided"    
	 source $VIRTUAL_ENV/$VIRTUALENVWRAPPER_ENV_BIN_DIR/postmkvirtualenv $1
	 return 1
     else 
	 if [ -f $2 ]; then 
             cp $2 $VIRTUAL_ENV/aws-config
             echo "AWS config copied in"
	 else 
             echo "AWS config file provided is not present"
             return 1
	 fi
     fi
}

#mkaws $*
