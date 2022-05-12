---
title: CMakeLists
tags:
  - wiki
---

# CMAKE&MAKE

## CMakeLists 

```cmake
cmake_minimum_required(VERSION 3.5)
project(MAIN VERSION 1.0 LANGUAGES CXX C)
add_library(${PROJECT_NAME} INTERFACE)
target_compile_features(${PROJECT_NAME} INTERFACE cxx_std_11 c_std_99)
include_directories(${PROJECT_SOURCE_DIR}/include)
link_directories(${PROJECT_SOURCE_DIR}/lib)

# build options
option(EXAMPLES "Build examples?" ON)

# Build examples
if(EXAMPLES)
    find_package(Threads REQUIRED)
    add_executable(MQTTClient_subscribe src/MQTTClient_subscribe.c)
    target_link_libraries(MQTTClient_subscribe Threads::Threads paho-mqtt3c)

endif()
```

## Cmake

```cmake
# 指定 cmake 的最小版本
cmake_minimum_required(VERSION 3.4.1)

# 设置项目名称、版本、语言
project(MAIN VERSION 1.0 LANGUAGES CXX C)

# 编译器
target_compile_features(${PROJECT_NAME} INTERFACE cxx_std_11 c_std_99)

# 设置头文件路径
include_directories(${PROJECT_SOURCE_DIR}/include)

# 设置编译类型，add_library 默认生成是静态库
add_executable(demo demo.cpp) # 生成可执行文件
add_library(common STATIC util.cpp) # 生成静态库
add_library(common SHARED util.cpp) # 生成动态库或共享库
'''
在 Linux 下：
        demo
        libcommon.a
        libcommon.so
在 Windows 下：
        demo.exe
        common.lib
        common.dll
'''

# 明确指定包含哪些源文件
add_library(demo demo.cpp test.cpp util.cpp)

# 用于添加一个需要进行构建的子目录，意味着该目录下也有个CMakeLists.txt 文件
add_subdirectory(Lib)

# 设置变量
# set 直接设置变量的值
set(SRC_LIST main.cpp test.cpp)
add_executable(demo ${SRC_LIST})
set(ROOT_DIR ${CMAKE_SOURCE_DIR}) #CMAKE_SOURCE_DIR默认为当前cmakelist.txt目录

# set追加设置变量的值
set(SRC_LIST main.cpp)
set(SRC_LIST ${SRC_LIST} test.cpp)
add_executable(demo ${SRC_LIST})

# list追加或者删除变量的值
set(SRC_LIST main.cpp)
list(APPEND SRC_LIST test.cpp)
list(REMOVE_ITEM SRC_LIST main.cpp)
add_executable(demo ${SRC_LIST})

# 搜索当前目录下的所有源文件，并存在变量SRC_LIST，它会查找目录下的.c,.cpp ,.mm,.cc 等等C/C++语言后缀的文件名
aux_source_directory(. SRC_LIST) 
add_library(demo ${SRC_LIST})

# 自定义搜索规则
aux_source_directory(. SRC_LIST)
aux_source_directory(protocol SRC_PROTOCOL_LIST)
add_library(demo ${SRC_LIST} ${SRC_PROTOCOL_LIST})
# 1
file(GLOB SRC_LIST "*.cpp" "protocol/*.cpp")
add_library(demo ${SRC_LIST})
# 2
file(GLOB SRC_LIST "*.cpp")
file(GLOB SRC_PROTOCOL_LIST "protocol/*.cpp")
add_library(demo ${SRC_LIST} ${SRC_PROTOCOL_LIST})
# 3
file(GLOB_RECURSE SRC_LIST "*.cpp") #递归搜索
FILE(GLOB SRC_PROTOCOL RELATIVE "protocol" "*.cpp") # 相对protocol目录下搜索
add_library(demo ${SRC_LIST} ${SRC_PROTOCOL_LIST})

# 设置包含的目录，头文件目录
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)
# Linux 下还可以通过如下方式设置包含的目录
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I${CMAKE_CURRENT_SOURCE_DIR}")

# 设置链接库搜索目录
link_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/libs
)
# Linux 下还可以通过如下方式设置包含的目录
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -L${CMAKE_CURRENT_SOURCE_DIR}/libs")

# 指定链接动态库或静态库
target_link_libraries(demo libface.a) # 链接libface.a
target_link_libraries(demo libface.so) # 链接libface.so

# 指定全路径
target_link_libraries(demo ${CMAKE_CURRENT_SOURCE_DIR}/libs/libface.a)
target_link_libraries(demo ${CMAKE_CURRENT_SOURCE_DIR}/libs/libface.so)

# 指定链接多个库
target_link_libraries(demo
    ${CMAKE_CURRENT_SOURCE_DIR}/libs/libface.a
    boost_system.a
    boost_thread
    pthread)
    
 # 获取整个依赖包的头文件包含路径、库路径、库名字、版本号等情况
 find_package(OpenCV 3.2.0 REQUIRED )

# 打印信息
message(${PROJECT_SOURCE_DIR})
message("build with debug mode")
message(WARNING "this is warnning message")
message(FATAL_ERROR "this build has many error") # FATAL_ERROR 会导致编译失败

# 包含其它 cmake 文件
include(./common.cmake) # 指定包含文件的全路径
include(def) # 在搜索路径中搜索def.cmake文件
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake) # 设置include的搜索路径

# if…elseif…else…endif 逻辑判断和比较：
if (expression)：#expression 不为空（0,N,NO,OFF,FALSE,NOTFOUND）时为真
if (not exp)：#与上面相反
if (var1 AND var2)
if (var1 OR var2)
if (COMMAND cmd)：#如果 cmd 确实是命令并可调用为真
if (EXISTS dir) if (EXISTS file)：#如果目录或文件存在为真
if (file1 IS_NEWER_THAN file2)：#当 file1 比 file2 新，或 file1/file2 中有一个不存在时为真，文件名需使用全路径
if (IS_DIRECTORY dir)：#当 dir 是目录时为真
if (DEFINED var)：#如果变量被定义为真
if (var MATCHES regex)：#给定的变量或者字符串能够匹配正则表达式 regex 时为真，此处 var 可以用 var 名，也可以用 ${var}
if (string MATCHES regex)

# 数字比较：
if (variable LESS number)：#LESS 小于
if (string LESS number)
if (variable GREATER number)：#GREATER 大于
if (string GREATER number)
if (variable EQUAL number)：#EQUAL 等于
if (string EQUAL number)

# 字母表顺序比较：
if (variable STRLESS string)
if (string STRLESS string)
if (variable STRGREATER string)
if (string STRGREATER string)
if (variable STREQUAL string)
if (string STREQUAL string)

# foreach…endforeach
foreach(i RANGE 1 9 2)
    message(${i})
endforeach(i)
# 输出：13579

# 预定义变量
PROJECT_SOURCE_DIR：#工程的根目录
PROJECT_BINARY_DIR：#运行 cmake 命令的目录，通常是 ${PROJECT_SOURCE_DIR}/build
PROJECT_NAME：#返回通过 project 命令定义的项目名称
CMAKE_CURRENT_SOURCE_DIR：#当前处理的 CMakeLists.txt 所在的路径
CMAKE_CURRENT_BINARY_DIR：#target 编译目录
CMAKE_CURRENT_LIST_DIR：#CMakeLists.txt 的完整路径
CMAKE_CURRENT_LIST_LINE：#当前所在的行
CMAKE_MODULE_PATH：#定义自己的 cmake 模块所在的路径，SET(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)，然后可以用INCLUDE命令来调用自己的模块
EXECUTABLE_OUTPUT_PATH：#重新定义目标二进制可执行文件的存放位置
LIBRARY_OUTPUT_PATH：#重新定义目标链接库文件的存放位置

# 环境变量
$ENV{Name}
set(ENV{Name} value) # 这里没有“$”符号

# 系统信息
CMAKE_MAJOR_VERSION：#cmake 主版本号，比如 3.4.1 中的 3
CMAKE_MINOR_VERSION：#cmake 次版本号，比如 3.4.1 中的 4
CMAKE_PATCH_VERSION：#cmake 补丁等级，比如 3.4.1 中的 1
CMAKE_SYSTEM：#系统名称，比如 Linux-­2.6.22
CMAKE_SYSTEM_NAME：#不包含版本的系统名，比如 Linux
CMAKE_SYSTEM_VERSION：#系统版本，比如 2.6.22
CMAKE_SYSTEM_PROCESSOR：#处理器名称，比如 i686
UNIX：#在所有的类 UNIX 平台下该值为 TRUE，包括 OS X 和 cygwin
WIN32：#在所有的 win32 平台下该值为 TRUE，包括 cygwin

#主要开关选项
BUILD_SHARED_LIBS ：#这个开关用来控制默认的库编译方式，如果不进行设置，使用 add_library 又没有指定库类型的情况下，默认编译生成的库都是静态库。如果 set(BUILD_SHARED_LIBS ON) 后，默认生成的为动态库
CMAKE_C_FLAGS：#设置 C 编译选项，也可以通过指令 add_definitions() 添加
CMAKE_CXX_FLAGS：#设置 C++ 编译选项，也可以通过指令 add_definitions() 添加
add_definitions(-DENABLE_DEBUG -DABC) # 参数之间用空格分隔

CMAKE_BUILD_TYPE #设置模式是Debug还是Release模式
SET(CMAKE_BUILD_TYPE "Release")
SET(CMAKE_BUILD_TYPE "Debug”)
```

## gcc/g++

```gcc
gcc中常用的编译选项
-c 只编译并生成目标文件：将汇编代码编译成.o目标文件，即二进制代码。直接把 C/C++ 代码编译成机器代码。
-g 生成调试信息。GNU 调试器可利用该信息。
-S 只是编译不汇编，生成汇编代码
-shared 生成共享目标文件。通常用在建立共享库时。
-W 开启所有 gcc 能提供的警告。 
-w 不生成任何警告信息。 
-Wall 生成所有警告信息。

-O0 -O1 -O2 -O3 四级优化选项：
-O0 不做任何优化，这是默认的编译选项 。
-O 或 -O1 优化生成代码，优化会消耗编译时间，主要对代码的分支，常量以及表达式等进行优化。
-O2 进一步优化，会尝试更多的寄存器级的优化以及指令级的优化，在编译期间占用更多的内存和编译时间 。
-Os 相当于-O2.5。是使用了所有-O2的优化选项，但又不缩减代码尺寸的方法。
-O3 比 -O2 更进一步优化，包括 inline 函数。在O2的基础上进行更多的优化。 
```

```shell
# ar 命令将.o文件打包成静态链接库
ar rcs libdemo.a demo.o # ar rcs + 静态库文件的名字 + 目标文件列表
# 参数 r 用来替换库中已有的目标文件，或者加入新的目标文件。
# 参数 c 表示创建一个库。不管库否存在，都将创建。　
# 参数 s 用来创建目标文件索引，这在创建较大的库时能提高速度。

# -I选项指明头文件的包含路径，使用-L选项指明静态库的包含路径，使用-l（小写字母L）选项指明静态库的名字
gcc src/main.c -I include/ -L lib/ -l test -o math.out

# 直接编译
g++ main.cpp function.cpp function.h -o main.out
# function静态库
g++ -c function.cpp 
ar cr libfunction.a function.o 
g++ main.cpp -o main.out -static -l function -L include/
# function动态库
g++ -shared -fPIC -o libfunction.so function.o  
sudo cp libfunction.so /usr/lib
g++ main.cpp -L include/ -l function -o main.out
```

## make

```make
make all：编译程序、库、文档等（等同于make）
make install：安装已经编译好的程序。复制文件树中到文件到指定的位置
make unistall：卸载已经安装的程序。
make clean：删除由make命令产生的文件
make distclean：删除由./configure产生的文件
make check：测试刚刚编译的软件（某些程序可能不支持）
make installcheck：检查安装的库和程序（某些程序可能不支持）
make dist：重新打包成packname-version.tar.gz
```

```makefile
# Makefile
# source object target
SRC	:= $(wildcard *.cpp)  # wildcard作用找到所有的.cpp文件
OBJS	:=	$(SRC: %.cpp=%.o)  #通过变量的替换操作，可得到对应的.o文件列表
TARGET	:= output_without_lib_makefile  # 最后生成的可执行文件的名字
# compile and lib parameter
CC		:= g++
LDFLAGS := -L lib/
INCLUDE := -I include/
all:
	$(CC) -o $(TARGET) $(SRC)
# clean
clean:
	rm -fr *.o
	rm -fr $(TARGET)
```

```makefile
# Makefile生成静态库并编译
# source object target
SRC	:= $(wildcard *.cpp)
OBJS	:=	$(SRC: %.cpp=%.o)
LIB	:= libfunction_makefile.a 
AR	:= ar
# compile and lib parameter
CC		:= g++
INCLUDE := -I.
#link
$(LIB):function.o
	$(AR) -r $@ -o $^
function.o:function.cpp
	$(CC) -c $^ -o $@
# clean
clean:
	rm -fr *.o
```

```makefile
# Makefile使用静态库
TARGET := output_makefile_a
# compile and lib parameter
CC		:= g++
INCLUDE := -I.
LDFLAGS := -L.
LIBS := libfunction_makefile.a
# link
$(TARGET):main.o
	$(CC) -o $@ $^ $(LIBS)
#compile
main.o:main.cpp
	$(CC) -c $^ -o $@
# clean
clean:
	rm -fr *.o
```

```makefile
# Makefile生成动态库
# compile and lib parameter
CC		:= g++
INCLUDE := -I.
LIBS := libfunction_makefile.so
# link
$(LIBS): function.o
	$(CC) -shared -o $@ $^
function.o:function.cpp
	$(CC) -c $^ -o $@
# clean
clean:
	rm -fr *.o
```

```makefile
# Makefile动态库使用
TARGET := output_makefile_so
# compile and lib parameter
CC		:= g++
INCLUDE := -I.
LIBS    := -lfunction_makefile
# link
$(TARGET): main.o
	$(CC)  $^  -o  $(TARGET) -lfunction_makefile
main.o:main.cpp
	$(CC) -c $^ -o $@
# clean
clean:
	rm -fr *.o
```

