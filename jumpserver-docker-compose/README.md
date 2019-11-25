## Jumpserver Docker-Compose

[Jumpserver docker install](https://docs.jumpserver.org/zh/docs/dockerinstall.html)

```
$ cd jumpserver-docker-compose
$ cat .env
$ docker-compose up
```

build

```
$ cd jumpserver-docker-compose
$ cat .env
$ docker-compose -f docker-compose-build up
```

## 说明

- 默认的 config.yml 不再调用, 如果有特殊需求, 可以自己编译后挂载到容器里面即可
- .env 的变量 用在 docker-compose 里面, 可以自己看下

> 如果自己编译, 可以在 docker-compose 的 environment: 处加入 Version: \$Version , 取代 Dockerfile 的 ARG

## 生成秘钥

环境迁移和更新升级请检查 SECRET_KEY 是否与之前设置一致, 不能随机生成, 否则数据库所有加密的字段均无法解密

```bash
# 生成随机加密秘钥, 勿外泄
$ if [ "$SECRET_KEY" = "" ]; then SECRET_KEY=`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 50`; echo "SECRET_KEY=$SECRET_KEY" >> ~/.bashrc; echo $SECRET_KEY; else echo $SECRET_KEY; fi
$ if [ "$BOOTSTRAP_TOKEN" = "" ]; then BOOTSTRAP_TOKEN=`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 16`; echo "BOOTSTRAP_TOKEN=$BOOTSTRAP_TOKEN" >> ~/.bashrc; echo $BOOTSTRAP_TOKEN; else echo $BOOTSTRAP_TOKEN; fi

# $ docker run --name jms_all -d -p 80:80 -p 2222:2222 -e SECRET_KEY=$SECRET_KEY -e BOOTSTRAP_TOKEN=$BOOTSTRAP_TOKEN jumpserver/jms_all:latest

# macOS 生成随机 key 可以用下面的命令
$ if [ "$SECRET_KEY" = "" ]; then SECRET_KEY=`LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 50`; echo "SECRET_KEY=$SECRET_KEY" >> ~/.bash_profile; echo $SECRET_KEY; else echo $SECRET_KEY; fi
$ if [ "$BOOTSTRAP_TOKEN" = "" ]; then BOOTSTRAP_TOKEN=`LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 16`; echo "BOOTSTRAP_TOKEN=$BOOTSTRAP_TOKEN" >> ~/.bash_profile; echo $BOOTSTRAP_TOKEN; else echo $BOOTSTRAP_TOKEN; fi
```
