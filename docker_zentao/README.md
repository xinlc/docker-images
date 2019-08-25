# [docker-zentao](https://www.zentao.net/download/80098.html)

## 禅道Docker Image File

数据库用户名：root,默认密码：123456。运行时，可以设置MYSQL_ROOT_PASSWORD变量来更改密码。

可挂载目录
/app/zentaopms:该目录为禅道目录，里面包含禅道代码及附件上传目录。
/var/lib/mysql:该目录为数据库的数据目录。

首次运行容器后，浏览器访问http://IP:端口，如果界面显示禅道安装界面，说明容器运行正常。
依照安装程序，最后将禅道安装成功，就可以使用禅道了。

## 安装使用
> 注意：需要关闭下selinux

1、构建镜像
下载安装包，解压缩。 进入docker_zentao目录，执行命令 docker build -t [镜像名称] [Dockerfile所在目录]
```bash
docker build -t zentao ./
```
2、运行镜像
```bash
docker run --name [容器名称] -p [主机端口]:80 -v [主机代码目录]:/app/zentaopms -v [主机数据目录]:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=[数据库密码] -d [镜像名]:latest
```
例如
创建 /data/www /data/data 目录。
执行命令：
```bash
docker run --name zentao -p 80:80 -v /data/www:/app/zentaopms -v /data/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -d zentao:latest
```
3、安装禅道
浏览器访问 http://ip，显示禅道安装页面，安装禅道。

## 升级

1、重新构建镜像
重新修改Dockerfile，重新运行构建镜像命令
$random 改为其他字符串, 重新 build
```diff
...
- RUN random=`date +%s`; curl http://cdn.zentaopm.com/latest/zentao.zip?rand=$random -o /var/www/zentao.zip
+ RUN random=`date +%s`; curl http://cdn.zentaopm.com/latest/zentao.zip?rand=1 -o /var/www/zentao.zip
...
```