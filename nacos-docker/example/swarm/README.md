
# 部署到 Swarm

```bash
# 部署
docker stack deploy -c docker-compose.yml nacos-test

# 删除
docker stack rm nacos-test

# 开放端口
firewall-cmd --zone=public --add-port=9948/tcp --permanent
firewall-cmd --reload
```
