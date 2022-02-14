wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/debian/bullseye/gitlab-ce_14.7.2-ce.0_amd64.deb/download.deb
dpkg -i ./gitlab-ce_14.7.2-ce.0_amd64.deb
vim /etc/gitlab/gitlab.rb
sudo gitlab-ctl reconfigure



root@ubuntu:~# gitlab-ctl status
run: alertmanager: (pid 12758) 66s; run: log: (pid 12379) 219s
run: gitaly: (pid 12684) 70s; run: log: (pid 11883) 357s
run: gitlab-monitor: (pid 12721) 69s; run: log: (pid 12309) 240s
run: gitlab-workhorse: (pid 12708) 70s; run: log: (pid 12226) 264s
run: grafana: (pid 12781) 65s; run: log: (pid 12538) 113s
run: logrotate: (pid 12259) 253s; run: log: (pid 12268) 252s
run: nginx: (pid 12242) 259s; run: log: (pid 12250) 258s
run: node-exporter: (pid 12715) 69s; run: log: (pid 12296) 244s
run: postgres-exporter: (pid 12770) 65s; run: log: (pid 12399) 213s
run: postgresql: (pid 12004) 349s; run: log: (pid 12016) 346s
run: prometheus: (pid 12732) 69s; run: log: (pid 12351) 225s
run: redis: (pid 11840) 367s; run: log: (pid 11847) 364s
run: redis-exporter: (pid 12725) 69s; run: log: (pid 12330) 232s
run: sidekiq: (pid 12200) 271s; run: log: (pid 12211) 270s
run: unicorn: (pid 12171) 277s; run: log: (pid 12189) 276s


root/5iveL!fe


sudo gitlab-ctl reconfigure
重新加载配置，每次修改/etc/gitlab/gitlab.rb文件之后执行

sudo gitlab-ctl status
查看 GitLab 状态

sudo gitlab-ctl start
启动 GitLab

sudo gitlab-ctl stop
停止 GitLab

sudo gitlab-ctl restart
重启 GitLab

sudo gitlab-ctl tail
查看所有日志

sudo gitlab-ctl tail nginx/gitlab_acces.log
查看 nginx 访问日志

sudo gitlab-ctl tail postgresql
查看 postgresql 日志
