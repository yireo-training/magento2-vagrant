#!/bin/bash
cp ~/.composer/auth.json vagrant_files/composer-auth.json
rm -r source
vagrant destroy -f
vagrant up
