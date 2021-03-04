DATE_VERSION:=`date "+%y.%m.%d"`
CPU_ARCH:=$(shell lscpu  | grep Arch| awk '{print $$2}')
CONF_USER=cliff

all:
	@echo "==========================[$@] <= [$^]"
	@echo ${DATE_VERSION}
	make sudoers
	make prepare
	make netspeed.sh
	make okular
	make ssh
	make fanyi
	make terminator
	make net-speed
	make rsync
	make ycmgentemp
	make virtualenv
	make virtualbox
	make cifs-utils
	make compiles
	make shell
	make vim
	

sudoers:
	@echo "==========================[$@] <= [$^]"
	echo '%sudo ALL=(ALL:ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/`whoami` 

prepare:
	@echo "==========================[$@] <= [$^]"
	sudo apt update
cmake:
	@echo "==========================[$@] <= [$^]"
	sudo apt install -y cmake 

vim: vim-gtk cmake
	@echo "==========================[$@] <= [$^]"
	sudo apt install -y vim
	-sudo apt install -y ctags
	-sudo apt install -y universal-ctags
	-if [ ! -d ~/vim_install ] ;then  cd ./res/vim_install/ && ./install.sh; fi

ycmgentemp:
	@echo "==========================[$@] <= [$^]"
	sudo cp ./res/vim_install/ycmgentemplate.sh /usr/bin/

ssh:
	@echo "==========================[$@] <= [$^]"
	sudo apt install -y git
	mkdir -p ~/.ssh
	cp ./res/.ssh/config ~/.ssh/
	echo "ssh -N -L 88:192.168.2.1:80 pi_remote"
git:
	@echo "==========================[$@] <= [$^]"
	sudo apt install -y ssh
rsync:
	@echo "==========================[$@] <= [$^]"
	sudo apt install -y rsync
lftp:
	@echo "==========================[$@] <= [$^]"
	#@sudo apt install -y lftp
	#@sudo apt install -y lftpd-hpa
	sudo echo -e 'TFTP_USERNAME="tftp" \nTFTP_DIRECTORY="/home/cliff/data/tftpd" \nTFTP_ADDRESS=":69" \nTFTP_OPTIONS="--secure"' > /etc/default/tftpd-hpa
virtualbox:
	@echo "==========================[$@] <= [$^]"
	sudo apt install -y virtualbox
fanyi:
	@echo "==========================[$@] <= [$^]"
	sudo ./res/fanyi
okular:
	@echo "==========================[$@] <= [$^]"
	sudo apt install -y okular
nmap:
	@echo "==========================[$@] <= [$^]"
	sudo apt install -y nmap
indicator-sysmonitor:
	@echo "==========================[$@] <= [$^]"
	sudo apt install -y nmap
terminator:
	@echo "==========================[$@] <= [$^]"
	sudo apt install -y terminator
	sudo mkdir -p /root/.config/terminator
	sudo mkdir -p /${CONF_USER}/.config/terminator
	sudo cp ./res/term_config/config /root/.config/terminator/
	sudo cp ./res/term_config/config /${CONF_USER}/.config/terminator/
language:
	@echo "==========================[$@] <= [$^]"
	sudo apt install -y fonts-droid-fallback ttf-wqy-zenhei ttf-wqy-microhei fonts-arphic-ukai fonts-arphic-uming
	export LANG="C.UTF-8"
vim-gtk:
	@echo "==========================[$@] <= [$^]"
	sudo apt install -y vim-gtk
virtualenv:
	@echo "==========================[$@] <= [$^]"
	udo apt install python3-pip
	udo pip install virtualenv
	echo 'virtualenv env38'
	echo 'virtualenv -p /usr/local/bin/python3.8 env38'
windows-font:
	@echo "==========================[$@] <= [$^]"
	sudo mkdir /usr/share/fonts/truetype/windows-fonts
	sudo chmod -R 777  /usr/share/fonts/truetype/windows-font
	cd /usr/share/fonts/truetype/windows-font
	sudo mkfontscale
	sudo mkfontdir
	sudo fc-cache -fv
npm:
	@echo "==========================[$@] <= [$^]"
	sudo apt install -y npm
	npm install --prefix ./install/here <package>
nodejs:
	@echo "==========================[$@] <= [$^]"
	sudo apt install -y nodejs
debs-backup:
	@echo "==========================[$@] <= [$^]"
	./res/backup_debs.sh
net-speed:
	@echo "==========================[$@] <= [$^]"
	sudo apt install gettext -y
	make -C ./res/NetSpeed install
	make -C ./res/NetSpeed enable
netspeed.sh:
	@echo "==========================[$@] <= [$^]"
	sudo cp ./res/netspeed.sh /usr/bin
beautify.sh:
	@echo "==========================[$@] <= [$^]"
	sudo cp ./res/beautify.sh /usr/bin
frp_install:
	@echo "==========================[$@] <= [$^]"
	@echo ${CPU_ARCH}
	export SHELL=/bin/bash
	-if [ ${CPU_ARCH} == x86_64 ];then cd ./res/frp && tar -zxvf ./frp_0.34.1_linux_amd64.tar.gz   ;fi
	-if [ ${CPU_ARCH} == x86_64 ];then  sudo cp ./res/frp/frp_0.34.1_linux_amd64/frpc /usr/bin     ;fi
	-if [ ${CPU_ARCH} == x86_64 ];then  sudo cp ./res/frp/frp_0.34.1_linux_amd64/frps /usr/bin     ;fi
	-if [ ${CPU_ARCH} == x86_64 ];then  cd ./res/frp && rm -r ./frp_0.34.1_linux_amd64             ;fi
	-if [ ${CPU_ARCH} != x86_64 ];then  cd ./res/frp && tar -zxvf ./frp_0.34.1_linux_arm64.tar.gz  ;fi
	-if [ ${CPU_ARCH} != x86_64 ];then  sudo cp ./res/frp/frp_0.34.1_linux_arm64/frpc /usr/bin     ;fi
	-if [ ${CPU_ARCH} != x86_64 ];then  sudo cp ./res/frp/frp_0.34.1_linux_arm64/frps /usr/bin     ;fi
	-if [ ${CPU_ARCH} != x86_64 ];then  cd ./res/frp && rm -r ./frp_0.34.1_linux_arm64             ;fi
	-sudo mkdir -p /etc/frp
	-sudo cp ./res/frp/frpc.ini /etc/frp
	-sudo cp ./res/frp/frpc_ali.ini /etc/frp
	-sudo cp ./res/frp/frps.ini /etc/frp
	-sudo cp ./res/frp/frpc.service /lib/systemd/system
	-sudo cp ./res/frp/frpc_ali.service /lib/systemd/system
	-sudo cp ./res/frp/frps.service /lib/systemd/system
frpc_enable:
	@echo "==========================[$@] <= [$^]"
	sudo systemctl enable frpc
frpc_disable:
	@echo "==========================[$@] <= [$^]"
	sudo systemctl stop frpc
	sudo systemctl disable frpc
frps_enable:
	@echo "==========================[$@] <= [$^]"
	sudo systemctl enable frps
frps_disable:
	@echo "==========================[$@] <= [$^]"
	sudo systemctl stop frps
	sudo systemctl disable frps
cacaview:
	@echo "==========================[$@] <= [$^]"
	sudo apt install caca-utils
nfs-server:
	@echo "==========================[$@] <= [$^]"
	sudo apt install nfs-server
cifs-utils:
	@echo "==========================[$@] <= [$^]"
	sudo apt install cifs-utils
kill.sh:
	@echo "==========================[$@] <= [$^]"
	sudo cp ./res/kill.sh /usr/bin
dev_watch:
	@echo "==========================[$@] <= [$^]"
	cd ./res/dev_watch && sudo ./install.sh
led7219:
	@echo "==========================[$@] <= [$^]"
	cd ./res/led7219 && sudo ./install.sh
rtmp:
	@echo "==========================[$@] <= [$^]"
	cd ./res/rtmp && cp ./res/rtmp/push_rtmp* /usr/local/bin
	#@cd ./res/rtmp/nginx/ && ./install
compiles:
	@echo "==========================[$@] <= [$^]"
	sudo apt install gcc g++ -y
	sudo apt install qemu-system-x86 -y
	sudo apt install golang
shell:
	@echo "==========================[$@] <= [$^]"
	cp -a ../../shell ~/
chromium-browser:
	@echo "==========================[$@] <= [$^]"
	sudo apt install chromium-browser
bashrc:
	@echo "==========================[$@] <= [$^]"
	cp ./res/bash/.bashrc ~
	cp ./res/bash/bash.bashrc /etc/


#==============================================
PHONY += all
PHONY += prepare
PHONY += vim
PHONY += ssh
PHONY += git
PHONY += rsync

#==============================================
FORCE:

PHONY += all
PHONY += FORCE
.PHONY: PHONY
