#!/bin/bash
#
# Composer
#
composer global require "hirak/prestissimo:^0.3"
mkdir -p ~/.composer
cp /vagrant/vagrant_files/composer-auth.json ~/.composer/auth.json

#
# Magento 2 setup
#
cd /vagrant/source

composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .
composer update

chmod 755 bin/magento

php -d memory_limit=2G bin/magento setup:install \
    --base-url=http://192.168.70.70/ \
    --db-host=localhost \
    --db-name=magento2 \
    --db-user=root \
    --db-password=root \
    --backend-frontname=admin \
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

php bin/magento deploy:mode:set developer
php bin/magento sampledata:deploy
php bin/magento setup:upgrade

cp /vagrant/vagrant_files/composer-auth.json var/composer_home/auth.json
rm -f var/.maintenance.flag
