# Linux/UNIX *Command Line Interface*

## sip.conf

Tempat penyimpanan: '`/etc/asterisk/`'

*Back up* *file*:
```bash
sudo cp /etc/asterisk/sip.conf /etc/asterisk/sip.conf.orig
```

Edit *file*:
```bash
sudo vi /etc/asterisk/sip.conf
```

Cara menyimpan menggunakan vi:
- Tekan '`ESC`' kemudian lepaskan.
- Tekan '`Shift + :`' kemudian lepaskan kembali.
- Ketik '`wq!`'.
- Tekan '`Enter`'.

*Restart* atau *reload* asterisk: (dilakukan setelah mengedit '`sip.conf`')
```bash
sudo asterisk -rx reload
```

*Stop, start, and restart* asterisk dari *init side*:
```bash
sudo /etc/init.d/asterisk start
```


Beberapa hal yang perlu diperhatikan tentang konfigurasi:
- Apapun yang berhubungan dengan [700x] adalah ekstensi yang saya gunakan pada ponsel vo-ip yang berbeda atau klien pada komputer saya. Anda bisa men-download sebuah software yang disebut "X-Lite" dan login dengan ekstensi dan IP dari Ubuntu Asterisk server atau domain nama Anda jika Anda memiliki satu.
- Ingatlah untuk mengedit *password*, *nama domain* (jika menggunakan satu) atau *localnet* tersebut.

### `Konfigurasi user VoIP Server`
- User VoIP server ada 8.
- User : 7001 - 7008,
- Password : password

```bash
sudo vi /etc/asterisk/sip.conf

[general]
context = internal
allowguest = no
allowoverlap = no
bindport = 5060
bindaddr = 0.0.0.0
srvlookup = no
disallow = all
allow = ulaw
alwaysauthreject = yes
canreinvite = no
nat = yes
session-timers = refuse
externhost = domainname.com
externrefresh = 15
localnet = 192.168.1.0/255.255.255.0

[7001]
type = friend
host = dynamic
secret = password
context = internal

[7002]
type = friend
host = dynamic
secret = password
context = internal

[7003]
type = friend
host = dynamic
secret = password
context = internal

[7004]
type = friend
host = dynamic
secret = password
context = internal

[7005]
type = friend
host = dynamic
secret = password
context = internal

[7006]
type = friend
host = dynamic
secret = password
context = internal

[7007]
type = friend
host = dynamic
secret = password
context = internal

[7008]
type = friend
host = dynamic
secret = password
context = internal
```