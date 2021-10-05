#! /usr/bin/
# CREATED BY: HT
#Date created: 2021-10-05
# Version 1

# this script is designed to gather system statistics

AUTHOR= "HT"
VERSION= "1"
RELEASED="2021-10-05"

# DISPLAY  HELP MESSAGE
 

 USAGE() {
     echo -e $1
     echo -e "\nUsage: systemStas [ - t temperature] [ -i ipv4 address]"
     echo -e "\t\t  [ -v version]"
     echo -e "\t\t more information see man systemStats"

}

# check for arguments (error checking)
if [ $# -lt 1]; then
           USAGE  " Not enough arguments"
           exit 1
elif [ $# -gt 3 ]; then
           USAGE  " Too many arguments supplie"
           exit 1
elif [[ ( $1 == '-h')  || ( $1 == ' --help' ) ]]; then
           USAGE  "Help!"
           exit 1

fi

# frequently a scripts are written so that arguments can be passed in  any order using 'flags'
# With the flags method, some of the arguments can be made mandatory or optional
# a:b  (a is mandatory, b is optional) abc is all optional

while getopts tiv OPTION
do 
case  ${OPTION}
in

