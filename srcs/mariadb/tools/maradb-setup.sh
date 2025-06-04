#!bin/bash

set -x

#prepare WordPress Database
sudo mysql -u root
#add some password stizzle
#login:
#sudo mysql -u root -p

#create database
#todo -> change to own names
CREATE DATABASE wordpress;
CREATE USER 'wpuser' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser';
FLUSH PRIVILEGES;
