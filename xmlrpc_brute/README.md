# WP-XMLRPC BruteForce

Este script automatiza un ataque de fuerza bruta contra el servicio XML-RPC de WordPress usando el método `wp.getUsersBlogs`. Está diseñado para verificar contraseñas válidas de un usuario específico utilizando un diccionario de contraseñas.

⚠️ **Uso exclusivo para propósitos educativos o entornos de prueba autorizados. No se debe utilizar en sistemas sin permiso.**

---

## Características

- Realiza ataques por fuerza bruta contra WordPress mediante XML-RPC
- Utiliza el diccionario `rockyou.txt` para probar múltiples contraseñas
- Interfaz por consola sencilla e intuitiva
- Manejo de interrupciones con `Ctrl+C`
- Detiene la ejecución al encontrar una contraseña válida

---

## Requisitos

- `bash`
- `curl`
- Acceso a un WordPress con XML-RPC habilitado
- Diccionario de contraseñas (`/usr/share/wordlists/rockyou.txt` o equivalente)

---

## ⚙️ Uso

1. Abre el script y modifica esta línea con la dirección IP o dominio de tu WordPress de prueba:

  ```bash
   response=$(curl -s -X POST "http://localhost:31337/xmlrpc.php" -d@file.xml)
  ```
2. Dale permisos de ejecución:

  ```bash
   chmod +x wp_xmlrpc_brute.sh
  ```
3. Ejecuta el script

  ```bash
   ./wp_xmlrpc_brute.sh
  ```
4. Ingresa el nombre de usuario objetivo cuando se te solicite.

  ```bash
   Introduce el nombre de usuario a atacar: admin
[+] La contraseña para el usuario admin es: 123456
  ```
## Diccionario
Este script utiliza por defecto el diccionario `rockyou.txt` ubicado en `/usr/share/wordlists/rockyou.txt`

Si deseas usar otro puedes modificar la siguiente línea del script
  ```bash
  cat /usr/share/wordlists/rockyou.txt | while read password; do
  ```


# ⚠️ Aviso Legal
El uso de esta herramienta está destinado únicamente para auditorías autorizadas, formación profesional y pruebas en entornos controlados. El uso indebido puede ser ilegal.
