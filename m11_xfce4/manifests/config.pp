# == Class: m11_xfce4
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

class m11_xfce4::config {

# Creanse varios directorios necesarios:
file	{ 
	[ '/home/usuario/.config/xfce4/', '/home/usuario/.config/xfce4/xfconf/', '/home/usuario/.config/xfce4/xfconf/xfce-perchannel-xml', '/home/usuario/.config/dconf/' ]:
	ensure => directory,
	mode   => '0755',
	owner  => 'usuario',
	group  => 'usuario';
	}

# FONDOS
# Fondo Escritorio.
file { 'fondo':
	path		=> $m11_xfce4::params::path_fondo,
	source		=> $m11_xfce4::params::source_fondo,
	owner		=> $m11_xfce4::params::owner,
	group		=> $m11_xfce4::params::group,
	mode 		=> $m11_xfce4::params::mode_protected,
	require		=> Package[$m11_xfce4::params::package_name];
 }
# Fondo external.
file { 'fondo_ext':
	path		=> $m11_xfce4::params::path_fondo_ext,
	source		=> $m11_xfce4::params::source_fondo_ext,
	owner		=> $m11_xfce4::params::owner,
	group		=> $m11_xfce4::params::group,
	mode 		=> $m11_xfce4::params::mode_protected,
	require		=> Package[$m11_xfce4::params::package_name];
 }

# Fondo vetical.
if $::productname =~ /x360/ or $::product_model =~ /ThinkPad/ or $::productname =~ /20LMS00900/ or $::productname =~ /20LNS0QU00/  or $::productname =~ /B311/ {
file { 'fondo_ver':
        path            => $m11_xfce4::params::path_fondo_ver,
        source          => $m11_xfce4::params::source_fondo_ver,
        owner           => $m11_xfce4::params::owner,
        group           => $m11_xfce4::params::group,
        mode            => $m11_xfce4::params::mode_protected,
        require         => Package[$m11_xfce4::params::package_name];
 }
}
# Fondo externalHD.
if $::productname != 'Intel powered classmate PC' and $::serialnumber != '8DK1N2J' and $::productname !~ /x360/ and $::product_model !~ /ThinkPad/ and $::productname !~ /20LMS00900/ and $::productname !~ /20LNS0QU00/ and $::productname !~ /B311/ and $::productname !~ /ProBook\ 650\ G5/ and $::productname !~ /ProBook\ 650\ G8/ and $::productname !~ /650.*G9/ {
file { 'fondo_extHD':
        path            => $m11_xfce4::params::path_fondo_extHD,
        source          => $m11_xfce4::params::source_fondo_extHD,
        owner           => $m11_xfce4::params::owner,
        group           => $m11_xfce4::params::group,
        mode            => $m11_xfce4::params::mode_protected,
        require         => Package[$m11_xfce4::params::package_name];
 }
}


## ICONOS
file { 'logo':
        path            => $m11_xfce4::params::path_icono,
        source          => $m11_xfce4::params::source_icono,
        owner           => $m11_xfce4::params::owner,
        group           => $m11_xfce4::params::group,
        mode            => $m11_xfce4::params::mode_protected,
        require         => Package[$m11_xfce4::params::package_name];
 }
## FIN ICONOS

# Xfwm4
file { 'composite':
        path            => $m11_xfce4::params::path_composite,
        source          => $m11_xfce4::params::source_composite,
        owner           => $m11_xfce4::params::owner,
        group           => $m11_xfce4::params::group,
        mode            => $m11_xfce4::params::mode_protected,
	ensure		=> $m11_xfce4::params::ensure_directory,
        require         => Package[$m11_xfce4::params::package_name];
 }
# Fin Xfwm4

## DESKTOP PANEL
file { 'desktop':
        path            => $m11_xfce4::params::path_desktop,
        source          => $m11_xfce4::params::source_desktop,
        owner           => $m11_xfce4::params::owner,
        group           => $m11_xfce4::params::group,
        mode            => $m11_xfce4::params::mode_protected,
        ## Task 423455
        replace        => 'false',
        ## End task 423455
        require         => Package[$m11_xfce4::params::package_name];

# Task 423258 -- Modified by Gonzalo Vázquez
	'desktop_original':
        path            => $m11_xfce4::params::path_desktop_original,
        source          => $m11_xfce4::params::source_desktop,
        owner           => $m11_xfce4::params::owner,
        group           => $m11_xfce4::params::group,
        mode            => $m11_xfce4::params::mode_protected,
        require         => Package[$m11_xfce4::params::package_name];
 }
# End task 423258

## FIN DESKTOP PANEL

## PANELES
file { 'panel':
        path            => $m11_xfce4::params::path_panel,
        source          => $m11_xfce4::params::source_panel,
        require         => Package[$m11_xfce4::params::package_name];
 }

 file { 'panel_usuario':
        path            => $m11_xfce4::params::path_panel_usuario,
        source          => $m11_xfce4::params::source_panel,
        require         => Package[$m11_xfce4::params::package_name];
 }

# Launchers.
file {'xfce_launchers':
	ensure		=> $m11_xfce4::params::ensure_directory,
	recurse		=> 'true',
	path		=> $m11_xfce4::params::path_launchers,
	source		=> $m11_xfce4::params::source_launchers,
	owner		=> $m11_xfce4::params::owner,
	group		=> $m11_xfce4::params::group,
	mode		=> $m11_xfce4::params::mode_launchers,
	require		=> Package[$m11_xfce4::params::package_name];
	'chrome-launcher':
  ensure    => $m11_xfce4::params::ensure_present,
  content    => template('m11_xfce4/panel_chrome.erb'),
  path    => $m11_xfce4::params::chrome_panel_desktop,
  owner        => $m11_xfce4::params::owner,
  group        => $m11_xfce4::params::group,
  mode        => $m11_xfce4::params::mode_launchers,
  require    => File['xfce_launchers'];
 }

## FIN PANELES

# THUNAR Automount
file { 'usbmount':
	path		=> $m11_xfce4::params::path_auto,
	content		=> template ($m11_xfce4::params::content_auto),
	owner		=> $m11_xfce4::params::owner,
	group		=> $m11_xfce4::params::group,
	mode		=> $m11_xfce4::params::mode_protected,
	ensure		=> $m11_xfce4::params::ensure_present,
        require         => Package[$m11_xfce4::params::package_name];
 }
## FIN THUNAR Automount

## SYNAPTICS

file { 'taptouch':
	path		=> $m11_xfce4::params::path_tap,
	source		=> $m11_xfce4::params::source_tap,
	ensure		=> $m11_xfce4::params::ensure_present,
        require         => Package[$m11_xfce4::params::package_name];
 }

## FIN SYNAPTICS

## SESSION
file {'xfce_session':
	ensure		=> $m11_xfce4::params::ensure_present,
	path		=> $m11_xfce4::params::path_config_session,
	source		=> $m11_xfce4::params::source_config_session,
	mode 		=> $m11_xfce4::params::mode_protected;
  }

## KEYBOARD LAYOUT

file {

    'dconf_desktop':
    ensure          => $m11_xfce4::params::ensure_present,
    path            => $m11_xfce4::params::path_dconf_desktop,
    source          => $m11_xfce4::params::source_dconf_desktop,
    owner           => $m11_xfce4::params::owner,
    group           => $m11_xfce4::params::group,
    mode            => $m11_xfce4::params::mode_protected;

    'dump.dconf':
    ensure        => $m11_xfce4::params::ensure_present,
    path        => $m11_xfce4::params::path_dconf_dump,
    content        => template($m11_xfce4::params::content_dconf_dump),
    owner        => $m11_xfce4::params::owner_root,
    group        => $m11_xfce4::params::group_root,
    mode        => $m11_xfce4::params::mode;
  }

## FIN KEYBOARD LAYOUT

## Cambio de resoluçom permanente, só para equipos de profesorado
if $::productname != 'Intel powered classmate PC' and $::serialnumber != '8DK1N2J' and $::productname !~ /x360/ and $::product_model !~ /ThinkPad/ and $::productname !~ /20LMS00900/ and $::productname !~ /20LNS0QU00/ and $::productname !~ /B311/ {
	file {
		'incron_resolution':
		ensure	=> $m11_xfce4::params::ensure_present,
		path	=> $m11_xfce4::params::path_incron_resolution,
		source	=> $m11_xfce4::params::source_incron_resolution,
		owner	=> $m11_xfce4::params::owner_root,
		group	=> $m11_xfce4::params::group_root,
		mode	=> $m11_xfce4::params::mode;
		'monitor_polkit':
		ensure  => $m11_xfce4::params::ensure_present,
		path    => $m11_xfce4::params::path_monitor_polkit,
		source  => $m11_xfce4::params::source_monitor_polkit,
		owner   => $m11_xfce4::params::owner_root,
		group   => $m11_xfce4::params::group_root,
		mode    => $m11_xfce4::params::mode;
		'script_res_permanente':
		ensure  => $m11_xfce4::params::ensure_present,
		path    => $m11_xfce4::params::path_script_res_permanente,
		source  => $m11_xfce4::params::source_script_res_permanente,
		owner   => $m11_xfce4::params::owner_root,
		group   => $m11_xfce4::params::group_root,
		mode    => $m11_xfce4::params::normal_mode;
		'screenlayout':
		ensure	=> 'directory',
		path	=> '/home/usuario/.screenlayout',
		owner	=> $m11_xfce4::params::owner,
		group	=> $m11_xfce4::params::group,
		mode	=> $m11_xfce4::params::normal_mode;
	}
}

# Task #798466 Eliminar pitido que emiten los Yoga al hacer clic en rematar sesión

if $::product_model =~ /ThinkPad Yoga 11e 5th Gen/ {

	file { 'pitido_yoga':
		ensure	=> $m11_xfce4::params::ensure_present,
		path	=> $m11_xfce4::params::path_pitido,
		source	=> $m11_xfce4::params::source_pitido,
		owner	=> $m11_xfce4::params::owner_root,
		group	=> $m11_xfce4::params::group_root,
		mode	=> $m11_xfce4::params::mode;
	}
 }

}
