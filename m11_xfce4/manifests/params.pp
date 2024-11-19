# == Class: m11_xfce4::params
#
# Instalación, parametrización del entorno de ventanas XFCE4.8 así como las configuraciones específicas para su congelación
#
# Copyright (C) 2014, Xunta de Galicia for Consolidación Software Abalar
# Project <software.libre@edu.xunta.es>
# Author: Roi García Megías <roi.garcia.megias@everis.com>
# Modified by: Gonzalo Vázquez Enjamio <gonzalo.vazquez.enjamio.sa@everis.com>
# Modified: Alfonso Bilbao Vélez <alfonso.ernesto.bilbao.velez.ocampo@everis.com>
# Task: #464973
# developed by EVERIS S.L.
# Modified: Rubén Rojo Vázquez  <ruben.rojovazquez.sa@everis.nttdata.com> 
# Fondos de pantalla 2023. Eliminacion del condicional para edixgal/no_edixgal, fondos 1080 y verticales para equipos con autorotado.
# Task: #582345 #791420

class m11_xfce4::params {
case $::osfamily {
    debian: {

## VARIABLES GENERALES
	$owner			= 'usuario'
	$group			= 'usuario'
	$owner_root		= 'root'
	$group_root		= 'root'
	
	# Modes.
	$normal_mode		= '0755'
	$mode_protected		= '0644'
	$mode_secured		= '0600'
	$mode_launchers		= '0700'
	$mode			= '0644'

	# Ensures.
	$ensure_present		= 'present'
	$ensure_del		= 'absent'
	$ensure_directory	= 'directory'

	# Commands.
	$command		= '/usr/bin/pkill -HUP xfdesktop'

	# Packages.
	$package_name		= [ 'xfce4', 'xfce4-goodies' ]
	$ensure_install		= 'present'
## FIN VARIABLES GENERALES

## FONDOS DE PANTALLA

	$path_fondo		= '/usr/share/images/desktop-base/default'
	$path_fondo_ext		= '/usr/share/images/desktop-base/default-ext'
	$path_fondo_ver         = '/usr/share/images/desktop-base/default-ver'	
	$path_fondo_extHD	= '/usr/share/images/desktop-base/default-extHD'
	
	# Sustituçom do condicional para m11 (sin telefono de soporte premium y UAC en fondo de pantalla)
	# por fondo para resoluçom de pantalhas diferentes
	if $::productname =~ /ProBook\ 650\ G5/ or $::productname =~ /ProBook\ 650\ G8/ or $::productname =~ /650.*G9/ {
		$source_fondo	= 'puppet:///modules/m11_xfce4/background/20230329_fondo_abalar_11_1920x1080.png'
	} else {	
		$source_fondo	= 'puppet:///modules/m11_xfce4/background/20230329_fondo_abalar_11.png'
	}
	$source_fondo_ext	= 'puppet:///modules/m11_xfce4/background/20230329_fondo_abalar_11_ext.png'

	$source_fondo_ver	= 'puppet:///modules/m11_xfce4/background/20230417_fondo_abalar_11_ver.png'

	$source_fondo_extHD	= 'puppet:///modules/m11_xfce4/background/20230329_fondo_abalar_11_1280x720.png'

	
	
## FIN FONDOS DE PANTALLA #

## ICONOS
	$source_icono		= "puppet:///modules/m11_xfce4/icono/abalar.png"
	$path_icono		= '/usr/share/icons/hicolor/64x64/devices/abalar.png'
## FIN ICONOS

## XFWM4
	$path_composite		= '/home/usuario/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml'	
	$source_composite	= 'puppet:///modules/m11_xfce4/xfwm4.xml'
## FIN XFWM4


## DESKTOP PANEL
	$path_desktop		= '/home/usuario/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml'
	$source_desktop		= 'puppet:///modules/m11_xfce4/xfce4-desktop.xml'
# Task 423258 -- Modified by Gonzalo Vázquez
	$path_desktop_original    = '/home/usuario/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml.ORIGINAL'
# End task 423258

## FIN DESKTOP PANEL


## PANELES.
	$path_panel		= '/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml'
	$path_panel_usuario	= '/home/usuario/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml'
	# Panel Torres.
	if $::dmi['chassis']['type'] != 'Notebook' and $::dmi['chassis']['type'] != 'Laptop' and $::dmi['chassis']['type'] != 'Convertible' and $::productname != 'Intel powered classmate PC' and $::productname !~ /x360/ and $::product_model !~ /ThinkPad/ and $::productname !~ /20LMS00900/ and $::productname !~ /20LNS0QU00/ and $::serialnumber != '8DK1N2J' and $::productname !~ /ProBook\ 650\ G8/ and $::productname !~ /B311/{
	$source_panel           = 'puppet:///modules/m11_xfce4/xfce4-panel_tower.xml'
	}	

	# Panel profesores.
	elsif $::productname != 'Intel powered classmate PC' and $::serialnumber != '8DK1N2J' and $::productname !~ /x360/ and $::product_model !~ /ThinkPad/ and $::productname !~ /20LMS00900/ and $::productname !~ /20LNS0QU00/ and $::productname !~ /B311/{

		$source_panel		= 'puppet:///modules/m11_xfce4/xfce4-panel_teacher.xml'
	# Panel alumnos.
	} else {

		$source_panel		= 'puppet:///modules/m11_xfce4/xfce4-panel_student.xml'
	}
	$path_launchers			= '/home/usuario/.config/xfce4/panel/'
	$source_launchers		= 'puppet:///modules/m11_xfce4/panel/launchers/'
  #Desktop do google chrome no panel
  $chrome_panel_desktop = '/home/usuario/.config/xfce4/panel/launcher-4/panel_chrome.desktop'
  if $::locale == 'gl' {
	  $desktop_env  = "env LANGUAGE=es" 
  } else {
    $desktop_env  = "env" 
  }
## END PANELES

## THUNAR Automount.
	$path_auto		= '/home/usuario/.config/xfce4/xfconf/xfce-perchannel-xml/thunar-volman.xml'
	$content_auto		= 'm11_xfce4/thunar-volman.erb'
	$automount		= 'true'
	$autobrowser		= 'true'
## FIN THUNAR Automount

## SYNAPTICS.
	$path_tap		= '/usr/share/X11/xorg.conf.d/50-synaptics.conf'
	$source_tap		= 'puppet:///modules/m11_xfce4/50-synaptics.conf'

# AUTOCONFIGURACION DE LA PANTALLA: monitor-hotplug
	$path_monitor_rules		= '/etc/udev/rules.d/95-monitor-hotplug.rules'
	$source_monitor_rules		= 'puppet:///modules/m11_xfce4/monitor_hotplug/95-monitor-hotplug.rules'
	$path_monitor_script		= '/usr/local/bin/monitor-hotplug.sh'
	$source_monitor_script		= 'puppet:///modules/m11_xfce4/monitor_hotplug/monitor-hotplug.sh'
	$mode_monitor_script		= '0755'
        $path_monitor_autostart         = '/etc/xdg/autostart/monitor-hotplug.desktop'
	# $path_monitor_autostart		= '/home/usuario/.config/autostart/monitor-hotplug.desktop'
	$source_monitor_autostart	= 'puppet:///modules/m11_xfce4/monitor_hotplug/monitor-hotplug.desktop'

## Cambio de resoluçom permanente, só para equipos de profesorado
if $::productname != 'Intel powered classmate PC' and $::serialnumber != '8DK1N2J' and $::productname !~ /x360/ and $::product_model !~ /ThinkPad/ and $::productname !~ /20LMS00900/ and $::productname !~ /20LNS0QU00/ and $::productname !~ /B311/ {
		$path_incron_resolution		= '/etc/incron.d/resolution/'
		$source_incron_resolution	= 'puppet:///modules/m11_xfce4/incron/resolution'
		$path_monitor_polkit		= '/usr/share/polkit-1/actions/org.freedesktop.resolucion-permanente.policy'
		$source_monitor_polkit		= 'puppet:///modules/m11_xfce4/polkit/org.freedesktop.resolucion-permanente.policy'
		$path_script_res_permanente	= '/usr/local/bin/resolucion-permanente.sh'
		$source_script_res_permanente	= 'puppet:///modules/m11_xfce4/monitor_hotplug/resolucion-permanente.sh'
	}
##

## FIN SYNAPTICS


## SESSION
	# Autoconfiguracion xfce4-session.
	$path_config_session		= '/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml'
	$source_config_session		= 'puppet:///modules/m11_xfce4/xfce4-session.xml'

## KEYBOARD_LAYOUT
		if $::locale == 'ru' {
        $idiomas_ibus	= "['xkb:ua:rstu_ru:ukr', 'xkb:es::spa', 'xkb:gr::ell', 'xkb:pt::por', 'xkb:us::eng']"
      } elsif $::locale == 'uk' {
        $idiomas_ibus	= "['xkb:ua::ukr', 'xkb:es::spa', 'xkb:gr::ell', 'xkb:pt::por', 'xkb:us::eng']"
      } else {
        $idiomas_ibus	= "['xkb:es::spa', 'xkb:gr::ell', 'xkb:pt::por', 'xkb:us::eng']"
    }

    # Desktop para executar o restauro no inicio
    $path_dconf_desktop    = '/home/usuario/.config/autostart/dconf_ibus.desktop'
    $source_dconf_desktop    = 'puppet:///modules/m11_xfce4/dconf_ibus.desktop'

    # Ficheiro de respaldo de ibus
    $path_dconf_dump    = '/home/usuario/.config/dconf/dump.dconf'
    $content_dconf_dump    = 'm11_xfce4/dump.erb'

## FIN KEYBOARD LAYOUT

# Pitido Yoga
	$path_pitido	=	'/etc/xdg/autostart/pitido_yoga.desktop'
	$source_pitido	=	'puppet:///modules/m11_xfce4/pitido_yoga.desktop'

    }
  }
}
