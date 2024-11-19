# == Class: m11_xfce4
#
# Instalación, parametrización del entorno de ventanas XFCE4.8 así como las configuraciones específicas para su congelación
#
# Copyright (C) 2014, Xunta de Galicia for Consolidación Software Abalar
# Project <software.libre@edu.xunta.es>
# Author: Roi García Megías <roi.garcia.megias@everis.com>
# developed by EVERIS S.L.
#
class m11_xfce4::monitor_hotplug {

# Change oder.
# if $::serialnumber != '8DK1N2J' and $::dmi['chassis']['type'] == 'Laptop' and $::productname != 'Intel powered classmate PC' or $::dmi['chassis']['type'] == 'Notebook' and $::productname != 'Intel powered classmate PC' and $::productname != 'HP ProBook x360 11 G1 EE' and $::product_model !~ /ThinkPad/ {
if $::dmi['chassis']['type'] == 'Laptop' and $::productname != 'Intel powered classmate PC' and $::serialnumber != '8DK1N2J' or $::dmi['chassis']['type'] == 'Notebook' and $::productname != 'Intel powered classmate PC' and $::productname !~ /x360/ and $::product_model !~ /ThinkPad/ and $::productname !~ /20LMS00900/ and $::productname !~ /20LNS0QU00/ and $::productname !~ /B311/ {

# Linea incluida para evitar la autoconfiguracion en equipos sobremesa, expansion. 
	# if $::type == 'Laptop' or $::type == 'Notebook' {
		file { $m11_xfce4::params::path_monitor_rules:
			source          => $m11_xfce4::params::source_monitor_rules,
			ensure          => $m11_xfce4::params::ensure_present;
		 }

		file { $m11_xfce4::params::path_monitor_script:
			source          => $m11_xfce4::params::source_monitor_script,
			mode            => $m11_xfce4::params::mode_monitor_script,
			ensure          => $m11_xfce4::params::ensure_present;
		 }

		file { $m11_xfce4::params::path_monitor_autostart:
			source          => $m11_xfce4::params::source_monitor_autostart,
			mode            => $m11_xfce4::params::mode,
			ensure          => $m11_xfce4::params::ensure_present;
		 }
#	} 
}else{
	file { $m11_xfce4::params::path_monitor_rules:
		ensure          => $m11_xfce4::params::ensure_del;

		$m11_xfce4::params::path_monitor_script:
		ensure          => $m11_xfce4::params::ensure_del;

		$m11_xfce4::params::path_monitor_autostart:
		ensure          => $m11_xfce4::params::ensure_del;
	 }
   }
}
