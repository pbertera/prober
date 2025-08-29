#!/bin/bash


SLEEP=${SLEEP-1}
HOST=${HOST-www.google.com}
PORT=${PORT-80}
LOGDIR="${LOGDIR-.}"
NODENAME=${NODENAME-}
TIMEOUT=1
LOGFILE="${LOGDIR}/probe.log"
MESSAGEB64="1+nB5clA8fn1S/L3S/H280v4+UDy8PDy5uLT18nB09dA49nVycfz8fH2QPT2hKTio5jIQOjVwdPX
8/BA8PD28EDm8PLx+PD58PPy9vT08PL58/fx8PTw8/Lz8PDw8fD4+fn5+fn5QNXn+Nn149HG0kDF
1cRg1sZgwuTGxsXZ"

probe(){
  while true; do
    timeout 5 echo -n "${MESSAGEB64}" | base64 -d | nc -w ${TIMEOUT} $@
    if [ "$?" == "0" ]; then
      echo "$(date -u) OK"
    else
      echo "$(date -u) KO"
    fi
  sleep $SLEEP
  done
}

probe ${HOST} ${PORT} | tee -a "$LOGFILE"
