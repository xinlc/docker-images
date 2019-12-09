YApi Docker镜像
==============


YApi:  https://github.com/YMFE/yapi/releases

制作本地的yapi docker镜像。


## 一键启动


初始化并启动
```
git clone https://github.com/Ryan-Miao/docker-yapi.git
cd docker-yapi
bash build.sh 1.5.10
bash start.sh  init-network
bash start.sh start-mongo
bash start.sh init-mongo
bash start.sh init-yapi
bash start.sh logs-yapi
```

停止yapi和mongo
```
bash start.sh stop
```

再次启动
```
bash start.sh start-mongo
bash start.sh start-yapi
```


ps. 关于启动失败等问题，由于启动脚本没有考虑失败情况，如果某一步失败了，会导致后续步骤无法成功。比如连接mongodb失败，检查发现没有启动mongo。所以，本项目其实只是一个构建指南，参照源码很容易发现问题的。

## 具体步骤


### Step1: run mongodb


create network
```
docker network create --subnet=172.18.0.0/16 tools-net
```

run mongodb
```
docker run  \
--name mongod \
-p 27017:27017  \
-v /data/opt/mongodb/data/configdb:/data/configdb/ \
-v /data/opt/mongodb/data/db/:/data/db/ \
--net tools-net --ip 172.18.0.2 \
-d mongo:4 --auth 
```

set admin
```
docker exec -it mongod mongo admin
 
 >db.createUser({ user: 'admin', pwd: 'admin123456', roles: [ { role: "root", db: "admin" } ] });
```

set yapi
```
db.auth("admin", "admin123456")
 db.createUser({ 
 user: 'yapi', 
 pwd: 'yapi123456', 
 roles: [ 
 { role: "dbAdmin", db: "yapi" },
 { role: "readWrite", db: "yapi" } 
 ] 
     
 });
```


### Step2 Build docker image

Edit config.json to change adminAccount

Then
```
sh build.sh 1.5.10
```


### Step3: run yapi and init

start with db initializtion

```
 docker run -d -p 3001:3001 --name yapi --net tools-net --ip 172.18.0.3 yapi --initdb
```

or just run 
```
docker run -d -p 3001:3001 --name yapi --net tools-net --ip 172.18.0.3 yapi 
```


### Step4: chek

```
 docker logs --tail 10 yapi
log: mongodb load success...
初始化管理员账号成功,账号名："ryan.miao@demo.com"，密码："ymfe.org"
log: 服务已启动，请打开下面链接访问: 
http://127.0.0.1:3001/
log: mongodb load success...
```

完整部署过程： https://www.cnblogs.com/woshimrf/p/docker-install-yapi.html


