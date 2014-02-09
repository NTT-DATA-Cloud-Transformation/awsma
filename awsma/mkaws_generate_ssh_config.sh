#!/bin/bash

mkaws_generate_ssh_config () {
    local USERNAME=$1
    local BASTION=$2

    local VENV=$(basename $VIRTUAL_ENV)
    
    echo '
DISCLAIMER: This config is a best effort. Every setup is different
so validate the config file after it has been created'
    
    aws ec2 describe-instances | jq -r --arg bastion $BASTION --arg username $USERNAME '
.Reservations[].Instances[] 
| 
select(.State.Code == 16) 
| 
{
  KeyName, 
  name: .Tags[0].Value,
  PrivateIpAddress,
  PublicIpAddress
}
| 
( 
"Host " + .name + "\n" 
+ "HostName " + if .PublicIpAddress then .PublicIpAddress else .PrivateIpAddress end + "\n" 
+ "User " +  if $username then $username else "ubuntu" end + "\n"  
#+ "IdentityFile " + "\"" + if $identities then $identities else "~/.ssh" end + .KeyName + ".pem\"\n" 
+ if .PublicIpAddress then "" else "ProxyCommand ssh " + $bastion + " exec nc %h %p" + "\n" end
)
' > $VIRTUAL_ENV/ssh-config
    
#    deactivate 
#    workon $VENV 

    echo "The ssh-config file has been created and loaded"
}

mkaws_generate_ssh_config $*
