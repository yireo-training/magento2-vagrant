#!/bin/bash
#
# Composer
#
composer global require --no-progress "hirak/prestissimo:^0.3"
mkdir -p ~/.composer
cp /vagrant/vagrant_files/composer-auth.json ~/.composer/auth.json

#
# Magento 2 setup
#
mkdir -p /vagrant/source
cd /vagrant/source

composer create-project --prefer-dist --no-progress --repository-url=https://repo.magento.com/ magento/project-community-edition .
composer update --no-progress

chmod 755 bin/magento

php -d memory_limit=1G bin/magento setup:install \
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

mkdir -p var/composer_home
cp /vagrant/vagrant_files/composer-auth.json var/composer_home/auth.json

php bin/magento sampledata:deploy
php bin/magento setup:upgrade

composer dump-autoload --optimize
