docker run -d \
 --name jellyfin \
 --net=host \
 --volume /home/cliff/workspace/jellyfin_workspace/config:/config \
 --volume /home/cliff/workspace/jellyfin_workspace/cache:/cache \
 --mount type=bind,source=/home/backup/pi/movie,target=/media \
 --restart=unless-stopped \
 jellyfin/jellyfin
