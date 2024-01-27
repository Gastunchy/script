#!/bin/bash

echo "Actualizando apt"

sudo apt-get update

echo "================================"

echo "Instalacion de mariaDB"

sudo apt install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

echo "================================"

echo "Configuracion de la base de datos"

mysql -u root << EOF
CREATE DATABASE ecomdb;
CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
FLUSH PRIVILEGES;
exit
EOF

echo "================================"

echo "Agregar datos a la database ecomdb"

sudo cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");

EOF

sudo mysql < db-load-script.sql #insertar datos iniciales

echo "================================"

echo "Deploy and Configure Web"

sudo apt install apache2 -y
sudo apt install -y php libapache2-mod-php php-mysql

sudo systemctl start apache2 
sudo systemctl enable apache2 

sudo apt install git -y
git clone https://github.com/roxsross/The-DevOps-Journey-101.git
cp -r The-DevOps-Journey-101/CLASE-02/lamp-app-ecommerce/* /var/www/html/
mv /var/www/html/index.html /var/www/html/index.html.bkp

echo "================================"

echo "Actualizar index.php"

sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php

echo "================================"

systemctl reload apache2

echo "TERMINO!!! WEEEEE"
