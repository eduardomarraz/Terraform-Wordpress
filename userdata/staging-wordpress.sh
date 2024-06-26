#!/bin/bash

DOMAIN_NAME=wordpress-iac.demo.com

mkdir -p /var/www/html/
yum install -y httpd
systemctl start httpd
systemctl enable httpd
yum clean metadata
yum install -y php php-cli php-pdo php-fpm php-json php-mysqlnd php-dom
sed -i "/<Directory \/>/,/<\/Directory>/c\
<Directory \/>\n\
    Options FollowSymLinks\n\
    AllowOverride All\n\
<\/Directory>" /etc/httpd/conf/httpd.conf
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/httpd/conf/httpd.conf
yum install -y mod_ssl

# Create self signed key
openssl req -x509 -newkey rsa:4096 \
  -sha256 -days 3650 \
  -nodes \
  -keyout /etc/pki/tls/private/server.key \
  -out /etc/pki/tls/certs/server.crt \
  -subj "/C=USA/ST=CA/L=San Diego/O=Amazon Web Services/OU=WWPS ProServe/CN=$DOMAIN_NAME"


systemctl restart httpd
