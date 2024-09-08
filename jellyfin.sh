docker run -d \
 --name jellyfin \
 -p 80:8096 \
 --volume /home/cliff/workspace/jellyfin_workspace/config:/config \
 --volume /home/cliff/workspace/jellyfin_workspace/cache:/cache \
 --mount type=bind,ro,source=/home/backup/pi/movie,target=/media \
 --device /dev/dri/card0:/dev/dri/card0 \
 --device /dev/dri/renderD128:/dev/dri/renderD128 \
 --restart=unless-stopped \
 jellyfin/jellyfin
