#! /bin/bash

#apt-get update
#apt-get install nginx -y

sudo yum -y install httpd && sudo systemctl start httpd
echo '<h1><center>My first website using Terraform provisioner</center></h1>' > index.html
echo '<h1><center>CIS Italy - Hello World</center></h1>' >> index.html
sudo mv index.html /var/www/html/