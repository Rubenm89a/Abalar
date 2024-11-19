# == Class: m11_xfce4
#
# Instalación, parametrización del entorno de ventanas XFCE4.8 así como las configuraciones específicas para su congelación
#
# Copyright (C) 2014, Xunta de Galicia for Consolidación Software Abalar
# Project <software.libre@edu.xunta.es>
# Author: Roi García Megías <roi.garcia.megias@everis.com>
# developed by EVERIS S.L.
#
class m11_xfce4::install {

package { $m11_xfce4::params::package_name:

	ensure => $m11_xfce4::params::ensure_install;

  }
}
