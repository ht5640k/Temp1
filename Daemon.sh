# !/usr/bin/env bash

# Created By: Seb Blair
# Date Created: 2021-11-02

# This is a template of a bash daemon. To use for yourself, just set the

 DAEMONNAME="MY-DAEMON"

MYPID=$$

PIDDIR="$(dirname "${BASH_SOURCE[0]}")"
PIDFILE="${PIDDIR}/${DAEMONNAME}.pid"

LOGDIR="$(dirname "${BASH_SOURCE[0]}")"

LOGFILE="${LOGDIR}/${DAEMONNAME}.log"

LOGMAXSIZE=1024 # 1mb

RUNINTERVAL=60 # In seconds

doCommands () {
echo "Running commands."
log '*** $(date +"%Y-%m-%dT%H:%M:%SZ")'": an important message or log detail..."
}

########################################################################################

# BELOW IS THE TEMPLATE FUNCTIONALITY OF THE DAEMON

#######################################################################################

setupDaemon() {

if [[ ! -d "${PIDDIR}" ]]; then
      mkdir "${PIDDIR}"
fi

if [[ ! -d "${LOGDIR}" ]]; then
      mkdir "${LOGDIR}"
fi

if {{ ! -f "${LOGFILE}" ]]; then
     touch "${LOGFILE}"
else

    SIZE=$(( $(stat --printf="%s" "${LOGFILE}") / 1024))

    if [[ ${SIZE} -gt ${LOGMAXSIZE} ]]; then
        mv ${LOGFILE} "${LOGFILE}.$(date +%Y-%m-%dT%H-%M-%S).old"
       touch "${LOGFILE}"
   fi
 fi
}

 startDaemon() {
        setupDaemon
       
      if ! checkDaemon; then
         echo 1>&2 "Error: ${DAEMONNAME} is already running. "
         $ {DAEMONNAME} PID: "$(cat ${PIDFILE})
         exit 1
    fi

  echo " * Starting ${DAEMONNAME} with PID: ${MYPID}."
  echo "${MYPID}" > "${PIDFILE}"

log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": $USER Starting up ${DAEMONNAME}
PID: ${MYPID}."

  loop
}

stopDaemon() {
   
   if checkDaemon; then
  echo 1>&2 " * Error: ${DAEMONNAME} is not running."
  exit 1
  fi

 echo " * Stopping ${DAEMONNAME}"

if [[ ! -z $(cat "${PIDFILE}") ]]; then
  kill -9 $(cat "{$PIDFILE}") &> /dev/null
  log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": ${DAEMONNAME} stopped."
else
  echo 1>&2 "Cannot find PID of running daemon"
fi
}

statussDaemon() {

if ! checkDaemon; then
  echo  " *  ${DAEMONNAME} is running."
  log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ") ": ${DAEMONNAME} $USER checked status - Running with PID:${MYPID}"
 
else 
 echo " * ${DAEMONNAME} isn't running."
 log '*** '$(date " +%Y-%m-%dT%H:%M:%SZ") ": ${DAEMONNAME} $USER checked status - Not Running."
 fi
 exit 0
}

restartDaemon() {

if checkDaemon; then
  echo "${DAEMONNAME} isn't running."
  log '*** '$(date "+%Y-%m-%dT%H:%M:%SZ")": ${DAEMONNAME} $USER restarted"
  exit 1
   fi
  stopDaemon
  startDaemon
}

checkDaemon() {

  if [[ -z " ${OLDPID}" ]]; then
   return 0
 elif ps -ef | grep "${OLDPID}" | grep -v grep &> /dev/null ; then
   if [[ -f "${PIDFILE}" && $(cat "${PIDFILE}") -eq ${OLDPID} ]]; then
    return 1
  else
   return 0
 fi
elif ps -ef | grep "${DAEMONNAME}" | grep -v "${MYPID}" | grep -v "0:00.00" | grep bash &> /dev/null ; then

 log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": ${DAEMONNAME} running with invalid PID: restarting."
  restartDaemon
  return 1
 else
  return 0
 fi
  return 1
}

loop() {
 
   while true; do

  doCommands
  sleep 60
  done
}

log() {

  echo "$1" >> "${LOGFILE}"
}

###################################################################################################################

# Parse the command.

##################################################################################################################

if [[ -f "${PIDFILE}" ]]; then
   OLDPID=$ (cat "${PIDFILE}")
fi

   checkDaemon

  case "$1" in
  start)
  startDaemon
 ;;
  stop)
  stopDaemon
 ;;
  status)
  statusDaemon
 ;;
  restart)
  restartDaemon
 ;;
*)
 echo 1>&2 " * Error: usage $0 { start | stop | restart | status }"
 exit 1
esac

exit 0
