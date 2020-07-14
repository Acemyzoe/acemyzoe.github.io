---
title: TCP/IP-Socket、http、websockets
tags: 通信
---

# C/S结构与套接字

[docs](https://docs.python.org/3/library/socketserver.html#module-socketserver)

**服务端socket**

1. 创建socket对象，调用socket构造函数：socket.socket()

2. 将socket绑定到指定地址上，socket.bind()监听，准备好套接字，以便接受链接请求：socket.listen()

3. 等待客户请求一个链接：socket.accept()

4. 处理阶段，服务器与客户端通过send和recv方法通信(传输数据)

5. 传输结束，服务器调用socked的close方法以关闭连接

**客户端socket**

1. 创建一个socket以连接服务器
2. connect方法连接服务器
3. 客户端和服务器通过send和recv方法通信
4. 客户端通过调用socket的close方法关闭连接

```python
import socket
# socket.socket(familly,type)
# AF_INET：IPv4协议
# AF_INET6： IPv6协议
# AF_UNIX：Unix域，用于同一台机器上的进程间通讯
# SOCK_STREAM：面向流的TCP协议
# SOCK_DGRAM： 面向无连接UDP协议

def server():
    # 1、创建服务端的socket对象
    server = socket.socket()
    # 2、绑定一个ip和端口
    server.bind(("127.0.0.1",2333))
    # 3、服务器端一直监听是否有客户端进行连接
    server.listen(5)
    while True:
        # 4、如果有客户端进行连接、则接受客户端的连接
        conn,addr = server.accept() # 返回客户端socket通信对象和客户端的ip
        # 5、客户端与服务端进行通信
        rev_data = conn.recv(1024)
        print('服务端收到客户端发来的消息:%s' % (rev_data.decode('GB2312')))
        # 6、服务端给客户端回消息
        conn.send(b"HTTP/1.1 200 OK 、\r\n\r\n")  #http协议(B/S架构)->浏览器
        show_str = "<h1> 不要回答！！！不要回答！！！不要回答！！！</h1>"
        conn.send(show_str.encode('GB2312'))	# C/S架构
    # 7、关闭socket对象
    conn.close()
          
def client():
    # 1、创建socket通信对象
    clientSocket = socket.socket()
    # 2、使用正确的ip和端口去链接服务器
    clientSocket.connect(("127.0.0.1",2333))
    # 3、客户端与服务器端进行通信
    while True:
        # 给socket服务器发送信息
        send_data = input(">>")
        if not send_data:  # 如果传入空字符会阻塞
            print("connect close..")
            break
        clientSocket.send(send_data.encode('GB2312'))
        # 接收服务器的响应(服务器回复的消息)
        recvData = clientSocket.recv(1024).decode('GB2312')
        print('客户端收到服务器回复的消息:%s' % (recvData))
    # 4、关闭socket对象
    clientSocket.close()
```



# 文件传输

**基于TCP**

- Client打开文件，通过socket发送数据到Server
- Server保存数据到文件



# 多线程

[socketserver](https://docs.python.org/3/library/socketserver.html)

## **ThreadingMixin**

[示例](https://docs.python.org/3/library/socketserver.html#asynchronous-mixins)

```python
# ThreadingMixin 服务器，利用多线程实现异步，支持多用户。
import socketserver
class MyHandler(socketserver.BaseRequestHandler):
    """
    从BaseRequestHander继承，并重写handle方法
    """
    def handle(self):
        while(self):
            try:
                self.data = self.request.recv(2048).strip()  # 接收
                if not self.data:
                    break
                print("receive from (%r):%r" % (self.client_address, self.data))
                self.request.send(self.data.upper())  # 发送
                #self.requset.sendall(data.upper())
                if self.data == 'exit':
                    print('server exit')
                    break
            except ConnectionResetError as e:
                print(e)
                break
def serverplus():
    host, port = "127.0.0.1", 2333
    # server = socketserver.TCPServer((host, port), MyHandler)   # 单线程交互
    server = socketserver.ThreadingTCPServer((host, port), MyHandler)   # 多线程交互
    print("服务器已开启")
    server.serve_forever()

if __name__ == "__main__":
    serverplus()
```

## 多线程->全双工

将输入与接收分开来，将接收的函数（或方法）从主线程里抓出来丢到另一个线程里单独运行。

```python
import socket
import threading
flag=True
def rec(sock):
    global flag
    while flag:
        t=sock.recv(1024).decode('utf8')
        if t == "exit":
            flag=False
        print(t)

def io(sock):
    '''多线程
    '''
    trd=threading.Thread(target=rec,args=(sock,))
    trd.start()
    global flag
    while flag:
        t=input()
        sock.send(t.encode('utf8'))
        if t == "exit":
            flag=False

def server():
    '''服务端
    '''
    s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.bind(("127.0.0.1",2333))
    s.listen(2)
    sock,addr=s.accept()
    io(sock)
    s.close()

def client():
    '''客户端
    '''
    s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.connect(("127.0.0.1",2333))
    io(s)
    s.close()

if __name__ == "__main__":
    server()
	#client()
```

# WebSocket

- websocket&socket&http

> WebSocket基于 TCP 协议之上的「长连接」协议，在网络七层协议上的层级等同于Http，属应用层协议，是在单个 **TCP 连接**上进行**全双工通讯**的协议。WebSocket常见于**客户端-服务端全双工**的场景，比如聊天，客户端可以发送消息给服务端，同时服务端也可以主动发送消息给客户端。
>
> HTTP 基于 TCP 协议之上的「短连接」应用层协议。Http是单向的，只能客户端发送请求，服务端被动接收，服务端没有主动发起请求的能力，只能维持Http长链接，或者客户端定时轮询服务端，获取最新的信息。
>
> 对于 WebSocket 来说，它必须依赖HTTP 协议进行一次握手，握手成功后，数据就直接从 TCP 通道传输，与 HTTP 无关了。
>
> Socket属于处于七层协议中的第四层，Socket是操作系统对TCP、UDP的封装，便于使用 TCP/UDP 的接口规范、API接口。

- python `pip install websockets`  [docs](https://websockets.readthedocs.io/en/stable/intro.html)

- 异步I/O ` pip install asyncio ` [docs](https://docs.python.org/zh-cn/3/library/asyncio-task.html)

# c# socket

# System.Net.HttpListener

# More

