#!/bin/bash

SLEEP=${SLEEP-1}
URL=${URL-www.google.com}
PORT=${PORT-80}
SCHEMA=${SCHEMA-http}
CONNECT=${URL}:${PORT}:${URL}:${PORT}
LOGDIR="${LOGDIR-.}"
NODENAME=${NODENAME-}
LOGFILE="${LOGDIR}/${NODENAME}_${HOSTNAME}_probe_--connect-to_${CONNECT}_${SCHEMA}:${URL}.log"
MESSAGEB64="1+nB5clA8fn1S/L3S/H280v4+UDy8PDy5uLT18nB09dA49nVycfz8fH2QPT2hKTio5jIQOjVwdPX
8/BA8PD28EDm8PLx+PD58PPy9vT08PL58/fx8PTw8/Lz8PDw8fD4+fn5+fn5QNXn+Nn149HG0kDF
1cRg1sZgwuTGxsXZ"

echo '"Date","HTTP Code","Redirect URL","Remote IP","Time Total(s)","Size Total(bytes)","DNS Lookup(s)","TCP Connect time(s)","TLS Connect time(s)","Redirect(s)","Pre Transfer(s)","Start Transfer(s)"' | tee -a "$LOGFILE"

probe(){
  while true; do
    echo -ne "${MESSAGEB64}" | base64 -d | curl -s $@
    #echo -ne "${MESSAGEB64}" | base64 -d | curl -w "\"$(date -u)\",\"%{http_code}\",\"%{redirect_url}\",\"%{remote_ip}\",\"%{time_total}\",\"%{size_download}\",\"%{time_namelookup}\",\"%{time_connect}\",\"%{time_appconnect}\",\"%{time_redirect}\",\"%{time_pretransfer}\",\"%{time_starttransfer}\"\n" -o /dev/null -s $@
  sleep $SLEEP
  done
}

probe --connect-to "$CONNECT" "${SCHEMA}://${URL}" | tee -a "$LOGFILE"
