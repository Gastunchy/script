#!/bin/bash

REPO="cr-update-page"

sudo apt-get update #Actualizar

#Validar e instalar apache2
if dpkg -l |grep -q apache2
then
        echo "apache2 esta instalado"
else sudo apt-get install apache2 -y
fi

sudo systemctl start apache2 # Inicia apache2
sudo systemctl enable apache2 # habilita automáticamente en el arranque del sistema apache2

#Validar e instalar git
if dpkg -l |grep -q git
then
        echo "git esta instalado"
else sudo apt-get install git -y
fi

sudo systemnctl start git
sudo systemctl enable git

echo "================================"

echo "Testeando git (clone y pull)"

if [ -d $REPO ] ;
then
        #El siguiente codigo actualiza un repo directamente sin ingresar a el
        sudo git --git-dir=$REPO/.git pull
        echo "$REPO -> actualizado"
else
        sudo git clone https://github.com/Gastunchy/$REPO.git
        echo "$REPO -> clonado"
fi

sudo cp $REPO/* /var/www/html

echo "fin"
echo "================================"
