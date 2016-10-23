### Purpose
Create an entry every n minutes in CouchDB database 
to serve as a backend for a web application 
to monitor the basic status of your ISP connection
### Requirements
1. Hardware supporting Linux.  
I recommend https://www.raspberrypi.org/ 
2. Linux. I use Raspbian Jessie
### Install
#### CouchDB
1. Install couchDB : `sudo apt-get install CouchDB`
2. Create a database : `curl -X PUT http://127.0.0.1:5984/ping`
### Nginx
1. Install : `sudo apt-get install nginx`
2. Place `couchdb.conf` in `/etc/nginx/sites-enabled`
3. Reload config : `nginx -s reload`
### Put script in place
1. In `/usr/local/bin`
2. Copy the `pingtest.sh` file (use sudo)  
or create the file using `sudo nano pingtest.sh`
3. `chmod a+x pingtest.sh`
### Cron
1. `sudo crontab -e`
2. Add a line : `*/5 * * * * /usr/local/bin/pingtest.sh`
which tel to run the command every 5 minutes
### Troubleshooting
* Troubleshoot pingtest
   * Edit `sudo nano /usr/local/bin/pingtest.sh` 
   * Add `echo ` in front of last line
   * Run : `sudo nano /usr/local/bin/pingtest.sh`
* Open CouchDB database : http://127.0.0.1:5984/_utils/database.html?ping  
### References
* CouchDB tutorial : http://docs.couchdb.org/en/2.0.0/intro/tour.html
