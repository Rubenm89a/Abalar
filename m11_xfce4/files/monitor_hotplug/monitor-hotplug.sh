#!/bin/bash
#############################################################################

# Copyright (C) 2015, Xunta de Galicia for Consolidación Software Abalar
# Project <software.libre@edu.xunta.es>
# Author: Jose Manuel Failde García <jose.manuel.failde.garcia@everis.com>
# Modificate by: Roi García Megías <roi.garcia.megias@everis.com>
# Modificate by: Alfonso Bilbao Velez <alfonso.bilbao.velez.sa@everis.com>
# Task: 13737
# Task: 14464
# New Task: 14630
# New Task: 578897
# New Task: 805658
# Developed by EVERIS S.L.

#############################################################################
# VARIABLES #
# Resolucion de pantalla[1024x768,1366x768,...].
RESOLUTION="$(xrandr |grep -iw -A1 connected | tail -n1 | awk '{print $1}')" 

# Monitor principal, siempre [eDP1,LVDS-1] El nombre depende del equipo.
MONITOR="$(xrandr | grep " connected" | cut -d' ' -f1 | head -n1)"

# Dispositivo que esta en uso, [eDP-1,DP-1,HDMI-1].
RUN_DEV="$(xrandr | grep " connected" | cut -d' ' -f1 | tail -n1)" 

# Monitor externo.
#EXTERNAL="$(xrandr | grep " connected" | cut -d' ' -f1 | tail -n1 | sed "s/[aeiou]//g")"
EXTERNAL="$(xrandr | grep " connected" | cut -d ' ' -f1 | tail -n1 | sed "s/*/$(xrandr | grep " connected" | cut -d' ' -f1 | tail -1 | tr -d '[:alpha:]')/")"

# Vga Device.
VGA_DEV="$(xrandr | grep -e "^DP" | cut -d ' ' -f1 | head -n1)"

# Hdmi device.
HDMI_DEV="$(xrandr  | grep "HDMI" | cut -d ' ' -f1 | head -n1)"

# Salida Hdmi.
HDMI_RES="$(xrandr  | grep "HDMI" | cut -d' ' -f3 |  tr "+" "\n" | head -n1)"

# Default Values.
PRODUCTNAME="$(cat /sys/class/dmi/id/product_name)"
if [[ -f /home/usuario/.screenlayout/resolucion.sh ]]; then
    DEFAULT_RES="$(cat /home/usuario/.screenlayout/resolucion.sh | grep -Po 'primary\s--mode\s\K\d+x\d+')" 
else
    DEFAULT_RES="$(xrandr | head -n 3 | tail -n 1 | awk '{print $1}')" 
fi

DEFAULT_EXT="1024x768"
DEFAULT_HD="1280x720"
DEFAULT_FHD="1920x1080"

#Presencia de 4K para condicionales de cambio de resolución en PDI o Paneles 
MONITOR4K="$(xrandr | grep -m1 -o 3840x2160)"

# Datos log.
DATE="$(date +%d/%m/%Y_%H:%M:%S)"
LOGFILE="/var/log/monitor-hotplug.log"
SEPARADOR="#============================#"

# FUNCIONES
export_display(){
	export XAUTORITY="/home/usuario/.Xauthority"
	export DISPLAY=":0.0"
}

# PROBAS "Remove displays.xml"
check_displayxml(){
	if [ -f /home/usuario/.config/xfce4/xfconf/xfce-perchannel-xml/displays.xml ]; then
		rm -f /home/usuario/.config/xfce4/xfconf/xfce-perchannel-xml/displays.xml
	else
		echo "No displays.xml found"
	fi
}
get_devices(){
	EXTERN=$(xrandr | grep " connected" | cut -d' ' -f1)
	CONN_DEVICES=($EXTERN)
	ARRAY_LENGHT=${#CONN_DEVICES[@]}

	if [ ${ARRAY_LENGHT} == 1 ];then
		EXT_DEV=${CONN_DEVICES[0]}
        	LEN_DEV=${ARRAY_LENGHT}"_dev"
        	echo "EXT_DEV="$EXT_DEV
        	echo "LEN="$LEN_DEV

	elif [ ${ARRAY_LENGHT} == 2 ];then
		EXT_DEV=${CONN_DEVICES[1]}
        	LEN_DEV=${ARRAY_LENGHT}"_dev"
        	echo "EXT_DEV="$EXT_DEV
        	echo "LEN="$LEN_DEV

	elif [ ${ARRAY_LENGHT} == 3 ];then
		EXT_DEV=${CONN_DEVICES[2]}
	        LEN_DEV=${ARRAY_LENGHT}"_dev"
	        echo "EXT_DEV="$EXT_DEV
	        echo "LEN="$LEN_DEV

	else
		echo "Error de ejecucion get_devices..."
	fi
}

get_resolutions(){
	#RESOLUTIONS="$(xrandr |grep -w connected | awk -F'[ +]' '{print $1,$3,$4}')"
	RESOLUTIONS="$(xrandr |grep -iw -A1 connected | awk '{print $1}' | sed 's/--//')"
	RES_DEVICES=($RESOLUTIONS)
	RES_LENGHT=${#RES_DEVICES[@]}
	D=${RES_LENGHT}-1
	RSL=${RES_DEVICES[$D]}
	echo "RES="${RSL}
}

get_status(){
	if [ -d "/sys/class/drm/card0-${EXT_DEV}" ];then
		STATUS="/sys/class/drm/card0-${EXT_DEV}/status"
		CARD_STAT=$(cat $STATUS)
		echo "STATUS="$EXT_DEV $CARD_STAT

	elif [ -d "/sys/class/drm/card1-${EXT_DEV}" ];then
		STATUS="/sys/class/drm/card1-${EXT_DEV}/status"
		CARD_STAT=$(cat $STATUS)
		echo "STATUS="$EXT_DEV $CARD_STAT
	fi
}

compare_devices(){
	if [ $MONITOR == $RUN_DEV ];then	
		COMP="Solo monitor equipo."
        	echo $COMP
        	echo "Monitor="$EXT_DEV

	elif [ $MONITOR != $RUN_DEV ];then
		COMP="Pantalla externa conectada."
		if [ $EXT_DEV == "DP-2" ] || [ $EXT_DEV == "DP-1" ] || [ $EXT_DEV == "VGA-1" ] || [ $EXT_DEV == "VGA1" ];then
            		echo $COMP
			echo "VGA="$EXT_DEV

        	elif [ $EXT_DEV == "HDMI-1" ];then
            		echo $COMP
			echo "HDMI="$EXT_DEV

        	else
            		echo "Mas de 2 dispositivos externos."
		fi
	else
		echo "Error compare_devices."
	fi
}

configure_screen(){
	# Monitor portatil.
 	if [ ${ARRAY_LENGHT} == 1 ];then
		echo "MONITOR PORTATIL"
		xrandr --output $VGA_DEV --off --output $HDMI_DEV --off --output $MONITOR --primary --mode $DEFAULT_RES --pos 0x0 --rotate normal
	su usuario -c "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor$MONITOR/workspace0/last-image -s /usr/share/images/desktop-base/default"

	# 2 devices.
 	elif [ ${ARRAY_LENGHT} == 2 ];then
		# VGA device.
		if [ $EXT_DEV == "DP-2" ] || [ $EXT_DEV == "DP-1" ] || [ $EXT_DEV == "VGA-1" ] || [ $EXT_DEV == "VGA1" ];then
			echo "MONITOR + VGA"
			# xrandr --output $EXT_DEV --mode $DEFAULT_EXT --pos 0x0 --rotate normal --output $HDMI_DEV --off --output $MONITOR --primary --mode $DEFAULT_EXT --pos 0x0 --rotate normal
			xrandr --output $EXT_DEV --mode $DEFAULT_EXT --pos 0x0 --rotate normal --output $MONITOR --primary --mode $DEFAULT_EXT --pos 0x0 --rotate normal
			su usuario -c "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor$MONITOR/workspace0/last-image -s /usr/share/images/desktop-base/default-ext"
		# HDMI device.
		#Conservase este condicional ainda que a liña que se executa é a mesma, por ter separados os tipos de conectores
                        #xrandr --output DP-1 --off --output $EXT_DEV --mode $HDMI_RES --pos 0x0 --rotate normal --output $MONITOR --primary --mode $DEFAULT_RES --pos 0x0 --rotate normal
                        #xrandr --output $EXT_DEV --mode $DEFAULT_EXT --pos 0x0 --rotate normal  --output $MONITOR --primary --mode $DEFAULT_EXT --pos 0x0 --rotate normal

		# New Task: 805658
		elif [ $EXT_DEV == "HDMI-1" ];then
				#Condicional para equipo FHD (1920x1080) y else para el resto (normalmente 136?x768)
				if [ $DEFAULT_RES == "1920x1080" ]; then
					#Condicional para pantalla externa UHD (3840x2160)
					if [ $MONITOR4K == "3840x2160" ]; then
					#DEFAULT_FHD="1920x1080"
					xrandr --output $EXT_DEV --mode $DEFAULT_FHD --pos 0x0 --rotate normal  --output $MONITOR --primary --mode $DEFAULT_FHD --pos 0x0 --rotate normal
					su usuario -c "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor$MONITOR/workspace0/last-image -s /usr/share/images/desktop-base/default"
				else
					xrandr --output $EXT_DEV --mode $DEFAULT_EXT --pos 0x0 --rotate normal  --output $MONITOR --primary --mode $DEFAULT_EXT --pos 0x0 --rotate normal
					su usuario -c "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor$MONITOR/workspace0/last-image -s /usr/share/images/desktop-base/default-ext"
                                fi
			else
				if [ $MONITOR4K == "3840x2160" ]; then
                                        #DEFAULT_HD="1280x720"
                                        xrandr --output $EXT_DEV --mode $DEFAULT_HD --pos 0x0 --rotate normal  --output $MONITOR --primary --mode $DEFAULT_HD --pos 0x0 --rotate normal
					su usuario -c "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor$MONITOR/workspace0/last-image -s /usr/share/images/desktop-base/default-extHD"
                                else
                                        xrandr --output $EXT_DEV --mode $DEFAULT_EXT --pos 0x0 --rotate normal  --output $MONITOR --primary --mode $DEFAULT_EXT --pos 0x0 --rotate normal
					su usuario -c "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor$MONITOR/workspace0/last-image -s /usr/share/images/desktop-base/default-ext"
                                fi
			fi


			echo "MONITOR + HDMI"
			#xrandr --output DP-1 --off --output $EXT_DEV --mode $HDMI_RES --pos 0x0 --rotate normal --output $MONITOR --primary --mode $DEFAULT_RES --pos 0x0 --rotate normal
			#xrandr --output $EXT_DEV --mode $DEFAULT_EXT --pos 0x0 --rotate normal  --output $MONITOR --primary --mode $DEFAULT_EXT --pos 0x0 --rotate normal
		fi
#	su usuario -c "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor$MONITOR/workspace0/last-image -s /usr/share/images/desktop-base/default-ext"

	# 3 devices.
	elif [ ${ARRAY_LENGHT} == 3 ];then
		if [ $EXT_DEV == "DP-2" ] || [ $EXT_DEV == "DP-1" ] || [ $EXT_DEV == "VGA-1" ] || [ $EXT_DEV == "VGA1" ];then
			echo "MONITOR + VGA + HDMI"

			xrandr --output $EXT_DEV --mode $DEFAULT_EXT --pos 0x0 --rotate normal --output $HDMI_DEV --mode $HDMI_RES --pos 1024x0 --rotate normal --output $MONITOR --primary --mode $DEFAULT_EXT --pos 0x0 --rotate normal
		else
			echo "No puede configurar 3 dispositivos a la vez ...!"	
		fi
	else
		echo "Error configure_screen..."
	fi
}

log_report(){
	echo " Fecha:$DATE" >> $LOGFILE
	echo "$SEPARADOR" >> $LOGFILE
	echo " Screen: $COMP" >> $LOGFILE
	echo " Lenght Device: $LEN_DEV" >> $LOGFILE
	echo " Runing device: $RUN_DEV" >>$LOGFILE
	echo " Monitor:$MONITOR" >>$LOGFILE
	echo " Resolution: "$RESOLUTION >>$LOGFILE
	echo " External: $EXTERNAL" >> $LOGFILE
	echo "$SEPARADOR" >> $LOGFILE
}



# Main.
export_display
check_displayxml
get_devices
# Desactivado por que no funciona en todos los casos.
# get_status
get_resolutions
compare_devices
configure_screen
# Activar solamente para debugear.
# log_report

