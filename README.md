# awdplus_demo

awdp 环境搭建及题目复现

每次搭建php环境总是出现不一样的问题，网上大多数是用的官方更新源，在国内vps上速度令人捉急，于是乎，借助dockerhub中已有项目进行了简单修改，望能帮助需要的人节省时间。

具体的docker安装不细说了，docker国内源可以使用阿里云中的“容器镜像服务 -> 镜像加速器”功能

可以修改并新建daemon配置文件/etc/docker/daemon.json来使用加速器
```
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://xxx.mirror.aliyuncs.com"] //xxx需登录阿里云的容器镜像服务 -> 镜像加速器获取
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

docker-compose可以直接使用pip进行安装
```
pip install docker-compose
```

## 基本使用

使用docker搭建lamp环境,借用dockerhub中的linode/lamp项目，搭建的版本为：lamp(ubuntu14+apache2.4.7+mysql5.5.62+PHP5.5.9)
数据库密码：Admin2015
将需要搭建的web源码放到与Dockerfile同目录的web文件夹中即可。
默认将80端口映射到宿主机的10099端口

执行以下命令启动docker即可
```
docker-compose build
docker-compose up -d
```
## docker容器进入命令模式

```
docker exec -it 容器名字 bash
```


##修改mysql密码
```
use mysql;
select * from user;
update user set password=password("test123") where user=root;
flush privileges; //刷新权限使密码生效
```

## apache 虚拟主机配置
可通过该方法，一个容器内部署多个web网站

默认的web是在/var/www/html/explame.com目录，如果想建多个站点可以进行如下操作：

禁用默认的apache虚拟主机
```
a2dissite *default
```

切换到/var/www/html目录
创建一个新的网站文件夹，包括public_htmllog,backups（存放web代码，log存放日志）
```
mkdir -p /var/www/html/example.com/{public_html,log,backups}
```

创建关于新的虚拟主机的配置文件，可以在复制原来example.com.conf文件进行修改
```
/etc/apache2/sites-available/example.com.conf
```

具体内容如下：

```
# domain: example.com
# public: /var/www/html/example.com/public_html/

<VirtualHost *:80>
  # Admin email, Server Name (domain name), and any aliases
  ServerAdmin webmaster@example.com
  ServerName  example.com
  ServerAlias www.example.com

  # Index file and Document Root (where the public files are located)
  DirectoryIndex index.html index.php
  DocumentRoot /var/www/html/test.com/public_html
  # Log file locations
  LogLevel warn
  ErrorLog  /var/www/html/test.com/log/error.log
  CustomLog /var/www/html/test.com/log/access.log combined
</VirtualHost>
```

使新网站的配置文件生效
```
a2ensite example.com.conf
```

重启apache服务
```
systemctl reload apache2
```



## 不定期更新
