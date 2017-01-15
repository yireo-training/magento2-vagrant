#!/bin/bash

#
# Vagrantfile init script hacked by @jissereitsma (@yireo)
#

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#
# Disable firewall
update-rc.d -f ufw remove

#
# Add Swap
#
#dd if=/dev/zero of=/swapspace bs=1M count=200 2>/dev/null
#chmod 600 /swapspace
#mkswap /swapspace
#swapon /swapspace
#echo "/swapspace none swap defaults 0 0" >> /etc/fstab

#
# Nameservers
#
#echo nameserver 8.8.8.8 > /etc/resolv.conf
#echo nameserver 8.8.4.4 >> /etc/resolv.conf

#
# Remove locks
#
#fuser -cuk /var/lib/dpkg/lock
rm -f /var/lib/dpkg/lock   

#
# Update all
#
apt-get update

#
# MySQL configuration
#
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get -y install mysql-server mysql-client
cp /vagrant/vagrant_files/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl start mysql
systemctl enable mysql

#
# Install Nginx
#
apt-get -y install nginx

#
# Installing NPM
#
apt-get -y install npm
ln -s /usr/bin/nodejs /usr/local/bin/node
npm install -g grunt-cli
npm install -g gulp-cli

#
# Magerun2
#
cd /tmp
wget -q https://files.magerun.net/n98-magerun2.phar 
chmod +x ./n98-magerun2.phar
mv /tmp/n98-magerun2.phar /usr/local/bin/magerun2

#
# Installing PHP 7
#
apt-get -y install php7.0-fpm
apt-get -y install php7.0-mysql php7.0-mysql php7.0-curl php7.0-gd php7.0-intl php7.0-imap php7.0-mcrypt php7.0-pspell php7.0-recode php7.0-sqlite3 php7.0-tidy php7.0-xmlrpc php7.0-xsl php7.0-mbstring php7.0-zip
apt-get -y install php-soap
apt-get -y install php-redis
apt-get -y install php-igbinary
#apt-get -y install phpmyadmin # @todo: get rid of interaction

#
# Configure PHP
#
echo "\ncgi.fix_pathinfo=0" >> /etc/php/7.0/fpm/php.ini
cp /vagrant/vagrant_files/php-fpm.conf /etc/php/7.0/fpm/pool.d/www.conf

#
# Setup locales
#
echo -e "LC_CTYPE=en_US.UTF-8\nLC_ALL=en_US.UTF-8\nLANG=en_US.UTF-8\nLANGUAGE=en_US.UTF-8" | tee -a /etc/environment &>/dev/null
locale-gen en_US en_US.UTF-8
#dpkg-reconfigure locales

#
# Composer
#
apt-get -y install composer

composer global require "hirak/prestissimo:^0.3"
mkdir -p ~/.composer
cp /vagrant/vagrant_files/composer-auth.json ~/.composer/auth.json

#
# Configure PHP-FPM
#
cat <<EOF > /etc/nginx/conf.d/php-fpm.conf
upstream php-fpm {  
    server 127.0.0.1:9000;
}
EOF

#
# Configure Nginx host
#
cp /vagrant/vagrant_files/nginx-magento2.conf /etc/nginx/sites-available/magento2
ln -s /etc/nginx/sites-available/magento2 /etc/nginx/sites-enabled/magento2
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default

#
# Reload services
#
systemctl restart nginx
service php7.0-fpm reload

#
# VirtualBox updates
#
apt-get -y install dkms
timedatectl set-timezone Europe/Amsterdam

#
# Redis configuration
#
apt-get -y install build-essential tcl
cd /tmp
curl -O http://download.redis.io/redis-stable.tar.gz
tar -xzf redis-stable.tar.gz
cd /tmp/redis-stable
make
make install
mkdir /etc/redis
cp /vagrant/vagrant_files/redis.conf /etc/redis 
cp /vagrant/vagrant_files/redis.service /etc/systemd/system/redis.service
adduser --system --group --no-create-home redis
mkdir /var/lib/redis
chown redis:redis /var/lib/redis
chmod 770 /var/lib/redis
systemctl start redis
systemctl enable redis

#
# MySQL databases
# 
echo "CREATE DATABASE magento2;" | mysql --user=root --password=root

