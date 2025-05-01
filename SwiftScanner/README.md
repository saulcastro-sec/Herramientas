# SwiftScanner
--------------------
SwiftScanner es una herramienta de automatización para escaneos de red con nmap, diseñada para facilitar la detección de puertos abiertos y realizar análisis detallados de servicios y versiones en un objetivo específico. Ofrece una interfaz visual mejorada con mensajes en color y una barra de progreso animada durante los escaneos prolongados.

## Características principales:
- Escaneo rápido de todos los puertos TCP utilizando nmap -p- --open -sS
- Identificación detallada de servicios, versiones y scripts comunes en los puertos abiertos (-sCV)
- Salida de resultados guardada automáticamente en un archivo fullscan_<IP>.txt
- Mensajes informativos y organizados con colores en consola
- Manejo de interrupciones con limpieza de procesos
- Indicador de progreso en tiempo real

## Requisitos:
- bash
- nmap

## Uso
```
./swiftscanner.sh <IP>
```

### Ejemplo

```
./swiftscanner.sh 192.168.1.10
```

## Descarga

```
wget https://raw.githubusercontent.com/saulcastro-sec/Herramientas/refs/heads/main/SwiftScanner/swiftscanner.sh
```
