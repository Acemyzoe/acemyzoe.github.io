---
title: Bytes & String
tags: 通信
---


通信控制协议文档里面的命令是十六进制的bytes类型。用python生成指令时我用了字符串和bytes拼接，例如，给出一个指令：02(bytes)

b'\x02'(bytes)

接收端直接显示了十六进制的字符串：02(str)

涉及python标准库的内置类型(bytes、str)及binascii。

同时项目以c#为主，又研究了c#的处理数据。

> 16进制编码的bytes数据 <——> 16进制的string数据显示
>
> b'\x5a'	<——>	"5a"

------

> encode : string2bytes
>
> decode : bytes2string

# Pyhon

- Python 3清晰地区分文本和二进制数据。文本总是Unicode，由str类型表示，二进制数据则由bytes类型表示。

- bytes对象只负责以二进制字节序列的形式记录所需记录的对象，至于该对象到底表示什么则由相应的编码格式解码所决定。

- [`bytearray`](https://docs.python.org/zh-cn/3/library/stdtypes.html#bytearray) 对象是 [`bytes`](https://docs.python.org/zh-cn/3/library/stdtypes.html#bytes) 对象的可变对应物。

- **字符串开头r b u f各含义及format：**

  ```python
  # bytes字节符 > b'ha\n'
  print(b'ha\n') 
  # 非转义原生字符，经处理'\n'变成了'\\'和'n'。也就是\n表示的是两个字符，而不是换行 > ha\n
  print(r'ha\n') 
  # unicode编码字符，python3默认字符串编码方式 > ha
  print(u'ha\n') 
  
  # 以f开头表示在字符串内支持大括号内的python表达式 > processing done in 1.00 s
  import time
  t0 = time.time()
  time.sleep(1)
  name = 'processing'
  print(f'{name} done in {time.time() - t0:.2f} s')  
  
  # format 类似于f开头，大括号变量，:定义格式
  coord = (3, 5)
  print('X: {0[0]};  Y: {0[1]}'.format(coord)) # > X: 3;  Y: 5
  print('{:,}'.format(1234567890)) # > 1,234,567,890
  print('answers: {:.2%}'.format(coord[0]/coord[1])) # > answers: 60.00%
  ```

- 二进制序列类型：bytes、bytearray、memoryview[¶](https://docs.python.org/zh-cn/3/library/stdtypes.html#binary-sequence-types-bytes-bytearray-memoryview)

  [bytes](https://docs.python.org/zh-cn/3/library/stdtypes.html#bytes)

  > bytes()函数是python的一个内置函数，用此函数可以创建不可变的（immutable）bytes对象（bytes对象，可以理解为byte string）。
  >
  > 每一个byte的值只能是0到255

  ```python
  print(bytes(range(256))) # 可迭代对象
  # > b'\x00\x01\x02\x03\x04\x05\x06\x07\x08\t\n\x0b\x0c\r\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\x7f\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff'
  print(bytes('哈', 'utf-8').decode()) # 普通string转换到bytes > 哈
  print(bytes(3)) #bytes（int） > b'\x00\x00\x00'
  ```

- binascii--- 二进制和 ASCII 码互转[¶](https://docs.python.org/zh-cn/3/library/binascii.html#module-binascii)

  ```python
  import re
  import binascii
  a ="0201001f10111111012c012c000000000000000201003703e803e8640503e803e8000011110001"
  print(re.sub(r"(?<=\w)(?=(?:\w\w)+$)", " ", a))
  ## > 02 01 00 1f 10 11 11 11 01 2c 01 2c 00 00 00 00 00 00 00 02 01 00 37 03 e8 03 e8 64 05 03 e8 03 e8 00 00 11 11 00 01
  
  b=b'\x02\x01\x00\x1f\x10\x11\x11\x11\x01,\x01,\x00\x00\x00\x00\x00\x00\x00\x02\x01\x007\x03\xe8\x03\xe8d\x05\x03\xe8\x03\xe8\x00\x00\x11\x11\x00\x01'
  print("返回二进制数据 data 的十六进制表示形式:",binascii.hexlify(b,' ') , type(binascii.hexlify(b)))
  ## >  b'02 01 00 1f 10 11 11 11 01 2c 01 2c 00 00 00 00 00 00 00 02 01 00 37 03 e8 03 e8 64 05 03 e8 03 e8 00 00 11 11 00 01' <class 'bytes'>
  
  print("解码成字符串：",binascii.hexlify(b,' ').decode() , type(binascii.hexlify(b).decode()))
  ## >  02 01 00 1f 10 11 11 11 01 2c 01 2c 00 00 00 00 00 00 00 02 01 00 37 03 e8 03 e8 64 05 03 e8 03 e8 00 00 11 11 00 01 <class 'str'>
  
  print("返回一个字符串对象，该对象包含实例中每个字节的两个十六进制数字：",b.hex(' '),type(b.hex()))
  ## >  02 01 00 1f 10 11 11 11 01 2c 01 2c 00 00 00 00 00 00 00 02 01 00 37 03 e8 03 e8 64 05 03 e8 03 e8 00 00 11 11 00 01 <class 'str'>
  
  data=b.hex()
  print("返回由十六进制字符串 hexstr 表示的二进制数据:",binascii.unhexlify(data.rstrip('\r\n')))
  ## >  b'\x02\x01\x00\x1f\x10\x11\x11\x11\x01,\x01,\x00\x00\x00\x00\x00\x00\x00\x02\x01\x007\x03\xe8\x03\xe8d\x05\x03\xe8\x03\xe8\x00\x00\x11\x11\x00\x01'
  
  print("此 bytes 类方法返回一个解码给定字符串的 bytes 对象：", bytes.fromhex(data) , type(bytes.fromhex(data)))
  ## >  b'\x02\x01\x00\x1f\x10\x11\x11\x11\x01,\x01,\x00\x00\x00\x00\x00\x00\x00\x02\x01\x007\x03\xe8\x03\xe8d\x05\x03\xe8\x03\xe8\x00\x00\x11\x11\x00\x01' <class 'bytes'>
  ```

  

# C#

与硬件交互数据的步骤：

1. 获得原始数据data，一般为字符串表示形式。

2. 通过Encoding.ASCII.GetBytes(data)函数将原始数据转换为ASCII码表示形式data2。

3. 为提高存储效率，可以通过将data2进一步转换为16进制表示形式data3。

4. 将data3存入硬件。
```c#
////byte[]初始化赋值
byte[] myByteArray = new byte[10]; //创建一个长度为10的byte数组，每个byte的值为0
byte[] myByteArray = Enumerable.Repeat((byte)0x08, 10).ToArray(); //创建一个长度为10的byte数组，每个byte的值为0x08
byte[] bytes = new byte[] { 0xfc, 0x5a }; //直接赋值
////ascii编码
string str = Encoding.ASCII.GetString(bytes);
Console.WriteLine(str); // > ?Z
////byte[] -> string
string hexs = BitConverter.ToString(bytes);
hexs=hexs.Replace("-", "");
Console.WriteLine(hexs); // > FC5A
////进制转换
int d = 10;
Console.WriteLine("十进制转二进制字符串:{0}",Convert.ToString(d, 2)); // > 1010
Console.WriteLine("十进制转十六进制字符串:{0}", Convert.ToString(d, 16)); // > a
string bin = "1010";
Console.WriteLine("二进制字符串转十进制数:{0}", Convert.ToInt32(bin, 2)); // > 10
Console.WriteLine(string.Format("二进制字符串转十六进制数:{0:x}", Convert.ToInt32(bin, 2))); // > a
Console.WriteLine("十六进制转二进制字符串:{0}", Convert.ToString(0xa, 2)); // > 1010
Console.WriteLine("十六进制转十进制数:{0}", Convert.ToString(0xa, 10)); // > 10
////string -> bytes[]
// https://stackoverflow.com/questions/321370/how-can-i-convert-a-hex-string-to-a-byte-array
//string hex = "02 01 00 1f 10 11 11 11 01 2c 01 2c 00 00 00 00 00 00 00 02 01 00 37 03 e8 03 e8 64 05 03 e8 03 e8 00 00 11 11 00 01";
string hex = "0201001F10111111006E00C8000000000000000201003703E803E8640503E803E8000011110001";
//hex = hex.Replace(" ", "");
//way1
static byte[] StringToByteArray(string hex)
{
    return Enumerable.Range(0, hex.Length)
                        .Where(x => x % 2 == 0)
                        .Select(x => Convert.ToByte(hex.Substring(x, 2), 16))
                        .ToArray();
}
byte[] cmd1 = StringToByteArray(hex); //LINQ示例
//way2
static byte[] StringToByteArray2(string hex)
{
    int NumberChars = hex.Length;
    byte[] bytes = new byte[NumberChars / 2];
    for (int i = 0; i < NumberChars; i += 2)
        bytes[i / 2] = Convert.ToByte(hex.Substring(i, 2), 16);
    return bytes;
}
byte[] cmd2 = StringToByteArray2(hex); //
//way3
static byte[] StrToByteArray3(string str)
{
    Dictionary<string, byte> hexindex = new Dictionary<string, byte>();
    for (int i = 0; i <= 255; i++)
        hexindex.Add(i.ToString("X2"), (byte)i);

    List<byte> hexres = new List<byte>();
    for (int i = 0; i < str.Length; i += 2)
        hexres.Add(hexindex[str.Substring(i, 2)]);

    return hexres.ToArray();
}
byte[] cmd3 = StrToByteArray3(hex);
//显示
Console.WriteLine("转成十六进制字符串：");
Console.WriteLine(BitConverter.ToString(cmd1));
Console.WriteLine(BitConverter.ToString(cmd2));
Console.WriteLine(BitConverter.ToString(cmd3));
```
