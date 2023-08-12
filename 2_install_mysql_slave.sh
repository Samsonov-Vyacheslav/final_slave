#!/bin/sh

PASSWORD='!Ahhjntf0p02u1'
MASTER_HOST='192.168.1.36'
MASTER_PASSWORD='!Ahhjntf0p02u1'

#Установка и настройка MySQL 8.0
rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7-7.noarch.rpm
sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo
yum --enablerepo=mysql80-community install -y mysql-community-server
systemctl enable --now mysqld

#Временный пароль
pass=$(grep "A temporary password" /var/log/mysqld.log | awk '{print $NF}')

echo $pass

#Настрйока юзеров MySQL
echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'caching_sha2_password' BY '$PASSWORD'; FLUSH PRIVILEGES;" | mysql --connect-expired-password -uroot -p$pass

echo "SELECT @@server_id; CREATE USER 'root'@'%' IDENTIFIED BY '$PASSWORD'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; GRANT REPLICATION SLAVE ON *.* TO 'root'@'%'; FLUSH PRIVILEGES" |  mysql -uroot -p$PASSWORD

#Обновление индекса и настройка SLAVE
systemctl stop mysqld

rm -f /var/lib/mysql/auto.cnf

echo "bind-address = 0.0.0.0" >> /etc/my.cnf
echo "server_id = 2" >> /etc/my.cnf

systemctl start mysqld

#Добавление бэкапа баз в Cron
rsync -arvuP /tmp/final_slave/crontab /etc/crontab
chmod 0644 /etc/cron.d/
chmod 0644 /etc/crontab
systemctl reload crond.service
echo "add cron backup"
