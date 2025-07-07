#!/bin/bash

SLEEP=${SLEEP-1}
URL=${URL-www.google.com}
PORT=${PORT-80}
SCHEMA=${SCHEMA-http}
CONNECT=${URL}:${PORT}:${URL}:${PORT}
LOGDIR="${LOGDIR-.}"
NODENAME=${NODENAME-}
LOGFILE="${LOGDIR}/probe.log"

echo '"Date","HTTP Code","Redirect URL","Remote IP","Time Total(s)","Size Total(bytes)","DNS Lookup(s)","TCP Connect time(s)","TLS Connect time(s)","Redirect(s)","Pre Transfer(s)","Start Transfer(s)"' | tee -a "$LOGFILE"

probe(){
  while true; do
    curl -L -w "\"$(date -u)\",\"%{http_code}\",\"%{redirect_url}\",\"%{remote_ip}\",\"%{time_total}\",\"%{size_download}\",\"%{time_namelookup}\",\"%{time_connect}\",\"%{time_appconnect}\",\"%{time_redirect}\",\"%{time_pretransfer}\",\"%{time_starttransfer}\"\n" -o /dev/null -s $@
  sleep $SLEEP
  done
}

probe --connect-to "$CONNECT" "${SCHEMA}://${URL}" | tee -a "$LOGFILE"
