#! /usr/bin/
# CREATED BY: HT
#Date created: 2021-10-05
# Version 1

# this script is designed to gather system statistics

AUTHOR="HT"
VERSION="2"
RELEASED="2021-10-05"
FILE=~/ACE/systemStats.log 

# DISPLAY  HELP MESSAGE
 

 USAGE() {
     echo -e $1
     echo -e "\nUsage: systemStas [ - t temperature] [ -i ipv4 address] [-c cpu usage]"
     echo -e "\t\t  [ -v version]"
     echo -e "\t\t more information see man systemStats"

}

# check for arguments (error checking)
if [ $# -lt 1 ]; then
           USAGE  " Not enough arguments"
           exit 1
elif [ $# -gt 3 ]; then
           USAGE  " Too many arguments supplie"
           exit 1
elif [[ ( $1 == '- h' )  || ( $1 == ' --help' ) ]]; then
           USAGE  "Help!"
           exit 1

fi

# frequently a scripts are written so that arguments can be passed in  any order using 'flags'
# With the flags method, some of the arguments can be made mandatory or optional
# a:b  (a is mandatory, b is optional) abc is all optional

while getopts ctiv OPTION
do 
case  ${OPTION}
in
i) IP=$(ifconfig wlan0 | grep -w inet | awk '{print$2}')
   echo ${IP};;
c) USAGE=$( grep -w 'cpu' /proc/stat | awk '{usage=($2+$3+$4+$5+$6+$7+$8)*100/($2+$3+$4+$5+$6+$7+$8)}
                                              {free=($5)*100/($2+$3+$4+$5+$6+$7+$8)}
                                               END {printf "Used CPU: %.2f%%",usage}
                                                   {printf " Free CPU: %.2f%%",free}' )
    echo -e ${USAGE};;
t) TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
   echo ${TEMP} "need to divide by thousand...";;
v) echo -e "systemStats:\n\t   Version: ${version} Released: ${RELEASED} Author: ${AUTHOR}";;
esac
done

 NOW=$(date +%Y-%m-%dT%H:%M:%SZ)
        echo -e " ${NOW}\tIP:${IP} Temperature: ${TEMP} CPU: ${USAGE}" >> ${FILE}

# end of script
