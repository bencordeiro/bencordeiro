#!/bin/bash
#Script by Ben Cordeiro

script_log() {
#Borrowed Code Begins from my other script!!!
    ############## LogFile setup #################
LOG=y
    read -p 'Log this session? (ENTER for default)[Y/n] ' answer
    [ -n "$answer" ] && LOG=$answer
echo

if [ $LOG = y ]; then
    LOGFILENAME=session.log  #/home/anonymous/scripts/log.txt
    LOGPATH=$(pwd)

    read -p "Name of log file (ENTER for default)[${LOGFILENAME}]: " newname
    [ -n "$newname" ] && LOGFILENAME=$newname
echo

  ## COULD ASk FOR LOCATION AND VERIFY for / or just ask for full path to file
  ## comment to remove path input
    read -p "Location of log file (ENTER for default)[${LOGPATH}]: " newloc
    [ -n "$newloc" ] && LOGPATH=$newloc
echo

  LOGFULLPATH="${LOGPATH}/${LOGFILENAME}"

    echo -e "Log file Full path set: ${LOGFULLPATH}"
echo

  exec > >(tee $LOGFULLPATH) 2>&1
fi
#Borrowed Code Ends
}

Help()
{
   # Display Help
   echo "Find hidden CTF Flags."
   echo
   echo "Syntax: sudo ./ctf_solve.sh [-p|-l|-h|-d] [-f] 'file.flag'"

   echo "options:"
   echo "-p     Flag Perameters."
   echo "-f     Flag File (Secondary)."
   echo "-l     Log Script."
   echo "-h     Display Help."
   echo "-v     Verbose Mode."
   echo "-d     Perform Dependency Check."
}
    ### Dep Check
chk() {
		sudo apt list --installed | grep -i 'steghide\|exiftool\|foremost'
	if [ $? -eq 0 ]; then
		U_U=y
		echo
			echo "Looks like you have the correct tools."
		echo
			read -p "Update Anyway? (Y/n)" var_U
			[ -n "$var_U" ] && U_U=$var_U
	
		if [ $U_U = y ]; then
			req
		fi
	
	else
		req
	fi

}
 ############## Required Dependencies ##############
req() {
echo
D=y
    read -p "Install Required Dependencies? (Y/n)" var_d
    [ -n "$var_d" ] && D=$var_d

if [ $D = y ]; then
        sudo apt-get update && sudo apt-get upgrade -y
        sudo apt-get install exiftool libimage-exiftool-perl binutils
        sudo apt-get install git -y
fi
}

#var for flag parameters
flag_form="CTF"
flag_file="flag.txt"
while getopts ":hdp:f:" option; do
   case $option in
      h) # display help function
         Help
         exit;;
      f) # Flag file
		 flag_file=$OPTARG;;
      d) # Run dep chk then if chk fails run req
		 chk
		 exit;;
      p) # Flag Format then runs script
		 flag_form=$OPTARG;;
      \?) # Invalid option
		 echo "Error: Invalid Option"
		 exit;;
   esac
done


 ## Wizard begins

# Only run If root
if [ "$USER" != "root" ]; then
      echo "Permission Denied"
      echo "Can only be run by root"
      echo
      exit
fi

script_log

echo "Welcome your flag parameter is $flag_form"
echo "The flag file is $flag_file"
echo
	# Searching on plain text platforms...
echo "Searching in plain text. (cat)"
echo
	cat $flag_file | grep -i $flag_form
	if [ $? -eq 0 ]; then
		PF1="$(cat $flag_file | grep -i $flag_form)"
		echo "$PF1" >> CTF.out
	#OR [||] VAR=`command-name`
	### VAR="`cat $flag_file | grep -i $flag_form`"
	echo
		echo "Searching in strings."
	echo
		strings $flag_file | grep -i $flag_form
		if [ $? -eq 0 ]; then
			PF2="$(strings $flag_file | grep -i $flag_form)"
			echo "$PF2" >> CTF.out
			exit
		fi
	else
			echo "Nothing on plaintext platforms."
			echo "Maybe check hex."
	fi
echo
	echo "Lets check exifdata!"
	exiftool $flag_file | grep -i $flag_form
	if [ $? -eq 0 ]; then
		PF3="$(exiftool $flag_file | grep -i $flag_form)"\
		echo "$PF3 >> CTF.out"
	else
		echo "The flag could be:"
		echo "Encrytped"
		echo "Have Letter Substitiution / Cipher"
		echo "Not be in plaintext or exifdata"
	fi
