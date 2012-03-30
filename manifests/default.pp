
###############
#Uncomment the pieces you like, comment the rest out
###########

#Default, you need a good reason not to want these
include apt


#Choose which you like below
#include jenkins
#include sonar
#include mongodb
#include postgresql
#include nexus
#include x11
#include oraclejdks
#include devtools   #Install git, vim, emacs, network tools
#include xebium_ci

#Notices for user convenience
notice("You can connect to your guest services via: ${::ipaddress_eth1}")
notice("You reboot by using 'sudo reboot' after logging in with: vagrant ssh")



