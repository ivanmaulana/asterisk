# VoIP Server *Asterisk*

## `VoIP Server Using Asterisk Server -- Running On Ubuntu Server`

## Anggota Kelompok
- `Ivan Maulana - G64130076`
- `Andy Eka Saputra`
- `Fahmi Solahudin - G64130095`
- `Wildan Muhammad`

## Sekilas tentang Asterisk

Asterisk adalah implementasi dari sistem telepon Private Branch Exchange (PBX);
Dengan aplikasi ini, *user* dapat membuat sendiri sistem / server telepon yang dapat saling terhubung
via Internet Protocol (IP).
Asterisk juga mampu untuk dikembangkan lebih lanjut menjadi server telepon yang sangat canggih,
tentunya dengan berbagai tambahan hardware.

## Apa saja yang ada di project ini ?
- `Instalasi` Dapat dilihat di *installation.md*
- `Konfigurasi` Dapat dilihat di *config.md*
- `Maintenance` Dapat dilihat di *maintenance.md*
- `Otomatisasi` Dapat dilihat di *auto.md*
- `Cara Penggunaan` Dapat dilihat di *how-to.md*

## Cara Pemakaian

### `Instalasi`

jalankan semua perintah ini dalam keadaan superuser
```bash
sudo -i
```

Kemudian masuk ke folder `/usr/src/`
```bash
cd /usr/src/
```

download file git ini, dengan cara 
```bash
git clone http://code.cs.ipb.ac.id/ivanmaulana/asterisk.git
```

masuk ke folder asterisk
```bash
cd asterisk
```

jalankan shell instalasi pertama `firstInstall.sh`
```bash
./firstInstall.sh
```

Kemudian PC akan me-restart otomatis, dan jalankan shell instalasi kedua `secondInstall.sh` di folder `/usr/src/asterisk`
```bash
./secondInstall.sh
```

Setelah Instalasi selesai dilakukan, *user* hanya perlu menggunakan akun yang telah dibuat di *softphone* masing-masing
dan menghubungkannya ke server VoIP.
Kemudian, masing-masing *user* dapat saling menghubungi satu sama lain.


## Pembahasan

### `Pros`
- *User* tidak perlu membeli hardware PBX yang sangat mahal + berbagai tambahan alat lain seperti kabel RJ11 dan hardware telepon.
- Koneksi VoIP tidak membutuhkan koneksi internet, karena menggunakan jaringan local / LAN.
- Sangat menghemat biaya jika sudah menggunakan berbagai fitur dan fungsi asterisk secara maksimal.

### `Cons`
- Kualitas suara telepon masih kurang baik dibanding dengan PABX non VoIP.
- Diperlukan orang yang ahli untuk instalasi dan maintenance server VoIP.

### `Perbandingan dengan project kelompok lain`

- Project kelompok kami bukan hanya sekedar aplikasi yang didownload kemudian dihubungkan ke database, tapi lebih dari itu.
- Project kami sudah mulai banyak digunakan di dunia industri modern saat ini, karena sangat menghemat biaya dan dapat menghubungkan
perusahaan / organisasi dengan cabang mereka.
- Banyak contoh dari penggunaan VoIP server, diantaranya voice call Whatsapp, Line, Skype, dll.
- Asterisk adalah aplikasi open source yang paling banyak digunakan sebagai VoIP Server.

## Referensi
```bash
http://wiki.freepbx.org/display/FOP/Installing+FreePBX+13+on+Ubuntu+Server+14.04.2+LTS
```
```bash
https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Documentation
```
```bash
https://www.howtoforge.com/how-to-install-asterisk-for-your-first-pbx-solution
```