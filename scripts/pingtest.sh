#!/bin/bash
# couchdb="192.168.1.183:8080"
couchdb="127.0.0.1:5984"
# === Get timestamp (time stamp will be the id) ===
timestamp=$(date +%s)
# === Compute ping latency and packetloss ===
# == Get latency ==
latency=`ping -c 1 62.2.17.61 | tail -1| awk '{print $4}' | cut -d '/' -f 2`
latency2=`ping -c 1 62.2.17.60 | tail -1| awk '{print $4}' | cut -d '/' -f 2`
# ping -c 1 : do one ping 
# tail -1 : return last line. something like : rtt min/avg/max/mdev = 31.073/31.073/31.073/0.000 ms
# awk '{print $4}' : return the 4th group (space is separator)
# cut -d '/' -f 2 : return the second block between / so avg ping time
# == Get packetloss (10,20,30,...,100) ==
packetloss=`ping -c 10 62.2.17.61 | tail -2 | head -1 | grep -Po '[0-9]{1,3}(?=%)'`
packetloss2=`ping -c 10 62.2.17.60 | tail -2 | head -1 | grep -Po '[0-9]{1,3}(?=%)'`
# -c 10 : with 1 we will get 0 or 100%, with 10 packets we have more discrete values 0,10,20,..,100
# tail -2 : two last lines
# head -1 : first line of those two last lines
# grep -Po '[0-9]{1,3}(?=%)' : P=perl o=output the match [0-9] characters we want {1,3} 1 to 3 (?=%) before a %
# === DNS ===
host google.com 62.2.17.61
if [ $? -eq 0 ]; then
  dns="true"
else
  dns="false"
fi
host google.com 62.2.17.60
if [ $? -eq 0 ]; then
  dns2="true"
else
  dns2="false"
fi
# === WWWtest ===
wget -q --spider http://google.com
if [ $? -eq 0 ]; then
  www="true"
else
  www="false"
fi
# Speedtest
#!/bin/bash
# couchdb="192.168.1.183:8080"
couchdb="127.0.0.1:5984"
# === Get timestamp (time stamp will be the id) ===
timestamp=$(date +%s)
# === Compute ping latency and packetloss ===
# == Get latency ==
latency=`ping -c 1 62.2.17.61 | tail -1| awk '{print $4}' | cut -d '/' -f 2`
latency2=`ping -c 1 62.2.17.60 | tail -1| awk '{print $4}' | cut -d '/' -f 2`
# ping -c 1 : do one ping
# tail -1 : return last line. something like : rtt min/avg/max/mdev = 31.073/31.073/31.073/0.000 ms
# awk '{print $4}' : return the 4th group (space is separator)
# cut -d '/' -f 2 : return the second block between / so avg ping time
# == Get packetloss (10,20,30,...,100) ==
packetloss=`ping -c 10 62.2.17.61 | tail -2 | head -1 | grep -Po '[0-9]{1,3}(?=%)'`
packetloss2=`ping -c 10 62.2.17.60 | tail -2 | head -1 | grep -Po '[0-9]{1,3}(?=%)'`
# -c 10 : with 1 we will get 0 or 100%, with 10 packets we have more discrete values 0,10,20,..,100
# tail -2 : two last lines
# head -1 : first line of those two last lines
# grep -Po '[0-9]{1,3}(?=%)' : P=perl o=output the match [0-9] characters we want {1,3} 1 to 3 (?=%) before a %
# === DNS ===
host google.com 62.2.17.61
if [ $? -eq 0 ]; then
  dns="true"
else
  dns="false"
fi
host google.com 62.2.17.60
if [ $? -eq 0 ]; then
  dns2="true"
else
  dns2="false"
fi
# === WWWtest ===
wget -q --spider http://google.com
if [ $? -eq 0 ]; then
  www="true"
else
  www="false"
fi
# Speedtest
cmd_output=$(/usr/local/lib/python2.7/dist-packages/speedtest_cli.py --csv)
upload=$(echo $cmd_output | cut -d ',' -f 3)
download=$(echo $cmd_output | cut -d ',' -f 4)

curl -X PUT http://"${couchdb}"/ping/"${timestamp}" -d '{ "latency": "'${latency}'", "latency2": "'${latency2}'", "packetloss": "'${packetloss}'", "packetloss2": "'${packetloss2}'", "web": "'${www}'", "dns": "'${dns}'", "dns2": "'${dns2}'", "download":"'${download}'", "upload":"'${upload}'" }'