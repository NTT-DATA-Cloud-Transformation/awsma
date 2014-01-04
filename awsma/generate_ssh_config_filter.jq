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
