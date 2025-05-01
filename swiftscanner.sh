#!/usr/bin/env bash

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

# Banner nuevo
function show_banner {
    clear
    echo -e "${CYAN}"
    echo "   _____         _  __ _    _____                                "
    echo "  / ____|       (_)/ _| |  / ____|                               "
    echo " | (_____      ___| |_| |_| (___   ___ __ _ _ __  _ __   ___ _ __ "
    echo "  \___ \ \ /\ / / |  _| __|\___ \ / __/ _\` | '_ \| '_ \ / _ \ '__|"
    echo "  ____) \ V  V /| | | | |_ ____) | (_| (_| | | | | | | |  __/ |   "
    echo " |_____/ \_/\_/ |_|_|  \__|_____/ \___\__,_|_| |_|_| |_|\___|_|   "
    echo "                                                                  "
    echo "                                                                  "
    echo -e "${NC}"
    echo -e "${YELLOW}================================================================================${NC}"
    echo -e "${BLUE}                   Herramienta de Escaneo de Puertos                     ${NC}"
    echo -e "${YELLOW}================================================================================${NC}"
    echo -e "${ORANGE} Version 2.0 | by SaulCastro | $(date +'%Y') ${NC}\n"
}

show_banner

# Validación de argumentos
if [[ $# -ne 1 ]]; then
    echo -e "\n${RED}┌──────────────────────────────────────────────────────────────┐"
    echo -e "│${RED}      ERROR: Argumentos incorrectos ${NC}                      │"
    echo -e "└──────────────────────────────────────────────────────────────┘"
    echo -e "${YELLOW}\nUso correcto: $0 <IP>"
    echo -e "Ejemplo: $0 192.168.1.1${NC}\n"
    exit 1
fi

IP="$1"

# Validación de formato IP básico
if ! [[ $IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}┌──────────────────────────────────────────────────────────────┐"
    echo -e "│${RED}      ERROR: Formato de IP inválido ${NC}                      │"
    echo -e "└──────────────────────────────────────────────────────────────┘"
    echo -e "${YELLOW}\nPor favor ingrese una dirección IPv4 válida"
    echo -e "Ejemplo: 192.168.1.1${NC}\n"
    exit 1
fi

# Función para manejar interrupciones
function cleanup {
    echo -e "\n${RED}┌──────────────────────────────────────────────────────────────┐"
    echo -e "│${RED}      ESCANEO INTERRUMPIDO - Limpiando procesos... ${NC}       │"
    echo -e "└──────────────────────────────────────────────────────────────┘"
    if [[ -n $NMAP_PID ]] && ps -p $NMAP_PID > /dev/null; then
        kill -9 $NMAP_PID 2>/dev/null
    fi
    exit 1
}
trap cleanup SIGINT SIGTERM

# Escaneo de puertos inicial
echo -e "${BLUE}[*] Fase 1: Escaneo rápido de puertos abiertos en ${YELLOW}$IP${BLUE}...${NC}"
OPEN_PORTS=$(nmap -p- --open -sS --min-rate 5000 -n -Pn "$IP" 2>/dev/null | grep '^[0-9]' | cut -d '/' -f 1 | tr '\n' ',' | sed 's/,$//')

if [[ -z "$OPEN_PORTS" ]]; then
    echo -e "\n${RED}┌──────────────────────────────────────────────────────────────┐"
    echo -e "│${RED}      NO SE ENCONTRARON PUERTOS ABIERTOS ${NC}                │"
    echo -e "└──────────────────────────────────────────────────────────────┘\n"
    exit 1
fi

echo -e "${GREEN}[+] Puertos abiertos detectados: ${YELLOW}$OPEN_PORTS${NC}"

# Escaneo detallado
OUTPUT_FILE="fullscan_${IP}.txt"
echo -e "\n${BLUE}[*] Fase 2: Escaneo detallado de servicios y versiones...${NC}"
echo -e "${YELLOW}Este proceso puede tomar varios minutos..."
echo -e "Los resultados se guardarán en: ${ORANGE}$OUTPUT_FILE${NC}"

# Ejecutar nmap en segundo plano sin mostrar output
nmap -sCV -p "$OPEN_PORTS" "$IP" > "$OUTPUT_FILE" 2>&1 &
NMAP_PID=$!

# Spinner con contador de tiempo
spinner=("/" "-" "\\" "|")
i=0
SECONDS=0
PREV_LINE=""

while kill -0 $NMAP_PID 2>/dev/null; do
    i=$(( (i+1) % 4 ))
    CURRENT_LINE="\r${YELLOW}[+] Escaneando... ${spinner[$i]} Tiempo transcurrido: ${SECONDS}s${NC}"
    if [[ "$CURRENT_LINE" != "$PREV_LINE" ]]; then
        echo -ne "$CURRENT_LINE"
        PREV_LINE="$CURRENT_LINE"
    fi
    sleep 0.1
done

# Limpiar la línea del spinner
echo -ne "\r\033[K"

# Resultados finales
echo -e "\n${GREEN}[+] Escaneo completado exitosamente!${NC}"
echo -e "${BLUE}[*] Resumen de hallazgos:${NC}"
echo -e "${YELLOW}──────────────────────────────────────────────────────────────${NC}"
grep -E '^[0-9]' "$OUTPUT_FILE" | head -n 20
echo -e "${YELLOW}──────────────────────────────────────────────────────────────${NC}"
echo -e "${GREEN}[*] Resultados completos guardados en: ${ORANGE}$OUTPUT_FILE${NC}\n"

# Sugerencia para el siguiente paso
echo -e "${BLUE} [+] Puedes copiar esta línea para ver el reporte: cat $OUTPUT_FILE | less -R${NC}\n"