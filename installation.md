# Linux/UNIX *Command Line Interface*

### Mengubah ke *Root User*

##### Perlu diingat bahwa bagian ini sangat penting. Anda harus menjalankan seluruh proses sebagai *root* . Jika anda mencoba 'sudo' di tengah proses maka proses tersebut tidak akan berjalan. Anda harus melakukan perintah ini untuk mengubah ke *interactive root shell*.
```bash
sudo -i
```

### Perintah Untuk Meng-*Update* Sistem Anda
```bash
apt-get update && apt-get upgrade -y 
```

### Dependensi yang Diperlukan Untuk *Install*
```bash
apt-get install -y build-essential linux-headers-`uname -r` openssh-server apache2 mysql-server\
  mysql-client bison flex php5 php5-curl php5-cli php5-mysql php-pear php5-gd curl sox\
  libncurses5-dev libssl-dev libmysqlclient-dev mpg123 libxml2-dev libnewt-dev sqlite3\
  libsqlite3-dev pkg-config automake libtool autoconf git unixodbc-dev uuid uuid-dev\
  libasound2-dev libogg-dev libvorbis-dev libcurl4-openssl-dev libical-dev libneon27-dev libsrtp0-dev\
  libspandsp-dev libmyodbc
```

### *Reboot* server
```bash
reboot
```

### Setelah Melakukan *Reboot*
Pastikan bahwa anda kembali menjalankan 'sudo -i', atau masuk sebagai user *root*. Seperti yang dapat kita lihat di atas, seluruh proses instalasi harus dijalankan sebagai 'root', jika tidak, maka akan menyebabkan masalah yang tak terduga.

### Instal Persyaratan *Pear Legacy*
```bash
pear install Console_Getopt
```

### Melakukan instalasi Dependencies for Google Voice (jika diperlukan)
Anda bisa melewati bagian ini jika Anda tidak memerlukan dukungan Google Voice.

#### Instal iksemel
```bash
cd /usr/src
wget https://iksemel.googlecode.com/files/iksemel-1.4.tar.gz
tar xf iksemel-1.4.tar.gz
cd iksemel-*
./configure
make
make install
```

### Instal dan Konfigurasi Asterisk

#### *Download* sumber data Asterisk
```bash
cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-1.4-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13-current.tar.gz
wget -O jansson.tar.gz https://github.com/akheron/jansson/archive/v2.7.tar.gz
wget http://www.pjsip.org/release/2.4/pjproject-2.4.tar.bz2
```

#### *Compile* dan Instal DAHDI
##### Jika Anda tidak memiliki perangkat keras PSTN yang sudah ada pada mesin ini, Anda tidak perlu menginstal DAHDI (Misalnya, kartu T1 atau E1, atau perangkat USB). Kebanyakan setup yang lebih kecil tidak akan memiliki hardware DAHDI, dan langkah ini dapat dengan aman dilewati.
```bash
cd /usr/src
tar xvfz dahdi-linux-complete-current.tar.gz
rm -f dahdi-linux-complete-current.tar.gz
cd dahdi-linux-complete-*
make all
make install
make config
cd /usr/src
tar xvfz libpri-1.4-current.tar.gz
rm -f libpri-1.4-current.tar.gz
cd libpri-*
make
make install
```

#### *Compile* dan instal pjproject
```bash
cd /usr/src
tar -xjvf pjproject-2.4.tar.bz2
rm -f pjproject-2.4.tar.bz2
cd pjproject-2.4
CFLAGS='-DPJ_HAS_IPV6=1' ./configure --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr
make dep
make
make install
```

<!-- TODO: add user mgmt: adduser, deluser, addgroup, etc. -->

#### *Compile* dan Instal jansson
Keluar dari sistem.
```bash
cd /usr/src
tar vxfz jansson.tar.gz
rm -f jansson.tar.gz
cd jansson-*
autoreconf -i
./configure
make
make install
```

#### *Compile* dan Instal Asterisk 
```bash
cd /usr/src
tar xvfz asterisk-13-current.tar.gz
rm -f asterisk-13-current.tar.gz
cd asterisk-*
contrib/scripts/install_prereq install
./configure
contrib/scripts/get_mp3_source.sh
make menuselect
```
Anda akan diminta untuk memilih yang modul mana yang akan dibangun. Sebagian besar dari modul tersebut sudah akan diaktifkan, tetapi jika Anda ingin memiliki dukungan MP3 (misalnya, untuk *Music on Hold*), anda perlu mengaktifkan 'format_mp3' pada halaman pertama secara manual.

Setelah anda memilih *'Save & Exit'* , anda dapat melanjutkannya dengan melakukan perintah di bawah ini
```bash
make
make install
make config
ldconfig
update-rc.d -f asterisk remove
```

#### Instal Asterisk *Soundfiles*.
Cara di atas menginstal *soundfile* kualitas rendah standar secara *default*. Cara ini akan cocok jika anda menggunakan sistem bertenaga rendah (contoh: Raspberry Pi). Tetapi pada sistem yang bertenaga lebih besar, anda harus menginstal *filesound* berkualitas tinggi. Anda harus perhatikan bahwa cara ini akan menginstal (8KHz) 'wav' *soundfile* dan audio G722 (*High Definition 'Wideband'*).
```bash
cd /var/lib/asterisk/sounds
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-core-sounds-en-wav-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-wav-current.tar.gz
tar xvf asterisk-core-sounds-en-wav-current.tar.gz
rm -f asterisk-core-sounds-en-wav-current.tar.gz
tar xfz asterisk-extra-sounds-en-wav-current.tar.gz
rm -f asterisk-extra-sounds-en-wav-current.tar.gz
# Wideband Audio download
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-core-sounds-en-g722-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-g722-current.tar.gz
tar xfz asterisk-extra-sounds-en-g722-current.tar.gz
rm -f asterisk-extra-sounds-en-g722-current.tar.gz
tar xfz asterisk-core-sounds-en-g722-current.tar.gz
rm -f asterisk-core-sounds-en-g722-current.tar.gz
```