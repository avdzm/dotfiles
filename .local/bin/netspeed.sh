#!/usr/bin/bash

if [ -n "$1" ]; then
  if [ $1 = "wlp3s0" ]; then
    interface="" #sets the wifi symbol
  elif [ $1 = "enp2s0" ]; then
    interface="" #sets the ethernet symbol
  else
    interface="" #sets the network symbol if unkown
  fi
else 
  echo "interface not specified"
  exit 1
fi

rec1=$(cat /proc/net/dev | grep $1 | awk '{ print $2} ')  #Received
sent1=$(cat /proc/net/dev | grep $1 | awk '{ print $10} ') 
sleep 1
rec2=$(cat /proc/net/dev | grep $1 | awk '{ print $2} ')  #Sent
sent2=$(cat /proc/net/dev | grep $1 | awk '{ print $10} ')

rcrate="KB/s"
tsrate="KB/s"

trdiff=$(($rec2-$rec1))
trec=$(($trdiff/1024))

if [ ${#trec} -gt 3 ]; then
  trec=$(($trec/1024))
  rcrate="MB/s"
fi

tsdiff=$(($sent2-$sent1))
tsent=$(($tsdiff/1024))

if [ ${#tsent} -gt 3 ]; then
  tsent=$(($tsent/1024))
  tsrate="MB/s"
fi

printf "%s%s %.0f%s %s %.0f%s" ${interface}  ${trec} ${rcrate}  ${tsent} ${tsrate}
