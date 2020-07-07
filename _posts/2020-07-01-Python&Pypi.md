---
title: Python-Pypi
tags:
  - python
---





# Some issue

- ```bash
  超时错误提示：pip._vendor.urllib3.exceptions.ReadTimeoutError: HTTPSConnectionPool(host='pypi.tuna.tsinghua.edu.cn', port=443): Read timed out.
  pip  --default-timeout=100 install Pillow
  直接download whl文件
  ```



# 注释规范

- [ ] 获取注释 `function().__doc__`

      [Google 开源项目风格指南(中文版)] (https://zh-google-styleguide.readthedocs.io/en/latest/)



# Dict

- [ ] 字典中如何根据value值取对应的key值

  ```python
  dicxx = {'a':'001', 'b':'002'}
  #1
  list(dicxx.keys())[list(dicxx.values()).index("001")] #=> a
  #2
  def get_keys(d, value):
      return [k for k,v in d.items() if v == value]  
  get_keys(dicxx, '001') # => ['a']
  ```



# 正则表达式

[表达式全集](https://tool.oschina.net/uploads/apidocs/jquery/regexp.html)

- [ ] 十六进制字符串分割

  ```python
  import re
  subject = '080045'
  result = re.sub(r"(?<=\w)(?=(?:\w\w)+$)", " ", subject)
  # => '08 00 45'
  ```

  

# CRC校验

- [ ] crcmod

  [算法参数](http://crcmod.sourceforge.net/crcmod.predefined.html#predefined-crc-algorithms)

  | Name           | Polynomial | Reversed | Init-value | XOR-out | Check  |
  | :------------- | :--------- | :------- | :--------- | :------ | :----- |
  | `crc-8`        | 0x107      | False    | 0x00       | 0x00    | 0xF4   |
  | `crc-8-darc`   | 0x139      | True     | 0x00       | 0x00    | 0x15   |
  | `crc-8-i-code` | 0x11D      | False    | 0xFD       | 0x00    | 0x7E   |
  | `crc-8-itu`    | 0x107      | False    | 0x55       | 0x55    | 0xA1   |
  | `crc-8-maxim`  | 0x131      | True     | 0x00       | 0x00    | 0xA1   |
  | `crc-8-rohc`   | 0x107      | True     | 0xFF       | 0x00    | 0xD0   |
  | `crc-8-wcdma`  | 0x19B      | True     | 0x00       | 0x00    | 0x25   |
  | `crc-16`       | 0x18005    | True     | 0x0000     | 0x0000  | 0xBB3D |
  | ...            | ...        | ...      | ...        | ...     | ...    |

  `crcmod.mkCrcFun`的参数解析

  - *poly* –用于计算CRC的生成多项式。该值指定为Python整数或长整数。该整数中的位是多项式的系数。允许的唯一多项式是那些生成8、16、24、32或64位CRC的多项式。
  - *rev-*当为`True`时，选择位反转算法的标志。默认为 `True，`因为位反转算法更有效。
  - *initCrc* –用于开始CRC计算的初始值。该初始值应为初始移位寄存器值，如果使用反向算法则应反向，然后与最终XOR值进行XOR。这等效于算法应针对零长度字符串返回的CRC结果。默认设置为所有位，因为该起始值将考虑前导零字节。从零开始将忽略所有前导零字节。
  - *xorOut* –与计算出的CRC值进行XOR的最终值。由某些CRC算法使用。默认为零。

  ```python
  import binascii # binascii --- 二进制和 ASCII 码互转
  import crcmod
  
  #CRC8
  c8=crcmod.predefined.mkCrcFun('CRC-8')
  hex(c8("Test".encode()))
  #CRC16
  c16=crcmod.predefined.mkCrcFun('CRC-16')
  crc16=crcmod.mkCrcFun(0x18005,rev=True,initCrc=0x0000,xorOut=0x0000)
  crc16modbus=crcmod.mkCrcFun(0x18005,rev=True,initCrc=0xFFFF,xorOut=0x0000)
  print(hex(crc16(b"Test")))
  
  # 自定义CRC算法的功能crcmod.mkCrcFun(...) ：CRC16-MODBUS
  def crc16Add(read):
      crc16 =crcmod.mkCrcFun(0x18005,rev=True,initCrc=0xFFFF,xorOut=0x0000)
      data = read.replace(" ","")
      readcrcout=hex(crc16(binascii.unhexlify(data))).upper()
      str_list = list(readcrcout)
      if len(str_list) == 5:
          str_list.insert(2,'0')      # 位数不足补0
      crc_data = "".join(str_list)
      print(crc_data)
      read = read.strip()+' '+crc_data[4:]+' '+crc_data[2:4]
      print('CRC16校验:',crc_data[4:]+' '+crc_data[2:4])
      print('增加Modbus CRC16校验：>>>',read)
      return read
   
  if __name__ == '__main__':
      crc16Add("01 03 08 00 01 00 01 00 01 00 01")
      # CRC16校验: 28 D7
      # 增加Modbus CRC16校验：>>> 01 03 08 00 01 00 01 00 01 00 01 28 D7
  ```

  

# 进制转换

- [ ] | ↓      | 2进制         | 8进制         | 10进制         | 16进制         |
  | ------ | ------------- | ------------- | -------------- | -------------- |
  | 2进制  | -             | bin(int(n,8)) | bin(int(n,10)) | bin(int(n,16)) |
  | 8进制  | oct(int(n,2)) | -             | oct(int(n,10)) | oct(int(n,16)) |
  | 10进制 | int(n,2)      | int(n,8)      | -              | int(n,16)      |
  | 16进制 | hex(int(n,2)) | hex(int(n,8)) | hex(int(n,10)) | -              |

- [ ] 前缀：2进制是0b，8进制是0o，16进制是0x

  去除：切片操作[2:]

- [ ] format函数：

  ```python
  # to二进制
  # 先将2进制的数转换为10进制，然后在format的槽中添加一个b，等价于实现了bin函数的功能，此结果是不带有0b前缀的
  print("{:b}".format(int(input(),2)))
  ```

- [ ] ASCII码和字母之间的转换：

  > 字母转ASCII:
  >
  > ​	ord(c):参数是长度为1的字符串，简称字符。
  >
  > ASCII转字母：
  >
  > ​	chr(i)：返回一个字符，字符的ascii码等于参数中的整形数值。
  >
  > 特殊ASCII码：
  >
  > ​	A-65，Z-90，a-97，z-122，0-48，9-57



# 补零

- [ ] ```python
  n = "123"
  s = n.zfill(5)
  assert s == "00123"

  n = 123
  s = "%05d" % n
  s = "{:05d}".format(n)
  assert s == "00123"
  ```

  

# Json

[docs](https://docs.python.org/zh-cn/3/library/json.html)

```python
# -*- coding:utf-8 -*-  
import json
# dict
data = [{ 'a' : 1, 'c' : 2, 'b' : 3, '中文' : 9 } ]

# json.dumps()方法实现python类型转化为json字符串
print(json.dumps(data))
# sort_keys排序 indent缩进 separators分隔 ensure_ascii中文
data_json = json.dumps(data,sort_keys=True,indent=4,separators=(',',':'),ensure_ascii=False)
print(data_json)
# json.loads()方法将JSON文本字符串转换为Python对象
print(json.loads(data_json))

# json.dump()和json.load()来编码和解码JSON文件
filename = 'data-json.json'
with open(filename,'w',encoding='utf-8') as file:
    json.dump(data,file,sort_keys=True,indent=4,separators=(',',':'),ensure_ascii=False)
    #file.write(data_json)
with open(filename,'r',encoding='utf-8') as file:
    print(json.load(file))

```

