#!/bin/bash
# couchdb="192.168.1.183:8080"
couchdb="127.0.0.1:5984"
# === Get timestamp (time stamp will be the id) ===
timestamp=$(date +%s)
# === Compute ping latency and packetloss ===
# == Get latency ==
latency=`ping -c 1 8.8.8.8 | tail -1| awk '{print $4}' | cut -d '/' -f 2`
# ping -c 1 : do one ping 
# tail -1 : return last line. something like : rtt min/avg/max/mdev = 31.073/31.073/31.073/0.000 ms
# awk '{print $4}' : return the 4th group (space is separator)
# cut -d '/' -f 2 : return the second block between / so avg ping time
# == Get packetloss (10,20,30,...,100) ==
packetloss=`ping -c 10 8.8.8.8 | tail -2 | head -1 | grep -Po '[0-9]{1,3}(?=%)'`
# -c 10 : with 1 we will get 0 or 100%, with 10 packets we have more discrete values 0,10,20,..,100
# tail -2 : two last lines
# head -1 : first line of those two last lines
# grep -Po '[0-9]{1,3}(?=%)' : P=perl o=output the match [0-9] characters we want {1,3} 1 to 3 (?=%) before a %
# === DNS ===
host google.com
if [ $? -eq 0 ]; then
  dns="true"
else
  dns="false"
fi
# === WWWtest ===
wget -q --spider http://google.com
if [ $? -eq 0 ]; then
  www="true"
else
  www="false"
fi
curl -X PUT http://"${couchdb}"/ping/"${timestamp}" -d '{"latency": "'${latency}'" , "packetloss": "'${packetloss}'" , "web": "'${www}'" , "dns": "'${dns}'" }'