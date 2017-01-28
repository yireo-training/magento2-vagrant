#!/bin/bash
#
# Composer
#

# Install prestissimo
composer global require --no-progress "hirak/prestissimo:^0.3"

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
composer create-project --prefer-dist --no-progress --repository-url=$repoUrl magento/project-community-edition .
composer update --no-progress

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
composer dump-autoload --optimize

# Make sure var/ folders are not within VM shared folder
cd var/

mkdir -p /tmp/magento-var/cache
rm -r cache
ln -s /tmp/magento-var/cache .

mkdir -p /tmp/magento-var/page_cache
rm -r page_cache
ln -s /tmp/magento-var/page_cache .

mkdir -p /tmp/magento-var/view_preprocessed/
rm -r view_preprocessed/
ln -s /tmp/magento-var/view_preprocessed/ .

echo "Moving Magento 2 files to Vagrant shared folder"
cd /vagrant
mv $destination /vagrant/source

# Done
