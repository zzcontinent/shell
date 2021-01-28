DATE_VERSION:=`date "+%y.%m.%d"`
CPU_ARCH:=`lscpu  | grep Arch| awk '{print $$2}'`

all:
	@echo "==========================[$@] <= [$^]"
	@echo ${DATE_VERSION}

prepare:
	@echo "==========================[$@] <= [$^]"
	@sudo apt update
vim:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install -y vim
	-@sudo apt install -y ctags
	-@sudo apt install -y universal-ctags
	@cd ./res/vim_install/ && ./install.sh

ycmgentemp:
	@echo "==========================[$@] <= [$^]"
	@sudo cp ./res/vim_install/ycmgentemplate.sh /usr/bin/

ssh:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install -y git
	@echo "ssh -N -L 88:192.168.2.1:80 pi_remote"
git:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install -y ssh
rsync:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install -y rsync
lftp:
	@echo "==========================[$@] <= [$^]"
	#@sudo apt install -y lftp
	#@sudo apt install -y lftpd-hpa
	@sudo echo -e 'TFTP_USERNAME="tftp" \nTFTP_DIRECTORY="/home/cliff/data/tftpd" \nTFTP_ADDRESS=":69" \nTFTP_OPTIONS="--secure"' > /etc/default/tftpd-hpa
virtualbox:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install -y virtualbox
fanyi:
	@echo "==========================[$@] <= [$^]"
	@sudo ./res/fanyi
okular:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install -y okular
nmap:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install -y nmap
indicator-sysmonitor:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install -y nmap
terminator:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install -y terminator
	@sudo mkdir -p ~/.config/terminator
	@sudo cp ./res/term_config/configt ~/.config/terminator/
language:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install -y fonts-droid-fallback ttf-wqy-zenhei ttf-wqy-microhei fonts-arphic-ukai fonts-arphic-uming
	@export LANG="C.UTF-8"
vim-gtk:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install -y vim-gtk
virtualenv:
	@echo "==========================[$@] <= [$^]"
	@sudo pip install virtualenv
	@echo 'virtualenv env38'
	@echo 'virtualenv -p /usr/local/bin/python3.8 env38'
windows-font:
	@echo "==========================[$@] <= [$^]"
	@sudo mkdir /usr/share/fonts/truetype/windows-fonts
	@sudo chmod -R 777  /usr/share/fonts/truetype/windows-font
	@cd /usr/share/fonts/truetype/windows-font
	@sudo mkfontscale
	@sudo mkfontdir
	@sudo fc-cache -fv
npm:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install -y npm
	@npm install --prefix ./install/here <package>
nodejs:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install -y nodejs
debs-backup:
	@echo "==========================[$@] <= [$^]"
	@./res/backup_debs.sh
net-speed:
	@echo "==========================[$@] <= [$^]"
	@make -C ./res/NetSpeed install
	@make -C ./res/NetSpeed enable
netspeed.sh:
	@echo "==========================[$@] <= [$^]"
	@sudo cp ./res/netspeed.sh /usr/bin
beautify.sh:
	@echo "==========================[$@] <= [$^]"
	@sudo cp ./res/beautify.sh /usr/bin
frp_install:
	@echo "==========================[$@] <= [$^]"
	@-[ ${CPU_ARCH} == 'x86_64' ] && cd ./res/frp && tar -zxvf ./frp_0.34.1_linux_amd64.tar.gz
	@-[ ${CPU_ARCH} == 'x86_64' ] && sudo cp ./res/frp/frp_0.34.1_linux_amd64/frpc /usr/bin
	@-[ ${CPU_ARCH} == 'x86_64' ] && sudo cp ./res/frp/frp_0.34.1_linux_amd64/frps /usr/bin
	@-[ ${CPU_ARCH} == 'x86_64' ] && cd ./res/frp && rm -r ./frp_0.34.1_linux_amd64
	@-[ ${CPU_ARCH} != 'x86_64' ] && cd ./res/frp && tar -zxvf ./frp_0.34.1_linux_arm64.tar.gz
	@-[ ${CPU_ARCH} != 'x86_64' ] && sudo cp ./res/frp/frp_0.34.1_linux_arm64/frpc /usr/bin
	@-[ ${CPU_ARCH} != 'x86_64' ] && sudo cp ./res/frp/frp_0.34.1_linux_arm64/frps /usr/bin
	@-[ ${CPU_ARCH} != 'x86_64' ] && cd ./res/frp && rm -r ./frp_0.34.1_linux_arm64
	@-sudo mkdir -p /etc/frp
	@-sudo cp ./res/frp/frpc.ini /etc/frp
	@-sudo cp ./res/frp/frpc_ali.ini /etc/frp
	@-sudo cp ./res/frp/frps.ini /etc/frp
	@-sudo cp ./res/frp/frpc.service /lib/systemd/system
	@-sudo cp ./res/frp/frpc_ali.service /lib/systemd/system
	@-sudo cp ./res/frp/frps.service /lib/systemd/system
frpc_enable:
	@echo "==========================[$@] <= [$^]"
	@sudo systemctl enable frpc
frpc_disable:
	@echo "==========================[$@] <= [$^]"
	@sudo systemctl stop frpc
	@sudo systemctl disable frpc
frps_enable:
	@echo "==========================[$@] <= [$^]"
	@sudo systemctl enable frps
frps_disable:
	@echo "==========================[$@] <= [$^]"
	@sudo systemctl stop frps
	@sudo systemctl disable frps
cacaview:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install caca-utils
nfs-server:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install nfs-server
cifs-utils:
	@echo "==========================[$@] <= [$^]"
	@sudo apt install cifs-utils
kill.sh:
	@echo "==========================[$@] <= [$^]"
	@sudo cp ./res/kill.sh /usr/bin
dev_watch:
	@echo "==========================[$@] <= [$^]"
	@cd ./res/dev_watch && sudo ./install.sh

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
