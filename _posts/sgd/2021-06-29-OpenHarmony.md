---
title: OpenHarmony
tags: sgd
typora-root-url: ../../assets
---

# liteOS移植教程

教程视频发布地址：https://www.100ask.net/all/3927476

移植鸿蒙最小系统：UART、MMU地址映射、定时器中断、存储设备驱动、根文件系统

鸿蒙驱动：LCD、I2C、电容屏、EMMC、网卡等

# OpenHarmony

OpenHarmony官方文档：https://gitee.com/openharmony/docs

同步开发者文档：https://weharmony.github.io/openharmony/

IDE：https://device.harmonyos.com/cn/ide

## 源码获取

### 获取方式1：从代码仓库获取

#### 适用场景

- 基于HarmonyOS的稳定分支建立自己的基线，分发下游客户。
- 已经完成自身软件与HarmonyOS的对接，需要进行HarmonyOS官方认证。
- 芯片/模组/app通过HarmonyOS官方认证后，贡献代码到HarmonyOS社区。
- 修复HarmonyOS的问题。
- 学习HarmonyOS的源码。

### 获取方式2：从HPM获取

提供示例解决方案

## 编译环境

**获取轻量/小型/标准系统（2.0 Canary）源码**

> ```
> repo init -u https://gitee.com/openharmony/manifest.git -b master --no-repo-verify
> repo sync -c
> repo forall -c 'git lfs pull'
> ```

### 方式一：Docker方式准备Ubuntu编译环境

具体Docker环境的安装和使用请参考[Docker环境安装使用指导](https://weharmony.github.io/openharmony/zh-cn/device-dev/get-code/获取工具.html)。

1. 获取Docker镜像

```text
docker pull swr.cn-south-1.myhuaweicloud.com/openharmony-docker/openharmony-docker-standard:0.0.1
```

2. 进入OpenHarmony代码根目录执行如下命令，从而进入Docker构建环境

```text
docker run -it -v $(pwd):/home/openharmony swr.cn-south-1.myhuaweicloud.com/openharmony-docker/openharmony-docker-standard:0.0.1
```

#### 编译源码-标准系统类设备（参考内存≥128MB）

1. 在源码的根目录执行预处理脚本。

```text
../scripts/prepare.sh
```

2. 通过如下编译脚本启动标准系统类设备（参考内存≥128MB）的编译。

```text
./build.sh --product-name {product_name}
```

{product_name}为当前版本支持的平台。比如：Hi3516DV300等。 编译所生成的文件都归档在out/ohos-arm-release/目录下，结果镜像输出在 out/ohos-arm-release/packages/phone/images/ 目录下。

### 方式二：安装包方式准备Ubuntu编译环境3

#### 安装依赖工具

安装命令如下：

```text
sudo apt-get install binutils git-core git-lfs gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip m4 
```

#### 获取prebuilts

在源码根目录下执行脚本:

```text
build/prebuilts_download.sh
```

## Linux内核

面向标准系统类设备（参考内存≥128MB），OpenHarmony选择Linux内核作为基础内核。支持内核版本4.19LTS。

## Linux内核编译与构建指导

### 场景1：版本级编译原生方式

使用工程的全量编译命令，编译生成uImage内核镜像

```shell
./build.sh --product-name Hi3516DV300 # 编译hi3516dv300的uImage内核镜像
#编译结果
...
[12759/12761] STAMP obj/build/ohos/packages/phone_install_modules.stamp
[12760/12761] STAMP obj/build/ohos/packages/make_packages.stamp
[12761/12761] STAMP obj/build/core/gn/packages.stamp
used: 4142 seconds
pycache statistics
manage pycache contents
pycache daemon exit
c targets overlap rate statistics
subsystem       	files NO.	percentage	builds NO.	percentage	overlap rate
third_party     	    4576	60.9%	    4737	61.7%	1.04
aafwk           	     107	1.4%	     107	1.4%	1.00
account         	      13	0.2%	      13	0.2%	1.00
ace             	     765	10.2%	     765	10.0%	1.00
appexecfwk      	     234	3.1%	     234	3.1%	1.00
communication   	     322	4.3%	     322	4.2%	1.00
developtools    	      65	0.9%	      65	0.8%	1.00
distributeddatamgr	     267	3.6%	     267	3.5%	1.00
distributedschedule	      27	0.4%	      27	0.4%	1.00
global          	      17	0.2%	      17	0.2%	1.00
graphic         	      33	0.4%	      33	0.4%	1.00
hdf             	      43	0.6%	      43	0.6%	1.00
hiviewdfx       	      98	1.3%	      98	1.3%	1.00
miscservices    	       5	0.1%	       5	0.1%	1.00
multimedia      	      38	0.5%	      38	0.5%	1.00
multimodalinput 	      29	0.4%	      29	0.4%	1.00
notification    	      37	0.5%	      37	0.5%	1.00
powermgr        	      48	0.6%	      48	0.6%	1.00
security        	     169	2.3%	     169	2.2%	1.00
startup         	      26	0.3%	      26	0.3%	1.00
telephony       	     200	2.7%	     200	2.6%	1.00
updater         	      85	1.1%	      85	1.1%	1.00
utils           	     211	2.8%	     211	2.8%	1.00
wpa_supplicant-2.9	     103	1.4%	     103	1.3%	1.00

c overall build overlap rate: 1.02

post_process
build_target=''
~/Desktop/异常识别与负荷预测项目/harmonyOS/out/ohos-arm-release/packages/phone/images/root ~/Desktop/异常识别与负荷预测项目/harmonyOS
~/Desktop/异常识别与负荷预测项目/harmonyOS
  build vendor image successful.
  build system image successful.
  build userdata image successful.
ohos_build_out_dir = /home/ace/Desktop/异常识别与负荷预测项目/harmonyOS/out/ohos-arm-release/packages/phone
  build updater image successful.
=====build Hi3516DV300 successful.
2021-07-01 18:55:59
++++++++++++++++++++++++++++++++++++++++
```

![image-20210702110633943](2021-06-29-OpenHarmony.assets/image-20210702110633943.png)

### 场景2：单独编译修改后的内核(文档不全)

1. 准备工作

   1. 按开发板Patch使用指导打入所需补丁：

      Patch文件位于工程项目源码路径：kernel/linux/patches/linux-4.19，存放特定芯片架构驱动补丁。

      如需使用特定芯片平台驱动的Patch，需要在**内核仓代码完成对芯片平台驱动补丁合入**。

      合入芯片平台驱动补丁，针对不同芯片平台合入对应的patch：

      **以Hi3516dv300为例,在OpenHarmony的版本级编译构建流程中会拷贝kernel/linux-4.19的代码环境后进行打补丁动作：**

      ```
      patch -p1 < device/hisilicon/hi3516dv300/sdk_linux/open_source/linux/hisi_linux-4.19_hos_l2.patch
      ```

   2. 准备编译环境，可以使用开源arm clang/gcc编译器。

进入工程主目录配置环境变量：


```text
export PATH=`pwd`/prebuilts/clang/host/linux-x86/clang-r353983c/bin:`pwd`/prebuilts/gcc/linux-x86/arm/gcc-linaro-7.5.0-arm-linux-gnueabi/bin/:$PATH # 配置编译环境
MAKE_OPTIONES="ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- CC=clang HOSTCC=clang" # 使用工程项目自带的clang环境
```

2. 修改内核代码或内核config （OpenHarmony提供对应平台的defconfig供参考）。

   直接进入整编过的内核目录out/KERNEL_OBJ/kernel/src_tmp/linux-4.19下修改内核代码或config （OpenHarmony提供对应平台的defconfig供参考）。

   **路径：out/KERNEL_OBJ/kernel/src_tmp/linux-4.19/arch/arm/configs**

3. 创建编译目录及生成内核.config。

   ```text
   make ${MAKE_OPTIONES} hi3516dv300_emmc_smp_hos_l2_defconfig # 使用自带的默认config 构建内核
   ```

4. 编译生成对应的内核Image。

   ```text
   make ${MAKE_OPTIONES} -j32 uImage # 编译uImage内核镜像
   ```

## 烧录

HUAWEI DevEco Device Tool（以下简称DevEco Device Tool）是HarmonyOS面向智能设备开发者提供的一站式集成开发环境，支持HarmonyOS的组件按需定制，支持代码编辑、编译、烧录和调试等功能，支持C/C++语言，以插件的形式部署在Visual Studio Code上。

Hi3516系列开发板中，只有Hi3516DV300支持烧录标准系统，其烧录方式包括USB烧录、网口烧录和串口烧录三种方式。

> [Hi3516DV300烧录指导](https://device.harmonyos.com/cn/docs/ide/user-guides/hi3516_upload-0000001052148681)。

当前已支持的开发板：海思Hi3516系列、Hi3518系列、Hi3861系列开发板的烧录，此次2.0 Beta1新增搭载 NXP IMX6ULL、Realtek RTL8720、Xradio XR872等

![image-20210702110351318](2021-06-29-OpenHarmony.assets/image-20210702110351318.png)

V2.2 Beta1新增支持Neptune（w800芯片）开发板、BearPi-HM Nano（Hi3861芯片）、Rtl8720开发板、基于BL602芯片模组、基于Asr582x芯片模组

## 移植

移植文档https://weharmony.github.io/openharmony/zh-cn/device-dev/porting/%E7%A7%BB%E6%A4%8D%E9%A1%BB%E7%9F%A5.html

典型的芯片架构例如cortex-m系列、risc-v系列等都可以按照本文进行移植，暂时不支持蓝牙服务。

### OpenHarmony三方芯片移植主要过程

![img](https://weharmony.github.io/assets/img/芯片移植关键步骤.26d507ba.png)

### 编译构建适配流程

https://weharmony.github.io/openharmony/zh-cn/device-dev/porting/%E7%BC%96%E8%AF%91%E6%9E%84%E5%BB%BA%E9%80%82%E9%85%8D%E6%B5%81%E7%A8%8B.html

