#!/bin/bash
#
# Composer
#

# Install prestissimo
composer -q global require --no-progress "hirak/prestissimo:^0.3"

# Copy your composer credentials
mkdir -p ~/.composer
cp /vagrant/vagrant_files/composer-auth.json ~/.composer/auth.json

#
# Magento 2 setup
#

# First setup things in a VM non-shared folder, then move things, for best speed
destination=/home/vagrant/source
mkdir -p $destination
cd $destination

# Download all Magento packages
repoUrl=https://repo.magento.com/
#repoUrl=https://magento2mirror.yireo-dev.com/
composer -q create-project --prefer-dist --no-progress --repository-url=$repoUrl magento/project-community-edition .

if [ ! -f bin/magento ]; then
    echo "Magento installation seems to have failed"
    exit
fi

# Composer update
composer -q update --no-progress

# Make bin/magento executable
chmod 755 bin/magento

# Install Magento
php -d memory_limit=1G bin/magento setup:install \
    --base-url=http://192.168.70.70/ \
    --db-host=localhost \
    --db-name=magento2 \
    --db-user=root \
    --db-password=root \
    --backend-frontname=backend \
    --admin-firstname=John \
    --admin-lastname=Doe \
    --admin-email=johndoe@example.com \
    --admin-user=admin \
    --admin-password=admin123 \
    --language=en_US \
    --currency=EUR \
    --timezone=Europe/Amsterdam \
    --session-save=files \
    --cleanup-database \
    --use-rewrites=1 \
    --use-secure=0

# Set developer mode
php bin/magento deploy:mode:set developer

# Copy composer credentials
mkdir -p var/composer_home
cp /vagrant/vagrant_files/composer-auth.json var/composer_home/auth.json

# Sample data
php bin/magento sampledata:deploy
php bin/magento setup:upgrade

# Optimize composer
composer -q dump-autoload --optimize

# Enable Redis
cp /vagrant/vagrant_files/env.php.redis app/etc/env.php
rm -rf var/cache var/page_cache var/di var/generation

# Going live (this is going to take some time)
echo "Moving Magento 2 files to Vagrant shared folder"
cd /vagrant
mv $destination /vagrant/source
mkdir -p /vagrant/source/var/cache /vagrant/source/var/session

# Done
