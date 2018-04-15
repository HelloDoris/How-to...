### tmpfs mounts：
##### 使用情景：
- 不需要在主机或容器中存储数据，当产生大量临时数据时，可以保证容器运行的性能
##### 用法：
service只能用`--mount`，建议全用`--mount`, `tmpfs-mode`代表权限
```bash
(--tmpfs)docker run -d --name httpd1 -p 8881:80 --tmpfs /htdocs httpd
(--mount)docker run -d --name httpd2 -p 8882:80 --mount type=tmpfs,target=/htdocs httpd-vim:1.0
(--mount)docker run -d --name httpd3 -p 8883:80 --mount type=tmpfs,target=/htdocs,tmpfs-mode=1770 httpd-vim:1.0
```

### bind mount:
##### 使用情景：
- 将本机文件与docker容器共享(例如配置文件xxx.conf)
- 在docker host的开发环境和容器之间共享代码或结构(这一点可通过dockerfile事先把所需文件打包到镜像)
- 当docker host的文件(结构)需要与容器需要的bind mounts保持一致
##### 用法：
使用关键字 `-v/--volume` 和 `--mount`
例：假设本机有文件如下`V:\bindtest\index.html`
运行`httpdc(container of httpd)`，有`htdocs/index.html`
```bash
(--volume)docker run -d --name httpd1 -p 8881:80 -v V:\bindtest\index.html:htdocs:ro httpd
(--mount) docker run -d --name httpd2 -p 8882:80 --mount type=bind,sourse=V:\bindtest\index.html,terget=htdocs/index.html,readonly httpd
```
`PS`:source可以是目录或文件，但一定得存在，target可以不存在，若已存在会被覆盖（参见copy-on-write）特性

### volumes:
##### 使用情景：
- 在多个容器之间共享数据，若没有事先创建volume,会在首次启动容器或服务时自动创建volume，不建议使用匿名volume
- 如果docker host不需要保持某种文件结构，则可以通过volume来使docker host和container runtime解耦
- 在远程或者云主机上存储数据（要借用driver）
- 需要在不同的docker host中复制、迁移数据
##### 用法：
除了在service服务中只能使用`--mount`，其他时候 `-v`/`--volume`/`--mount` 三者通用

例：
```bash
docker volume create httpd_vol  (这一步可以省略)
```
   **container:**(读写权限另加)
```bash
docker run -d --name httpd1 -v httpd_vol:/htdocs:ro httpd-vim
docker run -d --name httpd2 -mount type=volume,source=httpd_vol,target=/htdocs,readonly httpd-vim
```
   **service:**
```bash
docker service creaete -d --replicas=4 --name httpd_service --mount source=httpd_vol,target=/htdocs httpd-vim
```
