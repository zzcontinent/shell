sudo docker run --detach \
  --hostname gitlab.lixf.ink \
  --publish 443:443 --publish 80:80 --publish 23:22 \
  --name gitlab \
  --restart always \
  --volume /data/gitlab/config:/etc/gitlab \
  --volume /data/gitlab/logs:/var/log/gitlab \
  --volume /data/gitlab/data:/var/opt/gitlab \
  gitlab/gitlab-ce:latest


sudo docker exec -it gitlab /bin/bash

gitlab-rails console

user=User.find_by_username 'root'
user.password="88888888"   #这里请换成一个复杂的密码
user.save!


gitlab内部集成了letsencrypt，因此，这里只需要启用letsencrypt，并进行一些必要的配置

用vim打开/data/gitlab/config/gitlab.rb，修改以下内容

在32行左右，将external_url前面的#删掉，并在单引号中填写gitlab服务器的https地址，例如https://gitlab.lixf.ink
在2235行左右，修改下面几项
letsencrypt['enable'] = true #删除前面的#号，并将值修改为true
letsencrypt['contact_emails'] = ['foo@email.com'] #删除前面的#号,修改为自己的邮箱
letsencrypt['auto_renew'] = true #删除前面的#号
然后，执行下面命令重启gitlab容器

sudo docker restart gitlab
等容器重启之后，gitlab就会通过letsencrypt自动签发免费的HTTPS证书，等证书签发成功(大概3分钟左右)，就可以通过https://gitlab.lixf.ink访问我们的代码仓库了
