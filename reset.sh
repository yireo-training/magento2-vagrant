#!/bin/bash
git reset --hard HEAD
git pull origin master
vagrant destroy -f
vagrant up
