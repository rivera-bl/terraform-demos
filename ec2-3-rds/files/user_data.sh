#!/bin/bash
echo "set -o vi" >> .bashrc
yum update -y
yum install -y \
  amazon-linux-extras \
  lamp-mariadb10.2 \
  php7.2 \
  httpd \
  mariadb-server \
  telnet
systemctl enable httpd && systemctl start httpd
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0644 {} \;
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
systemctl enable mariadb && systemctl start mariadb
mysql_secure_installation <<EOF


y
secret
secret
y
y
y
y
EOF
yum install php-mbstring php-xml –y
systemctl restart httpd
systemctl restart php-fpm
wget https://files.phpmyadmin.net/phpMyAdmin/5.1.3/phpMyAdmin-5.1.3-all-languages.tar.gz /var/www/html/phpMyAdmin-5.1.3-all-languages.tar.gz 
mkdir /var/www/html/phpMyAdmin && tar -xvzf /var/www/html/phpMyAdmin-5.1.3-all-languages.tar.gz -C/var/www/html/phpMyAdmin --strip-components 1
systemctl restart mariadb
