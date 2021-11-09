---
title: CMakeLists
tags:
  - wiki
---

# CMakeLists 

```cmake
# 指定 cmake 的最小版本
cmake_minimum_required(VERSION 3.4.1)

# 设置项目名称
project(demo)

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

# 搜索当前目录下的所有.cpp文件，并命名为SRC_LIST，它会查找目录下的.c,.cpp ,.mm,.cc 等等C/C++语言后缀的文件名
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
```

