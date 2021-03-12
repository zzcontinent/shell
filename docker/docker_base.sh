
#1. pull ubuntu:latest
docker pull ubuntu

#2. mount share directory, and install ifconfig ping htop vim(/root/.bashrc) 
docker run -it --name=12345 -v /home/cliff/dockerworkspace/volume_share:/mnt -d ubuntu:base bash
docker exec -it container_name bash
apt update
apt install net-tools  iputils-ping vim
apt install ssh

#3. commit base images
docker commit -p container_name ubuntu:base(new image)


#4. install shared libaries and apps
apt install lib32ncurses5 (32 bits lib)
apt-get install lib32stdc++6

#5. export images
docker save ubuntu:base -o ubuntu_base.tgz
docker load -i ubuntu_base.tgz

#6. make this to docker files, and commit as new toolchain compile environment


#7. docker run with gui
host cmd: xhost +
docker cmd:
docker run -itd \
  -v /home/cliff/dockerworkspace/volume_share:/mnt \
  -v /etc/localtime:/etc/localtime:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=unix$DISPLAY \
  -e GDK_SCALE \
  -e GDK_DPI_SCALE \
  --name test123 \
  --net=host \
  ubuntu:base \
  bash

#8. docker use usb
docker run -itd  -v /home/cliff/tmp:/mnt --device /dev/bus/usb:/dev/bus/usb   ubuntu:18.04_rkn
