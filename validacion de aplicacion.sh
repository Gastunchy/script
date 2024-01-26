#!/bin/bash
read -p "Ingrese paquete: " paquete

if dpkg -l |grep -q $paquete ;
then 
        echo "El programa $paquete si existe"
else
        echo "El programa $paquete no existe"
        apt install -q -y $paquete
        echo "El programa $paquete fue instalado exitosamente"
fi