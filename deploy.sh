#!/bin/bash

set -xe
cd go && make && cd -
now=$(date +%Y%m%d-%H%M%S)

for h in 1
do
   rsync -av  --exclude '.git' ./ isucon${h}:/home/isucon/isucari/webapp/
   ssh isucon${h} sudo systemctl restart isucari.golang.service
   ssh isucon${h} sudo cp /home/isucon/isucari/webapp/nginx${h}.conf /etc/nginx/nginx.conf
   ssh isucon${h} sudo cp /home/isucon/isucari/webapp/mysqld${h}.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
done

# nginx
for h in 1
do
   ssh isucon${h} sudo touch /var/log/nginx/access.log
   ssh isucon${h} sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.$now
   ssh isucon${h} sudo systemctl restart nginx
done

# mysql
for h in 1
do
   ssh isucon${h} sudo touch /var/log/mysql/mysql-slow.log
   ssh isucon${h} sudo mv /var/log/mysql/mysql-slow.log /var/log/mysql/mysql-slow.log.$now
   ssh isucon${h} sudo mysqladmin flush-logs
   ssh isucon${h} sudo systemctl restart mysql
done
