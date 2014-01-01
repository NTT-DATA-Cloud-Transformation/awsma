PATH=$PATH

jamoora-init() { 
    export JAMOORA_PROFILES=$HOME/.jamoora_profiles
    complete -W "$(ls $JAMOORA_PROFILES | grep -v \~)" jamoora
    export JAMOORA_ACTIVE_PROFILE='test'
    unset JAMOORA_ACTIVE_PROFILE
    jamoora-plugin
}

jamoora-load-profile() {
    if _jamoora_is_profile_active
    then 
        echo "Profile $JAMOORA_ACTIVE_PROFILE is already active. Leave it first."
        return 1
    fi
    source $JAMOORA/plugins/$JAMOORA_PLUGIN/load_hook $1
    export JAMOORA_ACTIVE_PROFILE=$1
    _jamoora_update_ps1
}

jamoora-leave-profile() {
    if ! _jamoora_is_profile_active
    then 
	echo "No profile active."
	return 1
    fi
    source $JAMOORA/plugins/$JAMOORA_PLUGIN/leave_hook
    _jamoora_update_ps1
    return 0
}

jamoora-add-profile () {
    if _jamoora_is_profile_active
    then 
        echo "Jamoora profile is active. Leave it first."
        return 1       
    fi

    mkdir $JAMOORA_PROFILES/$1
    source $JAMOORA/plugins/$JAMOORA_PLUGIN/add_hook $1
}

_jamoora-reset-prompt () {
    PS1=$JAMOORA_RESET_PS1
}

_jamoora_update_ps1 () {
    if _jamoora_is_profile_active
    then
       export JAMOORA_RESET_PS1=$PS1 
       PS1="($JAMOORA_ACTIVE_PROFILE) $PS1"
    else 
       PS1="$JAMOORA_RESET_PS1"
    fi
}

_jamoora_is_profile_active () {
    if [ -n "$JAMOORA_ACTIVE_PROFILE" ]
    then 
         return 0
    else 
         return 1
    fi
}

jamoora-plugin () {
    export JAMOORA_PLUGIN=aws
}

jamoora-reload-profile() {
    jamoora-switch $JAMOORA_ACTIVE_PROFILE
}

jamoora-switch-profile() {
   jamoora-leave-profile
   jamoora-load-profile $1
}

jamoora-list () {
    ls $JAMOORA_PROFILES
}

jamoora() { 
  case "$1" in
    init)   shift;  jamoora-init $*;;
    load)   shift;  jamoora-load-profile $*;;
    reload) shift;  jamoora-reload-profile $*;;
    leave)  shift;  jamoora-leave-profile $*;;
    switch) shift;  jamoora-switch-profile $*;;
    add)    shift;  jamoora-add-profile $*;;
    ls)     shift;  jamoora-list;;
    plugin) shift;  jamoora-plugin $*;;
    echo)   shift; echo $*;;
    *) echo "Unknown sub command" ;;
  esac
}

jamoora-init
