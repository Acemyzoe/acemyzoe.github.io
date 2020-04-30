---
title: Docker & GPU-server
tags: 
 - wiki

---

## GPU-server

<iframe src="https://ghbtns.com/github-btn.html?user=acemyzoe&repo=gpu-server&type=star&size=large" frameborder="0" scrolling="0" width="220" height="30" title="Star acemyzoe/gpu-server on GitHub"></iframe>

<iframe src="https://ghbtns.com/github-btn.html?user=acemyzoe&type=follow&size=large" frameborder="0" scrolling="0" width="2200" height="30" title="Follow @acemyzoe on GitHub"></iframe>

构建GPU服务器的容器技术：[Docker](https://docs.docker.com/)  /  [LXC&LXD](https://linuxcontainers.org/)

远程登陆：SSH(局域网) 

> [Hole](http://wdom.net/) : 使用Holer服务端软件搭建Holer服务，通过Holer客户端软件经自己服务器实现公网访问。

容器管理：DaoCloud - [DCS](https://dashboard.daocloud.io/)(可从公网访问管理多主机)

> [DCD](http://guide.daocloud.io/dcd/%E7%AE%80%E4%BB%8B-13044181.html) : 开发者版，[本地管理](http://localhost/#/)
>
> [Portainer](https://www.portainer.io/) : docker管理功能更全，支持创建container，但好像只支持[本地管理](http://loaclhost:9000/#/home)

------

## Docker

容器的本质是进程。

### [安装](https://docs.docker.com/engine/install/linux-postinstall/)

```bash
#安装docker，借助第三方不香么
curl -sSL https://get.daocloud.io/docker | sh 
#安装nvidia-docker : https://github.com/NVIDIA/nvidia-docker
# Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker

#非root用户身份管理
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 
#配置docker自启动
sudo systemctl enable docker
```

### 命令

[了解更多](https://www.runoob.com/docker/docker-command-manual.html)

```bash
#info
docker info
###################
#从dockerfile构建image
docker build -t <name>:<tag> dockerfile_path
#从container构建image
docker commit container <images-name>:<tag>
#拉取镜像
docker pull tensorflow：latest
#查看image
docker images
#导出镜像
docker save -o <name>.tar.gz <image-name>
docekr export <name>.tar.gz <image-name>
#导入镜像
docker import <name>.tar.gz 
docker iload <name>.tar.gz 
####################
#创建container
docker run -ti \
                        --gpus all \
                        -p 6000:22 \
                        --name <name> \
                        -v server_dir : container_dir :ro \
                        <image>
                        bash
#查看container
docker ps -a
#进入container ,attach可以带上--sig-proxy=false来确保CTRL-D或CTRL-C不会关闭容器
 docker attach <container-name>
#在运行的容器中执行命令。-d 后台运行；-i 保持STDIN打开；-t 分配伪终端
docker exec -ti <container-name>
 #查看容器中运行的进程信息
 docker top <container-name>
 #查看端口映射
 docker port <contain-name>
 #容器与主机之间的数据拷贝
 docker cp container:path host-path
```

------

## LXD

中道崩殂

可参考文章：

- https://github.com/shenuiuin/LXD_GPU_SERVER
- https://shenxiaohai.me/2018/12/03/gpu-server-lab/
- https://butui.me/post/lxd-gpu-server/
- https://abcdabcd987.com/setup-shared-gpu-server-for-labs/

