PATH=$PATH

#$HOME/.rvm/bin # Add RVM to PATH for scripting

alias x=/Applications/Emacs.app/Contents/MacOS/Emacs

PS1="\$AWS_CLIENT \h:\W \u$"


client-init() { 

    export SSH_CONFIGS=$HOME/.ssh/
    export AWS_CONFIGS=$HOME/.aws/
    complete -W "$(ls $AWS_CONFIGS | grep -v \~)" client
#    aws ec2 describe-instances --region us-east-1  | jq -r --arg bastion "" --arg identities "~/.ssh/" --arg username "ubuntu" -f ~/tmp/filter > ~/.ssh/config.$AWS_CLIENT
}

client-init

client-add() {
### FIXME: Needs debugging
    if [ -n "$AWS_CLIENT" ]
    then 
         echo "You are workong on client $AWS_CLIENT. Leave it first using 'leave $AWS_CLIENT' command."
         return 
    fi 
    echo "Enter client name:" 
    read CLIENT
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
" > $AWS_CONFIGS/$CLIENT
}

client() {
    if [ -n "$AWS_CLIENT" ]
    then 
         echo "You are workong on client $AWS_CLIENT. Leave it first using 'leave $AWS_CLIENT' command."
         return 
    fi 
    if [ ! -f $SSH_CONFIGS/config.$1 ]
    then 
	echo "SSH config $1 doesn't exist" 
        return 
    fi

    if [ ! -f $AWS_CONFIGS/$1 ]
    then 
	echo "AWS config $1 doesn't exist" 
        return 
    fi

    export AWS_ACCESS_KEY_ID=`cat $AWS_CONFIGS/$1 | jq -r '.AWS_ACCESS_KEY_ID'`
    export AWS_SECRET_ACCESS_KEY=`cat $AWS_CONFIGS/$1 | jq -r '.AWS_SECRET_ACCESS_KEY'`
    export AWS_CLIENT=$1
    cat ~/.ssh/config.default $SSH_CONFIGS/config.$AWS_CLIENT > $HOME/.ssh/config
}

client-reload() {
    local _client=$AWS_CLIENT
    leave
    client $_client
}

leave() {

    if [ -n "$AWS_CLIENT" ]
    then 
	unset AWS_CLIENT
	unset AWS_ACCESS_KEY_ID
	unset AWS_SECRET_ACCESS_KEY
	fifo="$HOME/.ssh/config"
	cat ~/.ssh/config.default > "$fifo" 2>/dev/null  
    else
        echo "No profile active."
        return 
    fi 
}


