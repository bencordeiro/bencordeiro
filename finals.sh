#!/bin/bash

##############################################################################################################

#Install PSAD
#PSAD actively monitors firewall logs to determine if a scan or attack is taking place
install_psad(){
clear
f_banner
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[+]\e[00m Install PSAD"
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo " PSAD is a piece of Software that actively monitors you Firewall Logs to Determine if a scan
       or attack event is in Progress. It can alert and Take action to deter the Threat
       NOTE:
       IF YOU ARE ONLY RUNNING THIS FUNCTION, YOU MUST ENABLE LOGGING FOR iptables
       iptables -A INPUT -j LOG
       iptables -A FORWARD -j LOG
       "
echo ""
echo -n " Do you want to install PSAD (Recommended)? (y/n): " ; read psad_answer
if [ "$psad_answer" == "y" ]; then
     echo -n " Type an Email Address to Receive PSAD Alerts: " ; read inbox1
     apt install psad
     sed -i s/INBOX/$inbox1/g templates/psad.conf
     sed -i s/CHANGEME/$host_name.$domain_name/g templates/psad.conf  
     cp templates/psad.conf /etc/psad/psad.conf
     psad --sig-update
     service psad restart
     echo "Installation and Configuration Complete"
     echo "Run service psad status, for detected events"
     echo ""
     say_done
else
     echo "OK"
     say_done
fi
}

##############################################################################################################

