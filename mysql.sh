cp mysql.repo /etc/systemd/system/mysql.repo
yum module disable mysql -y
yum install mysql-community-server -y
mysql_secure_installation --set-root-pass RoboShop@1
systemctl enable mysqld
systemctl restart mysqld