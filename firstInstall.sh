#!/bin/bash

apt-get update && apt-get upgrade -y 

apt-get install -y build-essential linux-headers-`uname -r` openssh-server apache2 mysql-server\
  mysql-client bison flex php5 php5-curl php5-cli php5-mysql php-pear php5-gd curl sox\
  libncurses5-dev libssl-dev libmysqlclient-dev mpg123 libxml2-dev libnewt-dev sqlite3\
  libsqlite3-dev pkg-config automake libtool autoconf git unixodbc-dev uuid uuid-dev\
  libasound2-dev libogg-dev libvorbis-dev libcurl4-openssl-dev libical-dev libneon27-dev libsrtp0-dev\
  libspandsp-dev libmyodbc
  
chmod -R 777 *

reboot