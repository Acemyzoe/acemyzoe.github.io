---
title: arm/python容器
tags:
  - sgd
typora-root-url: ../../assets
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

![图片1](https://raw.githubusercontent.com/Acemyzoe/myblog/master/blog-img/%E5%9B%BE%E7%89%871.png)


## 运行情况

在容器中运行：`python tepo_level2_copy.cpython-37.pyc --path data.csv`

![图片2](https://raw.githubusercontent.com/Acemyzoe/myblog/master/blog-img/%E5%9B%BE%E7%89%872.png)

结果：在原路径生成data_tepo2文件（节点的邻接表）、data_tepo2.png（节点拓扑图）

![图片3](https://raw.githubusercontent.com/Acemyzoe/myblog/master/blog-img/%E5%9B%BE%E7%89%873.png)


## 资源消耗

程序耗时20-30s，具体取决于计算数据量。

（笔记本测试耗时4-5s，由于开发板CPU算力有限，耗时翻倍）

![图片4](https://raw.githubusercontent.com/Acemyzoe/myblog/master/blog-img/%E5%9B%BE%E7%89%874.png)


## 测试AI程序

模型文件：model.lite ( 用于mnist手写数字识别的神经网络模型文件,build by tensorflow-lite )

测试程序：minimal（基于TF-lite框架，使用c语言交叉编译的示例程序，用于检测模型内部参数。）

![图片5](https://raw.githubusercontent.com/Acemyzoe/myblog/master/blog-img/%E5%9B%BE%E7%89%875.png)

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

![图片6](https://raw.githubusercontent.com/Acemyzoe/myblog/master/blog-img/%E5%9B%BE%E7%89%876.png)


## **使用说明**

- 运行一个一次性使用的容器跑程序 **./tepobypyinstaller/tepo_level2_copy为程序路径，--path参数选择文件**。

```bash
docker run --rm=true -v $PWD:/work -w /work arm32v7/python:3.7-slim ./tepo_lv2/tepo_lv2 --path data.csv
```

-  或者开启一个常驻容器

```bash
docker run -tid --name=tepo-container -v $PWD:/work -w /work arm32v7/python:3.7-slim bash

docker exec -ti tepo-container ./tepo_lv2/tepo_lv2 -h  
docker exec -tid tepo-container ./tepo_lv2/tepo_lv2 --path data.csv
```

![图片7](https://raw.githubusercontent.com/Acemyzoe/myblog/master/blog-img/%E5%9B%BE%E7%89%877.png)

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

### run.sh

```bash
#!/usr/bin/env bash 
echo '开启一次性容器运行'
docker run --rm=true -v $PWD:/work -w /work arm32v7/python:3.7-slim ./tepo_lv2/tepo_lv2 -h
docker run --rm=true -v $PWD:/work -w /work arm32v7/python:3.7-slim ./tepo_lv2/tepo_lv2 --path data.csv
```

## 资源消耗

在测试环境的能源控制器上，开启所有能源控制器基础APP，CPU占用率在50%～60%。

通过开启docker运行拓扑识别APP，识别data.csv测试数据，CPU占用增长至80%～90%，计算时间在20s～30s。

# 方案三

问题：由测试同事反馈，能源控制器上规定三个固定容器，上述拓扑识别APP要考虑部署至规定容器中或直接部署在系统上。

解决计划：配置一套与能源控制器一样的编译环境，解决python打包工具无交叉编译的问题。

**程序：**基于unbuntu16.04（glibc2.23)的环境编译程序，可以不使用容器，直接在能源控制器系统上运行。

无需额外特定的容器镜像，只有打包后的源程序，大小在**208.3MB**。

## 问题

### 程序cpu占用率过高

1. 从Linux系统层限制

   1. 使用命令`nice`

      nice 命令用于设定进程的优先级，取值范围[-20,19],-20为最高，19为最低。

      ```bash
      nice -n 19 ./tepo_lv2/tepo_lv2 -h
      ```

   2. 使用程序`cpulimit`

      安装方法：apt 或者源码构建（基于ubuntu16.04构建可用）[cpulimit](https://github.com/opsengine/cpulimit)

      cpulimit 可以为进程设置CPU使用率上限值并实时监控，若超出上限则暂停运行一段时间

      ```bash
      # 使用-l * 限制CPU使用率上限
      # 使用cpulimit的-i参数同时限制其子进程的资源占用：
      cpulimit -i -l 20  ./tepo_lv2/tepo_lv2 -h
      ```

   3. cgroups 命令集

      Linux 内核提供的一种机制，利用它可以指定一组进程的资源分配，不限于CPU。该命令只在多个进程争抢资源时才生效。

      python中的resource库作用类似。

2. 从python代码限制

   1. [resource模块](https://docs.python.org/3.8/library/resource.html)

      该模块提供了用于测量和控制程序使用的系统资源的基本机制。

      `setrlimit()` 函数被用来设置特定资源上面的软限制和硬限制。

   2. pstuil模块

      系统管理运维：监控系统运行的状态

3. python代码性能优化

