#!/bin/bash 

mkaws () { 
    local SAVE=$VIRTUALENVWRAPPER_HOOK_DIR
    export VIRTUALENVWRAPPER_HOOK_DIR=$JAMOORA/virtualenv/hooks
    export JAMOORA_PROFILES=$WORKON_HOME
    mkvirtualenv --no-pip --no-setuptools $1
    export VIRTUALENVWRAPPER_HOOK_DIR=$SAVE
    cp -r $JAMOORA/virtualenv/hooks/* $VIRTUAL_ENV/bin/.
}

mkaws $1
