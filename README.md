# Learning Bash
___
# Day 01
**Beberapa link**
- [https://en.wikipedia.org/wiki/Pipeline_(Unix)]
- [https://tldp.org/LDP/Bash-Beginners-Guide/Bash-Beginners-Guide.pdf]
- [https://unix.stackexchange.com/questions/590788/treatment-of-env-and-bash-env-in-bash-running-in-bash-and-sh-mode]

**Jenis-jenis shell atau sejenisnya yang diketahui** berikut jenis-jenis nya:
- bash | umum
- rbash | baru nyoba
- sh
- csh
- ksh
- tesh

**Sistem pipe** bekerja dengan cara memberikan stdout dari program sebelum nya. Ke stdin program selanjut nya. Sistem yang menghubungkan pipeline akan mengerjakan program secara concurrently dimana struktur program bisa jalan di rentan waktu yang hampir bersamaan.

**Sample kode BASH_ENV** Berikut kode sample dari penggunaan BASH_ENV
```sh
# Versi sh
echo "echo 'test'" > /tmp/file
BASH_ENV=/tmp/file ENV=/tmp/file sh # Bukti pake sh
```
Dan juga satu lagi sample kode nya
```bash
# Versi bash
echo "echo 'test'" > /tmp/file
BASH_ENV=/tmp/file ENV=/tmp/file bash # Bukti pake bash
```
Didapatkan dari source bahwa BASH_ENV hanya bisa digunakan di non-interactive bash. Namun apa yang terjadi dengan versi sh? Saya sudah coba sendiri dan hasil nya seperti ini
```bash
bruno> ENV=target bash
bruno> ENV=target sh
testamar
sh-5.3$
```
Lagi pula disini apa yang membuat nya menjadi non-interactive? karna variabel? tapi kan itu hanya variabel.
Source dari kode dan penjelasan: [unix.stackexchange.com/questions/590788/treatment-of-env-and-bash-env-in-bash-running-in-bash-and-sh-mode]

**Masalah interactive shell dan non-interactive shell** Beberapa cara telah dicoba untuk mencari bagaimana non-interactive shell dan interactive shell bekerja. Sudah ada beberapa percobaan yang dilakukan mulai dari
```bash
# Gagal gagal akhir nya work (idiot sendiri)
bruno> echo $-
himBHs
bruno> ENV="echo $-" "$ENV"
bash: echo himBHs: command not found
bruno> TGT="echo $-"; "$TGT"
bash: echo himBHs: command not found
bruno> $-
bash: himBHs: command not found
bruno> TGT=$(echo $-); "$TGT"
bash: himBHs: command not found
bruno> TGT=$($-); "$TGT"
bash: himBHs: command not found
bash: : command not found
bruno> TGT=$($-); echo "$TGT"
bash: himBHs: command not found

bruno> TGT=$(echo $-); echo "$TGT"
himBHs
bruno>
```
Lalu ada cara yang melalui file terlebih dulu
```bash
bruno> echo target | bash
bash: line 1: target: command not found
bruno> bash target
hB
bruno> sh target
hB
bruno>
```
Namun disini stdout nya hanya hB. Sedangkan kalo pake -c pada bash nya jadi seperti ini
```bash
bruno> echo target | bash
bash: line 1: target: command not found
bruno> bash target
hB
bruno> sh target
hB
bruno> bash -c target
bash: line 1: target: command not found
bruno> bash -c target
bash: line 1: target: command not found
bruno> bash -c target
bash: line 1: target: command not found
bruno> bash -c "echo $-"
himBHs
bruno> bash "echo $-"
bash: echo himBHs: No such file or directory
bruno> bash "echo $-"
```
Output nya bisa beda sendiri. Kunci yang harus dicari adalah gimana sifat si non-interactive shell itu bekerja. Tapi dulu ada kejadian dimana kode terminal coba dijalankan melalui spawn di terminal namun kode-kode alias nya tidak terdeteksi. Nah ini termasuk perilaku non-interactive shell. Namun ini kan konteks nya mudah. Dari bahasa lain. Nah kalo lewat bash nya langsung? lewat variabel kaya TGT=$(echo $-) ? Menurut deepseek ini masih kurang pembuktian kuat nya kalo itu non-interactive shell kata nya.

**Cara program dieksekusi pada bash** yaitu. Ketika ada suatu program yang dieksekusi maka process baru akan dibuat. Karena bash akan membuat copy dari diri nya sendiri. Proses child ini memiliki environtment yang sama dengan parent nya dan kode proses ID nya yang berbeda. Prosedur ini disebut **forking**.
Setelah proses forking selesai. Ruang address dari proses child ini akan ditimpa dengan data proses baru. Proses ini disebut **exec**.
Mekanisme **fork and exec** ini mengganti perintah lama dengan perintah baru namun dengan lingkungan environtment yang sama seperti konfigurasi input dan output serta variabel dan prioritas. Mekanisme ini digunakan untuk membuat semua proses **UNIX**.
Ini juga diaplikasikan pada sistem linux walaupun itu baru process pertama nya. **init**. (prosedur terakhir **bootstrapping procedure**)

**Jenis-jenis built-in commands** ada tiga jenis. Yaitu sebagai berikut
- **Bourne shell built-ins commands:**
:, ., break, cd, continue, eval, exec, exit, export, getopts, hash, pwd, readonly, return, set, shift, test, [, times, trap, umask and unset.
- **Bash shell built-in commands:**
alias, bind, builtin, command, declare, echo, enable, help, let, local, logout, printf, read, shopt, type, typeset, ulimit and unalias.
- **Special built-in commands:**
break, continue, eval, exec, exit, export, readonly, return, set, shift, trap, unset.
Ketika bash dalam POSIX mode. perintah special built-in berbeda dari perintah built-in lain dalam 3 aspek.
- Special built-in akan ditemukan sebelum fungsi shell ketika command lookup
- Ketika special built in error. Maka interactive shell langsung exit
- Operasi penugasan yang mendahului perintah tetap berlaku di lingkungan shell setelah perintah selesai dijalankan

(Gantung)
**Menjalankan bash tanpa -c atau -s** akan menjalankan shell berupa non-interactive shell. Ini menjelaskan kebingunan awal mengapa bash tanpa -c tidak mengeluarkan output i. Namun yang janggal. Pesan error nya berupa seperti.
```bash
~> bash "echo $-"
bash: echo himBHs: No such file or directory
~>
```
Terlihat ada himBHs. Dimana terdapat i disana walau program nya error

**Numeric comparision pada bash** yaitu ada
-  "-eq": equal to / =
-  "-ne": not equal to / !=
-  "-gt": greater than / >
-  "-lt": less than / <
-  "-ge": greater than or equal / >=
-  "-le": less than or equat / =<

**String checks** pada bash yaitu ada
- = / == : ngecek kaya biasa nya
- != : string nya ga cocok
- "-z": kalo string kosong maka true
- "-n": kalo string ga kosong maka true

**File system test** pada bash yaitu ada
- "-f": cek apakah file nya ada
- "-d": cek apakah file dalam direktori yang telah ada
- "-e": cek apakah path nya ada

(Gantung)
**Melakukan operasi aritmatika** pada bash dapat dilakukan dengan cara
```bash
echo "$((2 + 4 + 5))"
# kalo dulu sih gini
expr 2 + 4
```
Atau bisa juga $(()) = expression/expr? Mungkin?

**Shell commands bisa dikelompokan** menjadi 3. Yaitu ada
- The shell function
- Shell built-ins
- Command yang dibuat di sistem

**CTRL-C Tidak membuat keluar dari interactive shell** karena SIGINT nya telah ditangkap dan diatasi dengan baik. Dan ini termasuk ciri-ciri cari interactive shell

(Gantung)
**Kosa kata SIG semasa baca dokumentasi** serta harus dicari tau lebih lanjut
- SIGINT
- SIGTERM
- SIGHUP
Ditemukan informasi bahwa ini nama nya Signal commands

(Gantung)
**Catatan bahwa** perilaku special built-ins bisa beda pada mode POSIX

___
# Day 02
**Cara membuat PATH** itu dengan kode seperti berikut
```bash
export PATH="$PATH:/home/quanta/Documents/engineer/Bash_scripting"
# Atau bisa juga lebih disederhanakan
export PATH="$PATH:$HOME/Documents/engineer/Bash_scripting"
# $HOME=/home/quanta
```
Jangan lupa memberi ijin eksekusi file pada file yang ditentukan.

**Liat kode-kode file** dengan menggunakan flag -v pada perintah saat eksekusi. Berikut cara nya
```bash
bash -v script.sh
```
Atau bisa juga kalo melalui file. Tambahkan baris ini di paling atas
```bash
#!/bin/bash -v
```
flag nya bisa digabung satu sama lain. Misal flag -x digabung dengan -v. Jadi -xv

**Variabel-variabel yang ditemukan** pada saat belajar ada
- HOME: /home/quanta
- PATH: (kepanjangan ah)
- MAIL: /var/spool/mail/quanta
- PS1: \W>
- HOSTNAME: amarix
- INPUTRC: kosong
- HISTSIZE: 500

**Pertanyaan nya** apa kegunaan bashrc pada etc? apakah ini ada hubungan nya dengan live environtment pada arch? tapi kan di arch live environtment pake .zshrc

**Special parameter** terdiri dari sebagai berikut:
- "$@": none
- "$*": Memilih semua parameter yang ada pada saat eksekusi
- "$#": none
- "$?": Expand to the exit status of the most recently executed foreground pipeline
- "$$": none / output: 19489
- "$!": none
- "$_": none
- "$0": none
Ada pengujian pada salah satu special parameter. Pengujian yang pertama menggunakan "$?".
```bash
echo "$?" # output: 0

ls amar # tes cari directory yang tidak ada

echo "$?" # output: 2
```
Ketika ada program yang error. Maka output dari "$?" akan berubah seketika. Namun ketika program diantara nya berjalan lancar. Maka output nya tetap 0
# Terakhir baca: 1.6
___