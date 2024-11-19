#!/bin/bash

#Ruta a .screenlayout
SCREENLAYOUT="/home/usuario/.screenlayout" 

# Cambia nome do arquivo introducido por resolucion.sh
mv $SCREENLAYOUT/"$1"  $SCREENLAYOUT/resolucion.sh

# Se os equipos teñen o arquivo 10-monitor.conf
if [[ -f /usr/share/X11/xorg.conf.d/10-monitor.conf ]]; then	

	# Recolle a resolución escollida
	RES="$(cat $SCREENLAYOUT/resolucion.sh | grep -Po 'primary\s--mode\s\K\d+x\d+')" 

	# Modifica a resolución en 10-monitor.conf
	RES_INICIAL="$(cat /usr/share/X11/xorg.conf.d/10-monitor.conf | grep 'PreferredMode' | awk '{print $3}')" 
	sed -i "s/Option \"PreferredMode\" $RES_INICIAL/Option \"PreferredMode\" \"$RES\"/" /usr/share/X11/xorg.conf.d/10-monitor.conf
fi

## Descomentar só para debug
#echo " " >> /var/log/respermanente.log
#echo "##########################################" >> /var/log/respermanente.log
#echo "Usuario que executa o script: $USER" >> /var/log/respermanente.log
#echo "Hora e data `date`"  >> /var/log/respermanente.log
#echo "Nome do ficheiro passado como parámetro: $1"  >> /var/log/respermanente.log
#echo "Nome do evento que provoca esta notificaçom: $2"  >> /var/log/respermanente.log
#echo "Número do evento que se executou: $3"  >> /var/log/respermanente.log
#echo "Ruta ao diretório contentor: $4" >> /var/log/respermanente.log
#echo "Resoluçom inicial: $RES_INICIAL"  >> /var/log/respermanente.log
#echo "Resoluçom final: $RES" >> /var/log/respermanente.log
#echo "Contido de 10-monitor.conf:" >> /var/log/respermanente.log
#cat /usr/share/X11/xorg.conf.d/10-monitor.conf >> /var/log/respermanente.log
#echo " " >> /var/log/respermanente.log

