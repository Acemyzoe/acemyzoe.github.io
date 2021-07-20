---
title: 部署arm终端
tags:
  - wiki
---

# Python -> 可执行 -> arm架构设备

# 拓扑识别程序终端部署

## 基本情况

- 硬件：能源控制器开发板

- 系统：Ubuntu 16.04.1 LTS (GNU/Linux 3.10.108 armv7l)


# 方案一

容器镜像：arm32v7pandas：tepo

> 说明：该镜像适用于arm32v7架构设备，内含python3.7版本，内置numpy、pandas等所需python库。后续可添加AI相关库，应用于窃电识别、负荷预测等以python为基础开发的项目。

不足：经过精简后大小达600MB，后续添加其他库大小会继续增加。

![图片1](/home/ace/Desktop/github/acemyzoe.github.io/_posts/wiki/2021-06-28-python部署至arm终端.assets/图片1.png)


## 运行情况

在容器中运行：`python tepo_level2_copy.cpython-37.pyc --path data.csv`

![图片2](/home/ace/Desktop/github/acemyzoe.github.io/_posts/wiki/2021-06-28-python部署至arm终端.assets/图片2.png)

结果：在原路径生成data_tepo2文件（节点的邻接表）、data_tepo2.png（节点拓扑图）

![图片3](/home/ace/Desktop/github/acemyzoe.github.io/_posts/wiki/2021-06-28-python部署至arm终端.assets/图片3.png)


## 资源消耗

程序耗时20-30s，具体取决于计算数据量。

（笔记本测试耗时4-5s，由于开发板CPU算力有限，耗时翻倍）

![图片4](/home/ace/Desktop/github/acemyzoe.github.io/_posts/wiki/2021-06-28-python部署至arm终端.assets/图片4.png)


## 测试AI程序

模型文件：model.lite ( 用于mnist手写数字识别的神经网络模型文件,build by tensorflow-lite )

测试程序：minimal（基于TF-lite框架，使用c语言交叉编译的示例程序，用于检测模型内部参数。）

![图片5](/home/ace/Desktop/github/acemyzoe.github.io/_posts/wiki/2021-06-28-python部署至arm终端.assets/图片5.png)

# 方案二

**容器镜像**：arm32v7/python：3.7slim

> 说明：该镜像适用于arm32v7架构设备，内含python3.7版本，为了压缩大小不含其他python库。大小为**87.2MB**。

**程序**：经pyinstaller或者nuitka打包后的可执行文件。源程序约为**275MB**。

**程序说明**：`docker run --rm=true -v $PWD:/work -w /work arm32v7/python:3.7-slim ./tepobypyinstaller/tepo_level2_copy -h`

```shell
usage: tepo_level2_copy [-h] [--path PATH]
optional arguments:
	 -h, --help  show this help message and exit
	 --path PATH  data path , for example: ./tepo.py --path data.csv
```

![图片6](/home/ace/Desktop/github/acemyzoe.github.io/_posts/wiki/2021-06-28-python部署至arm终端.assets/图片6.png)


## **使用说明**

- 运行一个一次性使用的容器跑程序 **./tepobypyinstaller/tepo_level2_copy为程序路径，--path参数选择文件**。

```bash
docker run --rm=true -v $PWD:/work -w /work arm32v7/python:3.7-slim ./tepobypyinstaller/tepo_level2_copy --path data.csv
```

-  或者开启一个常驻容器

```bash
docker run -tid --name=tepo-container -v $PWD:/work -w /work arm32v7/python:3.7-slim bash

docker exec -ti tepo-container ./tepobypyinstaller/tepo_level2_copy -h  
docker exec -tid tepo-container ./tepobypyinstaller/tepo_level2_copy --path data.csv
```

![图片7](/home/ace/Desktop/github/acemyzoe.github.io/_posts/wiki/2021-06-28-python部署至arm终端.assets/图片7.png)

### build.sh

```sh
echo '>>>>>>导入容器镜像arm32v7-python.tar.xz'
docker load -i armpython.tar.xz
docker images

echo '>>>>>>tepo_lv2为打包后的拓扑识别程序（lv2即识别二级节点）'

echo '>>>>>>开启容器tepo-container'
docker run -tid --name=tepo-container -v $PWD:/work -w /work arm32v7/python:3.7-slim bash
docker ps -a

echo '>>>>>>帮助信息'
chmod 777 ./tepo_lv2/tepo_lv2
docker exec -ti tepo-container ./tepo_lv2/tepo_lv2 -h 
echo '>>>>>>运行程序，需要识别数据为data.csv'
docker exec -tid tepo-container ./tepo_lv2/tepo_lv2 --path data.csv

echo '>>>>>>文件data_tepo_lv2即为识别的节点邻接表'
```

