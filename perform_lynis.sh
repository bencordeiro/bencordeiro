#!/bin/bash
#Lynis
echo
LYN=y 
    read -p "Lynis Security Audit? (Y/n)" var_lyn
    [ -n "$var_lyn" ] && LYN=$var_lyn

if [ $LYN = y ]; then
        git clone https://github.com/CISOfy/lynis
        cd lynis
        sudo ./lynis audit system --verbose
        echo 'Lynis Scan Completed!'
fi
