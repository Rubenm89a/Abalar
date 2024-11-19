# == Class: m11_xfce4
#
# Instalación, parametrización del entorno de ventanas XFCE4.8 así como las configuraciones específicas para su congelación
#
# Copyright (C) 2014, Xunta de Galicia for Consolidación Software Abalar
# Project <software.libre@edu.xunta.es>
# Author: Roi García Megías <roi.garcia.megias@everis.com>
# Modified: Alfonso Bilbao Vélez <alfonso.ernesto.bilbao.velez.ocampo@everis.com>
# Task: #464973
# developed by EVERIS S.L.
#
class m11_xfce4 {

	include m11_xfce4::params
	include m11_xfce4::install
	include m11_xfce4::config
	include m11_xfce4::monitor_hotplug

}
