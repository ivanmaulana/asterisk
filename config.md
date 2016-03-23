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

## Extension.conf

Tempat penyimpanan: '`/etc/asterisk/`'

*Back up* *file*:
```bash
sudo cp /etc/asterisk/extensions.conf /etc/asterisk/extensions.conf.orig
```

*Edit* *file*:
```bash
sudo vi /etc/asterisk/extensions.conf
```


Untuk `menyimpan file`, `start`, `stop`, dan `restart` caranya sama seperti `sip.conf` yang ada diatas

Beberapa hal yang perlu diperhatikan tentang konfigurasi ini:
- Apapun yang berhubungan dengan `[voipms-outbound]`, `[voipms-inbound]` dan dua hal lainnya yang berasal dari `sip.conf` diatas, merupakan configurasi detail dari register `(vo-ip.ms)`.
- Hal ini digunakan untuk berinteraksi agar dapat terhubung dengan `PSTN` `(Public Switched Telephone Network)`.

### Konfigurasi user VoIP Server

```bash
sudo vi /etc/asterisk/extensions.conf

[internal]

exten => s,1,Answer()
exten => s,n,PlayBack(custom-draalincom)
exten => s,n,PlayBack(custom-menuoptions)

exten => s,n,Background(vm-press)
exten => s,n,Background(digits/1)
exten => s,n,Background(vm-for)
exten => s,n,Background(custom-work)

exten => s,n,Background(vm-press)
exten => s,n,Background(digits/2)
exten => s,n,Background(vm-for)
exten => s,n,Background(custom-cell)

exten => s,n,Background(vm-press)
exten => s,n,Background(digits/3)
exten => s,n,Background(vm-for)
exten => s,n,Background(custom-home)

exten => s,n,WaitExten()

exten => 1,1,Dial(SIP/7001,60)

exten => 7001,1,Answer()
exten => 7001,2,Dial(SIP/7001,60)
exten => 7001,3,Playback(vm-nobodyavail)
exten => 7001,4,VoiceMail(7001@main)
exten => 7001,5,Hangup()

exten => 7002,1,Answer()
exten => 7002,2,Dial(SIP/7002,60)
exten => 7002,3,Playback(vm-nobodyavail)
exten => 7002,4,VoiceMail(7002@main)
exten => 7002,5,Hangup()

exten => 7003,1,Answer()
exten => 7003,2,Dial(SIP/7003,60)
exten => 7003,3,Playback(vm-nobodyavail)
exten => 7003,4,VoiceMail(7003@main)
exten => 7003,5,Hangup()

exten => 7004,1,Answer()
exten => 7004,2,Dial(SIP/7004,60)
exten => 7004,3,Playback(vm-nobodyavail)
exten => 7004,4,VoiceMail(7004@main)
exten => 7004,5,Hangup()

exten => 7005,1,Answer()
exten => 7005,2,Dial(SIP/7005,60)
exten => 7005,3,Playback(vm-nobodyavail)
exten => 7005,4,VoiceMail(7005@main)
exten => 7005,5,Hangup()

exten => 7006,1,Answer()
exten => 7006,2,Dial(SIP/7006,60)
exten => 7006,3,Playback(vm-nobodyavail)
exten => 7006,4,VoiceMail(7006@main)
exten => 7006,5,Hangup()

exten => 7007,1,Answer()
exten => 7007,2,Dial(SIP/7007,60)
exten => 7007,3,Playback(vm-nobodyavail)
exten => 7007,4,VoiceMail(7007@main)
exten => 7007,5,Hangup()

exten => 7008,1,Answer()
exten => 7008,2,Dial(SIP/7008,60)
exten => 7008,3,Playback(vm-nobodyavail)
exten => 7008,4,VoiceMail(7008@main)
exten => 7008,5,Hangup()

exten => 8500,1,VoicemailMain()
exten => 70022,1,VoicemailMain(7002@main)
exten => 8500,n,Hangup()

```