#1. apt install apt-mirror

#2. edit /etc/apt/mirror.list



############# config ##################
#
set base_path    /home/backup/apt_srcs
#
set mirror_path  $base_path/mirror
set skel_path    $base_path/skel
set var_path     $base_path/var
set cleanscript $var_path/clean.sh
# set defaultarch  <running host architecture>
# set postmirror_script $var_path/postmirror.sh
# set run_postmirror 0
set nthreads     20
set _tilde 0
#
############# end config ##############



deb http://mirrors.aliyun.com/ubuntu/ focal main restricted
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted
deb http://mirrors.aliyun.com/ubuntu/ focal universe
deb http://mirrors.aliyun.com/ubuntu/ focal-updates universe
deb http://mirrors.aliyun.com/ubuntu/ focal multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted
deb http://mirrors.aliyun.com/ubuntu/ focal-security universe
deb http://mirrors.aliyun.com/ubuntu/ focal-security multiverse


#3. apt-mirror and downloading...

#4. nginx local http server
server {
    listen 80 default_server;
    # listen [::]:80 default_server;
    
    # 显示目录
    autoindex on;
    
    # 镜像所在的目录
    root /home/mirror-data/apt-mirror/mirror;

    # Add index.php to the list if you are using PHP
    index index.html index.htm index.nginx-debian.html;
    
    # 主机域名，填写localhost就是通过IP访问
    server_name 192.168.0.108;

    location / {
        # First attempt to serve request as file, then
        # as directory, then fall back to displaying a 404.
        try_files $uri $uri/ =404;
    }
    
    # 访问记录
    access_log /home/mirror-data/apt-mirror.log;

}


#5.  nginx -t

#6 update source.list
deb [arch=amd64] http://自建源IP/cn.archive.ubuntu.com/ubuntu xenial main restricted universe multiverse
deb [arch=amd64] http://自建源IP/cn.archive.ubuntu.com/ubuntu xenial-updates main restricted universe multiverse
deb [arch=amd64] http://自建源IP/cn.archive.ubuntu.com/ubuntu xenial-proposed main restricted universe multiverse
deb [arch=amd64] http://自建源IP/cn.archive.ubuntu.com/ubuntu xenial-backports main restricted universe multiverse
deb [arch=amd64] http://自建源IP/security.ubuntu.com/ubuntu xenial-security main restricted universe multiverse
