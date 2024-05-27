##логи
===============================
tail -f /var/log/dhcpd.log
 truncate -s 0 /var/log/dhc


##менеджер терминлов
======================
byobu
F6, shift+f6, отсоединиться но не выйти
F2 новое окно
F3, F4 перемещение
F8 имя окна
Ctrl+a потом k

##NTP сервер времени
========================
date
ntpq -p
ntpdate 10.151.88.1
restart ntpd

##Отмена пароля sudo
========================
в файле /etc/sudoers добавить NOPASSWD: в строке:
%astra-admin    ALL=(ALL:ALL) NOPASSWD: ALL

##Службы
========================
ps -eF
ps axu | gep firefox вывести службы с именем
pidof 15172
ps -Al | grep ntp
kill -9 15172 закрыть службу
systemctl start/stop/status Phantom.service


##Wireshark tcp dump
========================
usermod -aG wireshark administrator

newrp wireshark добавление в текущей сессии или перезайти


##Монтирование диска
========================
sudo lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL
sudo umount /dev/sdb1  либо umount -l /dev/sdb1
fdisk -l
nano /etc/fstab
blkid uuid разделов

##Меню запуск от администратор
========================
WIN-R, ALT+F2
/home/administrator/.fly/ru_RU.UTF-8.miscrc найти строки, где есть "Запустить от имени Администратора", и в команде fly-su -c fly-open -e %f заменить -е на --exec.


##Phantom
========================
fdisk -l
apt search pahntom
ls -la


##Информация о системе:
========================
uname -r 
lsb_release -a
##Монтирование репозитория cdrom:
========================
 mcedit /etc/apt/sources.list

# deb cdrom:[OS Astra Linux 1.7.4 1.7_x86-64 DVD ]/ 1.7_x86-64 contrib main non-free
#deb cdrom:[OS Astra Linux 1.7.4 1.7_x86-64 DVD ]/ 1.7_x86-64 contrib main non-free

#
#deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-main/ 1.7_x86-64 main contrib non-free
#deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-update/ 1.7_x86-64 main contrib non-free

#deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-base/ 1.7_x86-64 main contrib non-free
#deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 main contrib non-free

sudo mount /home/Distrib/AstraLinux/1.7.4-24.04.2023_14.23.iso /media/cdrom
sudo mount -o loop /home/Distrib/AstraLinux/1.7.4-24.04.2023_14.23.iso /media/cdrom

	для подключения репозитория с диска:
sudo apt-cdrom add
sudo apt update
	Для использования сетевых репозиториев:(Временно сменить протокол интернет-репозиториев в файле /etc/apt/source.list на протокол htt):
apt policy apt-transport-https ca-certificates
sudo apt install apt-transport-https ca-certificates
sudo apt update
##XRDP:
========================
sudo su
apt -y install xrdp xorgxrdp
systemctl enable xrdp
systemctl start xrdp

ufw allow 3389/tcp
ufw reload

	Чтобы при повторном подключении попадать в свой прежний сеанс нужно немного изменить настройки XRDP, для этого в файле /etc/xrdp/xrdp.ini меняем fork=true на fork=false
cp /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.ini.old
sed -i 's/fork=true/fork=false/' /etc/xrdp/xrdp.ini

Далее в файле /etc/xrdp/xrdp.ini комментируем секцию [Xvnc] , а секцию [Xorg] наоборот, – раскомментируем.
cp /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.ini.old2
mcedit /etc/xrdp/xrdp.ini

systemctl restart xrdp

	Если будут проблемы с переключением раскладки, откройте файл /etc/xrdp/xrdp_keyboard.ini
cp /etc/xrdp/xrdp_keyboard.ini /etc/xrdp/xrdp_keyboard.ini.old
mcedit /etc/xrdp/xrdp_keyboard.ini
И добавьте в конец файла:
[layouts_map_ru]
rdp_layout_us=ru,us
rdp_layout_ru=ru,us

[rdp_keyboard_ru]
keyboard_type=4
keyboard_type=7
keyboard_subtype=1
options=grp:alt_shift_toggle
rdp_layouts=default_rdp_layouts
layouts_map=layouts_map_ru

systemctl restart xrdp


	#Дополнительно:
Настройте доступ к RDP для текущего пользователя, добавив его в группу xrdp:
sudo adduser <имя_пользователя> xrdp

##Proxy apt:
========================
APT может работать  отдельно  с персональными настройками. Такие настройки указываются в файле 
/etc/apt/apt.conf:
Acquire::http::proxy "http://<имя_пользователя>:<пароль>@<IP-адрес_proxy>:<IP-порт_proxy>/";
Acquire::https::proxy "http://<имя_пользователя>:<пароль>@<IP-адрес_proxy>:<IP-порт_proxy>/";
Acquire::ftp::proxy "http://<имя_пользователя>:<пароль>@<IP-адрес_proxy>:<IP-порт_proxy>/";
Acquire::socks::proxy "http://<имя_пользователя>:<пароль>@<IP-адрес_proxy>:<IP-порт_proxy>/";
Acquire::::Proxy "true";
10.152.90.4:8080

Acquire::http::proxy "http://10.152.90.4:8080/";
Acquire::https::proxy "http://10.152.90.4:8080/";
Acquire::ftp::proxy "http://10.152.90.4:8080/";
Acquire::socks::proxy "http://10.152.90.4:8080/";
Acquire::::Proxy "true";

Для задания исключений использовать опцию DIRECT:
Acquire::http::Proxy {
    local-apt-repo.local.loc DIRECT;
};


fly-kcmshell5 proxy

env | grep proxy
##драйвера
==========
mcedit /etc/default/grub
man intel
lsmod | grep intel
rpm -qa X11-driver-video-*
xrandr
lspci |grep -E "VGA"
lspci | grep -v -s 00:02.0
dmesg | grep i915 -A4
hwinfo --gfxcard
sudo update-grub






