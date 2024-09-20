#! /bin/bash

#apt-get update
#apt-get install nginx -y

apt update -y
apt upgrade -y
apt install -y apache2
echo '<!DOCTYPE html><html><head><title>Azure Web Server</title><meta name="viewport" content="width=device-width, initial-scale=1"><meta name="description" content="This is a Web Server running on Azure"><style>body {background-color:#ffffff;background-repeat:no-repeat;background-position:top left;background-attachment:fixed;}h1{font-family:Verdana, sans-serif;color:#000000;background-color:#ffffff;}p {font-family:Verdana, sans-serif;font-size:14px;font-style:italic;font-weight:normal;color:#000000;background-color:#ffffff;}</style></head><body><h1>Hello World, from Azure!</h1><p>This is a web page provided by an Apache Web Server running on Azure!</p><p></p><p></p><p>Everything was created using a simple Terraform command.</p><p><a href="https://terraform.io"><img height="30" alt="Terraform Logo" src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Terraform_Logo.svg/512px-Terraform_Logo.svg.png"></a></p></body></html>' > /var/www/html/index.html
