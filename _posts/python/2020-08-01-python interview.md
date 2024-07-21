---
title : python Interview
tags : python
---
# python Interview

> 工作中真正的核心竞争力：写出整洁的代码和架构，面向对象的思维(原则与设计)，模式的使用。以及复杂性解决方法，抽象、分治、领域设计。
>
> 语言的特性，底层的原理，源码等特定细节的东西可以在使用时再去调研，但解决问题的能力，整洁的代码和架构并不是短期可以突击的。
>
> 系统：语言Python，Linux基础操作，SQL，消息队列，GIT…木桶理论
>
> 基础功扎实，新东西学得快，代码写得溜，命令敲得顺，bug解的好

# 基础语法

- 可变与不可变类型
- 浅拷贝与深拷贝的实现方式、区别；deepcopy如果你来设计，如何实现；
- `__new__() 与 __init__()`的区别；
- 你知道几种设计模式；
- 编码和解码你了解过么；
- 手写：正则邮箱地址；
- 介绍下垃圾回收：引用计数/分代回收/孤立引用环；
- 多进程与多线程的区别；CPU密集型适合用什么；
- 进程通信的方式有几种；
- 介绍下协程，为何比线程还快；

## 函数参数传递

```python
# Python的函数参数传递
# http://stackoverflow.com/questions/986006/how-do-i-pass-a-variable-by-reference
# 所有的变量都可以理解是内存中一个对象的“引用”

# strings, tuples, 和numbers 不可变对象
a=1
def fun1(a):
    print(id(a),id(1)) # 1798961072 1798961072
    a=2
    print(id(a),id(2)) # 1798961088 1798961088
    print(a) # 2
fun1(a)
print(a) # 1

# list, dict, set 可变对象
b=[]
def fun2(b):
    print(id(b)) # 9174792
    b.append(1)
    print(id(b)) # 9174792
    print(b) #[1]
fun2(b)
```

## 元类

```python
# 元类 metaclass
# http://stackoverflow.com/questions/100003/what-is-a-metaclass-in-python
# 元类是类的类，定义类的行为，常用作类工厂。type是Python用于在幕后创建所有类的元类。
class MyMeta(type):
    '''
        子类将获得一个class属性_order，该属性记录定义类的顺序。
    '''
    counter = 0
    def __init__(cls, name, bases, dic): # name:class名称 bases：父类的元组 dic/attrs：包含属性名称和值的字典
        type.__init__(cls, name, bases, dic)
        cls._order = MyMeta.counter
        MyMeta.counter += 1
class MyType0(metaclass=MyMeta):  
    pass

class MyType1(metaclass=MyMeta):  
    pass

class MyType2(MyMeta):
    pass

print(MyType0._order，MyType1._orderMyType2.counter) # 0 1 2
```

## 类变量和实例变量

```python
# 类变量和实例变量
class Test(object):  
    num_of_instance = 0  
    name = 'test'
    def __init__(self, name):  
        self.name = name  
        Test.num_of_instance += 1  
  
if __name__ == '__main__':  
    print(Test.name,Test.num_of_instance) # test 0
    t1 = Test('t1')  
    t2 = Test('t2')  
    print(t1.name , t1.num_of_instance) # t1 2
    print(t2.name , t2.num_of_instance) # t2 2
```

## python自省

```python
# 自省
# 运行时能够获得对象的类型.比如type(),dir(),getattr(),hasattr(),isinstance().
a = [1,2,3]
b = {'a':1,'b':2,'c':3}
c = True
print(type(a),type(b),type(c)) # <class 'list'> <class 'dict'> <class 'bool'>
print(isinstance(a,list))  # True
```

## 推导式

```python
# 推导式
# 列表推导式list
li=[i*2 for i in range(10) if i % 2 == 0]
print(li)
# 字典推导式dict
m={"a":1, "b":2, "c":3, "d":4}
di={v:k for k,v in m.items()}
print(di)
# 集合推导式set
# 集合是一种无重复无序的序列
s={i*2 for i in [1,1,2]}
print(s)
```

## 单下划线和双下划线

```python
# 单下划线和双下划线
# http://stackoverflow.com/questions/1301346/the-meaning-of-a-single-and-a-double-underscore-before-an-object-name-in-python
class MyClass():
    def __init__(self):
            self.__superprivate = "Hello"  # 解释器将其替换为对象名._类名__xxx
            self._semiprivate = ", world!" # 用来指定变量私有

my = MyClass()
print(my.__dict__)
print(my._MyClass__superprivate)
print(my._semiprivate)
```

## 迭代器和生成器

```python
# 迭代器和生成器
# https://stackoverflow.com/questions/231767/what-does-the-yield-keyword-do
# 列表可一一阅读它的项目。逐一读取其项称为迭代,所有值存储在内存。
# 生成器：边循环，边计算的机制—>generator
l = [x*x for x in range(10)] 
g = (x*x for x in range(10))
print(type(l),type(g)) # <class 'list'> <class 'generator'>
# itertools模块包含用于操纵可迭代对象的特殊功能
import itertools
horses=[1,2,3]
races = itertools.permutations(horses)
print(list(races)) # 三匹马比赛的可能到达顺序
```

## *args and **kwargs

```python
# *args and **kwargs
# https://stackoverflow.com/questions/3394835/use-of-args-and-kwargs
# 用*args传递任意数量的参数
def print_everything(*args):
    for count, thing in enumerate(args):
        print('{0}. {1}'.format(count, thing))
print_everything('1','a')
# **kwargs为函数提供任意关键字参数,并将它们作为字典使用。
def table_things(**kwargs):
    for name, value in kwargs.items():
        print('{0}={1}'.format(name, value))
table_things(apple='fruit', cabbage='vegetable')
# 调用函数时用*和**语法
def print_three_things(a, b, c):
    print('a={0}, b={1}, c={2}'.format(a,b,c))
mylist = ['1', '2', '3']
print_three_things(*mylist)
```

## 面向切面编程AOP和装饰器

```python
# 面向切面编程AOP和装饰器
# 装饰器的作用就是为已经存在的对象添加额外的功能,经常被用于有切面需求的场景
# https://stackoverflow.com/questions/739654/how-to-make-a-chain-of-function-decorators
'''装饰器只是语法糖
@decorator
def func():
    ...
等效于
def func():
    ...
func = decorator(func)
'''
###############################
# The decorator to make it bold
def makebold(fn):
    # The new function the decorator returns
    def wrapper():
        # Insertion of some code before and after
        return "<b>" + fn() + "</b>"
    return wrapper

# The decorator to make it italic
def makeitalic(fn): 
    return lambda: "<i>" + fn() + "</i>"

@makebold
@makeitalic
def say():
    return "hello"
print(say())
#################################
# This is the exact equivalent to
def says():
    return "hello"
my = makebold(makeitalic(says))
print(my())

class sty(object):
  def __init__(self, tag):
    self.tag = tag
  def __call__(self, f):
    def newf():
      return "<{tag}>{res}</{tag}>".format(res=f(), tag=self.tag)
    return newf

@sty('b')
@sty('i')
def sayhi():
  return 'hi'
print(sayhi())
###################################
# 使用functools.wraps
from functools import wraps
def wrap_in_tag(tag):
    def factory(func):
        @wraps(func)
        def decorator(val):
            return func('<%(tag)s>%(val)s</%(tag)s>' %
                        {'tag': tag, 'val': val})
        return decorator
    return factory

@wrap_in_tag('b')
@wrap_in_tag('i')
def log(s):
    return s
print(log('hello')) # <b><i>hello</i></b>
```

## 鸭子类型 duck typing

> 当看到一只鸟走起来像鸭子、游泳起来像鸭子、叫起来也像鸭子，那么这只鸟就可以被称为鸭子。
>
> 一个对象有效的语义，不是由继承自特定的类或实现特定的接口，而是由"当前方法和属性的集合"决定。
>
> 鸭子类型是多态性的一种表现，函数可以通过鸭子类型来处理不同类型的对象，函数重载在动态语言中就显得没有意义。

## Python不支持函数重载

> 函数重载主要是为了解决两个问题。
>
> 1. 可变参数类型。而 python 可以接受任何类型的参数。
> 2. 可变参数个数。而 python 使用缺省参数。

## `__new__`和`__init__`的区别

> 1. `__new__`是一个静态方法,而`__init__`是一个实例方法.
> 2. `__new__`方法会返回一个创建的实例,而`__init__`什么都不返回.
> 3. 只有在`__new__`返回一个cls的实例时后面的`__init__`才能被调用.
> 4. 当创建一个新实例时调用`__new__`,初始化一个实例时用`__init__`.
> 5. `__new__`除非要继承不可变类型（例如str，int，unicode或tuple），否则无需重写
> 6. 可以分别使用`__metaclass__`,`__new__`和`__init__`来分别在类创建,实例创建和实例初始化的时候做一些小手脚.

## 单例模式

```python
# 使用__new__方法
class Singleton(object):
    def __new__(cls, *args, **kw):
        if not hasattr(cls, '_instance'):
            orig = super(Singleton, cls)
            cls._instance = orig.__new__(cls, *args, **kw)
        return cls._instance
class MyClass(Singleton):
    a = 1

# 共享属性:创建实例时把所有实例的__dict__指向同一个字典
class Borg(object):
    _state = {}
    def __new__(cls, *args, **kw):
        ob = super(Borg, cls).__new__(cls, *args, **kw)
        ob.__dict__ = cls._state
        return ob
class MyClass2(Borg):
    a = 1

# 装饰器版本
def singleton(cls):
    instances = {}
    def getinstance(*args, **kw):
        if cls not in instances:
            instances[cls] = cls(*args, **kw)
        return instances[cls]
    return getinstance
@singleton
class MyClass:
    a = 1

# import方法,作为python的模块是天然的单例模式
# mysingleton.py
class My_Singleton(object):
    def foo(self):
        pass
my_singleton = My_Singleton()
# to use
from mysingleton import my_singleton
my_singleton.foo()
```

## GIL线程全局锁Global Interpreter Lock

> Python为了保证线程安全而采取的独立线程运行的限制,一个核只能在同一时间运行一个线程。
>
> https://www.oschina.net/translate/pythons-hardest-problem
>
> 对于io密集型任务，python的多线程起到作用，但对于cpu密集型任务，python的多线程几乎占不到任何优势，还有可能因为争夺资源而变慢。
>
> 解决办法就是多进程和协程。
>
> 协程是进程和线程的升级版,进程和线程都面临着内核态和用户态的切换问题而耗费许多切换时间,而协程就是用户自己控制切换的时机,不再需要陷入系统的内核态。Python里最常见的yield就是协程的思想

```python
# yield是与return一样使用的关键字return，不同之处在于该函数将返回生成器。
# 第一次for调用从函数创建的生成器对象时，它将从头开始运行函数中的代码，直到命中yield，然后它将返回循环的第一个值。然后，每个后续调用将运行您在函数中编写的循环的另一个迭代，并返回下一个值。这将一直持续到生成器被认为是空的为止，这在函数运行时没有命中时就会发生yield。
def createGenerator():
    mylist = range(3)
    for i in mylist:
        yield i*i
mygenerator = createGenerator()# 在调用该函数时，在函数主体中编写的代码不会运行。该函数仅返回生成器对象
for i in mygenerator:
    print(i)
```

## 闭包closure

```python
# 闭包
# https://zhuanlan.zhihu.com/p/22229197
# 在一个内部函数中，对外部作用域的变量进行引用，(并且一般外部函数的返回值为内部函数)
# 闭包作用：函数运行后并不会被撤销，用于保存当前的运行环境
def start(x):
    def increment(y): # 闭包
        return x+y
    return increment
a = start(1)
print(a) # <function start.<locals>.increment at 0x0384CC40>
print(a(1)) # 2
```

## Python函数式编程

```python
# Python函数式编程
# https://coolshell.cn/articles/10822.html
# lambda匿名函数
a = map(lambda x:x*2,[1,2,3]) # map函数是对一个序列的每个项依次执行函数
print((a))
b = filter(lambda x: x > 5, a) 
# filter函数的功能相当于过滤器。
# 调用一个布尔函数bool_func来迭代遍历每个seq中的元素；返回一个使bool_seq返回值为true的元素的序列
print(list(b))
```

## Python里的拷贝

```python
# 引用和copy(),deepcopy()的区别
# https://www.geeksforgeeks.org/copy-python-deep-copy-shallow-copy/
import copy
a = [1, 2, 3, 4, ['a', 'b']]  #原始对象

b = a  #赋值，传对象的引用
c = copy.copy(a)  #对象拷贝，浅拷贝
d = copy.deepcopy(a)  #对象拷贝，深拷贝

a.append(5)  #修改对象a
a[4].append('c')  #修改对象a中的['a', 'b']数组对象

print('原始对象a = ',a) # [1, 2, 3, 4, ['a', 'b', 'c'], 5]
print('引用b = ',b) # [1, 2, 3, 4, ['a', 'b', 'c'], 5]
print('浅拷贝c = ',c) # [1, 2, 3, 4, ['a', 'b', 'c']]
print('深拷贝d = ',d) # [1, 2, 3, 4, ['a', 'b']]
```

## Python垃圾回收机制

```python
# Python垃圾回收机制
# https://sutune.me/2018/10/14/python-GC/
# https://juejin.im/post/6844903629556547598
# http://www.ityouknow.com/python/2020/01/06/python-gc-111.html
# Python GC主要使用引用计数（reference counting）来跟踪和回收垃圾
# 通过“标记-清除”（mark and sweep）解决容器对象可能产生的循环引用问题
# 通过“分代回收”（generation collection）以空间换时间的方法提高垃圾回收效率

# 『引用计数法』的原理是：每个对象维护一个ob_ref字段，用来记录该对象当前被引用的次数，每当新的引用指向该对象时，它的引用计数ob_ref加1，每当该对象的引用失效时计数ob_ref减1，一旦对象的引用计数为0，该对象立即被回收，对象占用的内存空间将被释放。
# 循环引用导致内存泄露。解决方法：gc模块提供一个接口给开发者设置垃圾回收的选项
import sys
import gc
class A():
    def __init__(self):
        '''初始化对象'''
        print('object born id:%s' %str(hex(id(self))))

def func(c):
    print('obejct refcount is: ',sys.getrefcount(c)) #getrefcount()方法用于返回对象的引用计数

def fnrc():
    #生成对象
    a=A()
    func(a)
    #增加引用
    b=a
    func(a)
    #销毁引用对象b
    del b
    func(a)

def fngc():  
    '''垃圾自动回收'''
    gc.isenabled = True  
    print(gc.get_count())
    a=A()
    print(gc.get_count())
    del a
    print(gc.get_count())

if __name__ == '__main__':
    fngc()
```

## Python中list是如何实现的

https://www.jianshu.com/p/J4U6rR

## Python的is/==

```python
# is 与 == 的区别
# https://stackoverflow.com/questions/132988/is-there-a-difference-between-and-is
# https://stackoverflow.com/questions/26595/is-there-any-difference-between-foo-is-none-and-foo-none
a=1000
b=1e3
c=1000.0
print(a is b) # False
print(a is c) # False
```

## Python2和3的区别

```python
# http://chenqx.github.io/2014/11/10/Key-differences-between-Python-2-7-x-and-Python-3-x/	
from __future__ import division,unicode_literals
```



# 数据结构&算法

- 手写：已知一个长度n的无序列表，元素均是数字，要求把所有间隔为d的组合找出来，你写的解法算法复杂度多少；
- 手写：一个列表A=[A1，A2，…,An]，要求把列表中所有的组合情况打印出来；
- 手写：用一行python写出1+2+3+…+10**8 ；
- 手写python：用递归的方式判断字符串是否为回文；
- 单向链表长度未知，如何判断其中是否有环；
- 单向链表如何使用快速排序算法进行排序；
- 手写：一个长度n的无序数字元素列表，如何求中位数，如何尽快的估算中位数，你的算法复杂度是多少；
- 如何遍历一个内部未知的文件夹（两种树的优先遍历方式）
- 给定一个数组，构建二叉树，并且按层次打印这个二叉树

## 台阶问题/斐波那契

> 一只青蛙一次可以跳上1级台阶，也可以跳上2级。求该青蛙跳上一个n级的台阶总共有多少种跳法。

```python
# 方法一
fib = lambda n: n if n<=2 else fib(n-1)+fib(n-2)
# 第二种记忆方法
def memo(func):
    cache = {}
    def wrap(*args):
        if args not in cache:
            cache[args] = func(*args)
        return cache[args]
    return wrap
@memo
def fib(i):
    if i < 2:
        return 1
    return fib(i-1)+fib(i-2)
# 方法三
def fib(n):
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a+b
    return b
```

> 一只青蛙一次可以跳上1级台阶，也可以跳上2级……它也可以跳上n级。求该青蛙跳上一个n级的台阶总共有多少种跳法。

```python
fib = lambda n: n if n<2 else 2*fib(n-1)
```

> 用n个`2*1`的小矩形无重叠地覆盖一个`2*n`的大矩形，总共有多少种方法？

```python
f = lambda n: 1 if n < 2 else f(n-1) + f(n-2)
```

## 去除列表中的重复元素

```python
# 去除列表中的重复元素
l = [1,1,2,2,3,4]
# 用集合
print(list(set(l)))
# 用字典
print({}.fromkeys(l).keys())
# 列表推导式
```

## 链表成对调换

> `1->2->3->4`转换成`2->1->4->3`.

## 合并两个有序列表

```python
# 尾递归
a = [1,2,3,7]
b = [3,4,5]
def _recursion_merge_sort2(l1, l2, tmp):
    if len(l1) == 0 or len(l2) == 0:
        tmp.extend(l1)
        tmp.extend(l2)
        return tmp
    else:
        if l1[0] < l2[0]:
            tmp.append(l1[0])
            del l1[0]
        else:
            tmp.append(l2[0])
            del l2[0]
        return _recursion_merge_sort2(l1, l2, tmp)
def recursion_merge_sort2(l1, l2):
    return _recursion_merge_sort2(l1, l2, [])
print(recursion_merge_sort2(a,b))

# 循环算法
a = [1,2,3,7]
b = [3,4,5]
def loop_merge_sort(l1, l2):
    tmp = []
    while len(l1) > 0 and len(l2) > 0:
        if l1[0] < l2[0]:
            tmp.append(l1[0])
            del l1[0]
        else:
            tmp.append(l2[0])
            del l2[0]
    tmp.extend(l1)
    tmp.extend(l2)
    return tmp
print(loop_merge_sort(a,b))

# pop弹出
a = [1,2,3,7]
b = [3,4,5]
def merge_sortedlist(a,b):
    c = []
    while a and b:
        if a[0] >= b[0]:
            c.append(b.pop(0))
        else:
            c.append(a.pop(0))
    while a:
        c.append(a.pop(0))
    while b:
        c.append(b.pop(0))
    return c
print(merge_sortedlist(a,b))

# 先合并后排序
a = [1,2,3,7]
b = [3,4,5]
def merge_sort(a,b):
    c=a+b
    c.sort()
    return c
print(merge_sort(a,b))
```

## python链表

https://juejin.im/post/6844903672661409800

https://www.jianshu.com/p/e4000619232b

```python
# 用python中的引用来实现链表
# 节点类
# 功能包括：更新数据，查询数据，更新后继节点和查询后继节点。
class Node(object):
    #初始化，需要传入节点的数据
    def __init__(self, data):
        self.data = data
        self.next = None
    
    #返回节点的数据
    def get_data(self):
        return self.data
    
    #更新节点的数据
    def set_data(self, new_data):
        self.data = new_data
        
    #返回后继节点
    def get_next(self):
        return self.next
    
    #变更后继节点
    def set_next(self, new_next):
        self.next = new_next

# 链表类
# 节点的增加、删除和查询，返回链表的长度，返回链表是否为空等
class Linked_list(object):
    #初始化，头结点为空
    def __init__(self):
        self.head = None
    
    #添加节点，添加的新节点作为新的头结点
    def add(self, data):
        new_node = Node(data)
        new_node.set_next() = self.head
        self.head = new_node
        
    #包含查询，传入值，返回该值在链表中是否存在
    def search(self, data):
        checking = self.head #从头结点开始查询
        while checking != None :
            if checking.get_data() == data: #查找到，返回True
                return True
            checking = checking.get_next() #查询下一个节点
        return False #遍历到最后也未能找到，返回False
        
    #删除节点，将第一个具有传入值的节点从链表中删除
    def remove(self, data):
        checking = self.head #从头结点开始查询
        previous = None #记录前一个节点，头结点的前一个节点为None
        
        while checking != None :
            if checking.get_data() == data: #查找到，跳出查找循环
                break
            previous = checking # 更新前一个节点
            checking = checking.get_next() #查询下一个节点

        if previous == None:# 如果头结点便是查找的节点
            self.head = checking.get_next()
        else: # 查找的节点不在头结点，即，存在前驱节点
            previous.set_next(checking.get_next())       
    
    #判断链表是否为空
    def isEmpty(self):
        return self.head == None
    
    #返回链表长度
    def size(self):
        count = 0
        counting = self.head #从头结点开始计数
        while counting != None :
            count += 1
            counting = counting.get_next()
        return count
```

### 单链表逆置

```python
class Node(object):
    def __init__(self, data=None, next=None):
        self.data = data
        self.next = next

def relink(link):
    pre = link
    cur = link.next
    pre.next = None
    while cur:
        tmp = cur.next
        cur.next = pre
        pre = cur
        cur = tmp
    return pre

link = Node(1, Node(2, Node(3, Node(4))))
root = relink(link)
while root:
    print(root.data)
    root = root.next
```

### 交叉链表求交点

```python
# 使用a,b两个list来模拟链表，可以看出交叉点是 7这个节点
a = [1,2,3,7,9,1,5]
b = [4,5,7,9,1,5]
# 从尾开始比较两个链表，如果相交，则从尾开始必然一致，只要从尾开始比较，直至不一致的地方即为交叉点
for i in range(1,min(len(a),len(b))):
    if i==1 and (a[-1] != b[-1]):
        print("No")
        break
    else:
        if a[-i] != b[-i]:
            print("交叉节点：",a[-i+1])
            break
        else:
            pass

# 构造链表类
class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None

def node(l1, l2):
    length1, length2 = 0, 0
    # 求两个链表长度
    while l1.next:
        l1 = l1.next#尾节点
        length1 += 1
    while l2.next:
        l2 = l2.next#尾节点
        length2 += 1

    #如果相交
    if l1.next == l2.next:
        # 长的链表先走
        if length1 > length2:
            for _ in range(length1 - length2):
                l1 = l1.next
            return l1#返回交点
        else:
            for _ in range(length2 - length1):
                l2 = l2.next
            return l2#返回交点
    # 如果不相交
    else:
        return
```

## 二分查找

```python
# 二分查找
# 给出一个已经排好序的列表,查找指定元素在列表中的位置
def binary_search(list, item):
    low = 0
    high = len(list) - 1
    while low <= high:
        mid = int((high-low)/2+low) # 避免(high+low)/2溢出
        guess = list[mid]
        if guess > item:
            high = mid - 1
        elif guess < item:
            low = mid + 1
        else:
            return mid
    return None
mylist = [1,3,5,7,9]
print(binary_search(mylist, 3))
```

## 排序

### 冒泡排序 O(n^2)

```python
# 冒泡排序
def bubble_sort(list):
    if len(list)>2:
        for i in range(len(list)):
            flag=False
            for j in range(1,len(list)):
                if list[j] < list[j-1]:
                    list[j],list[j-1]=list[j-1],list[j] 
                    flag=True
            if flag is False: # 优化
                return list             
    return list
```

### 选择排序 O(n^2)

```python
# 选择排序
# 找到数组中最小的元素，然后往新数组里追加，时间复杂度O(n^2)
def min_index(list):
    min_index = 0
    min_value = list[min_index]
    for index,value in enumerate(list):
        if value<min_value:
            min_value=value
            min_index=index
    return min_index
def select_sort(list):
    new_list = []
    for i in range(len(list)):
        new_list.append(list.pop(min_index(list)))
        '''等效于
        new_list.append(min(list))
        list.remove(min(list))
        '''
    return new_list

# 方法二
def selectSort(list):
    for i in range(len(list)):
        min_index = i
        for j in range(i+1,len(list)):  # 这个循环会找到值比第i个索引所代表值小的索引
            if list[j] < list[min_index]:
                min_index = j
        list[i] ,list[min_index] = list[min_index], list[i]  # 互换两个索引位置
    return list

# 方法三，更加简便，但是注意和冒泡法进行区分
def selectSort(list):
    for i in range(len(list)):
        for j in range(len(list)-i):
            if list[i] > list[i+j]:
                list[i],list[i+j] = list[i+j],list[i]
    return list
```

### 快速排序 O(n*logn)

```python
# 快排 分片的思想+递归的思想，
# 栈高为O(log(n)),栈长O(n),运行时间为栈高x栈长，O(nlog(n))

def quickSort(list):
    if len(list) < 2:
        return list # 基线条件为空或者只包含一个元素的数组是有序的
    else:
        pivot = list[0] # 递归条件
        less = [i for i in list[1:] if i < pivot]
        greater = [j for j in list[1:] if j >= pivot]
        return quickSort(less) + [pivot] + quickSort(greater)
```

### 插入排序 O(n^2)

```python
# 直接插入排序
# 每一步都将一个待排数据按其大小插入到已经排序的数据中的适当位置，直到全部插入完毕。
def insertSort(list):
    len_ = len(list)
    for i in range(1,len_):  
        for j in range(i):
            if list[i] < list[j]:
                list.insert(j,list[i])  # 首先碰到第一个比自己大的数字，赶紧刹车，停在那，所以选择insert
                list.pop(i+1)  # 因为前面的insert操作，所以后面位数+1，这个位置的数已经insert到前面去了，所以pop弹出
                break
    return list
```

#### 希尔排序  O(nlogn)

```python
# 希尔(Shell)排序又称为缩小增量排序，它是一种插入排序。它是直接插入排序算法的一种威力加强版
def shell_sort(list):
    n = len(list)
    gap = n//2  # 初始步长
    while gap > 0:
        for i in range(gap,n): # 插排
            for j in range(i):
                if list[i]<list[j]:
                    list.insert(j,list[i])
                    list.pop(i+1)
                    break       
        gap = gap//2  # 得到新的步长       
    return list
```

### 归并排序 O(nlogn)

```python
# 归并排序
# 使用分割的办法将这个序列分割成一个个已经排好序的子序列。然后再利用归并的方法将一个个的子序列合并成排序好的序列
def merge(left,right): # 合并的过程
    result = []
    while left and right:
        result.append(left.pop(0) if left[0] <= right[0] else right.pop(0))
    while left:
        result.append(left.pop(0))
    while right:
        result.append(right.pop(0))       
    return result

def mergeSort(list):
    if len(list) < 2:
        return list
    mid_index = len(list)//2
    left = mergeSort(list[:mid_index])  # 递归拆解的过程
    right = mergeSort(list[mid_index:])
    return merge(left,right)  
```

### 堆排序 O(nlogn)

```python
# 堆排
def MAX_Heapify(heap,HeapSize,root):#在堆中做结构调整使得父节点的值大于子节点
    left = 2*root + 1
    right = left + 1
    larger = root
    if left < HeapSize and heap[larger] < heap[left]:
        larger = left
    if right < HeapSize and heap[larger] < heap[right]:
        larger = right
    if larger != root:#如果做了堆调整则larger的值等于左节点或者右节点的，这个时候做对调值操作
        heap[larger],heap[root] = heap[root],heap[larger]
        MAX_Heapify(heap, HeapSize, larger)

def Build_MAX_Heap(heap):#构造一个堆，将堆中所有数据重新排序
    HeapSize = len(heap)
    for i in range((HeapSize -2)//2,-1,-1):#从后往前出数
        MAX_Heapify(heap,HeapSize,i)

def HeapSort(heap):#将根节点取出与最后一位做对调，对前面len-1个节点继续进行对调整过程。
    Build_MAX_Heap(heap)
    for i in range(len(heap)-1,-1,-1):
        heap[0],heap[i] = heap[i],heap[0]
        MAX_Heapify(heap, i, 0)
    return heap
```

## 二叉树

```python
# 二叉树节点
class Node(object):
    def __init__(self, value, left=None, right=None):
        self.value = value
        self.left = left
        self.right = right
tree = Node(1,Node(2),Node(3))
tree1 = Node(1, Node(3, Node(7, Node(0)), Node(6)), Node(2, Node(5), Node(4)))

# 深度优先遍历DFS
# 从根节点出发，沿着左子树方向进行纵向遍历，直到找到叶子节点为止。然后回溯到前一个节点，进行右子树节点的遍历，直到遍历完所有可达节点为止。
def dfs(root):
    if not root:
        return
    print(root.value)
    dfs(root.left)
    dfs(root.right)

# 广度优先遍历BFS / 层次遍历
# 从根节点出发，在横向遍历二叉树层段节点的基础上纵向遍历二叉树的层次。
def bfs(root):
    row = [root]
    while row:
        for i in range(len(row)):
            print(row[i].value)
        row = [kid for item in row for kid in (item.left, item.right) if kid]
        

# 中序遍历:遍历左子树,访问当前节点,遍历右子树
def mid_travelsal(root):
    if root.left is not None:
        mid_travelsal(root.left)
    #访问当前节点
    print(root.value)
    if root.right is not None:
        mid_travelsal(root.right)

# 前序遍历:访问当前节点,遍历左子树,遍历右子树
def pre_travelsal(root):
    print (root.value)
    if root.left is not None:
        pre_travelsal(root.left)
    if root.right is not None:
        pre_travelsal(root.right)

# 后序遍历:遍历左子树,遍历右子树,访问当前节点
def post_trvelsal(root):
    if root.left is not None:
        post_trvelsal(root.left)
    if root.right is not None:
        post_trvelsal(root.right)
    print (root.value)

# 最大树深
def maxDepth(root):
        if not root:
            return 0
        return max(maxDepth(root.left), maxDepth(root.right)) + 1

# 判断俩树是否相同
def isSameTree(p, q):
    if p == None and q == None:
        return True
    elif p and q :
        return p.value == q.value and isSameTree(p.left,q.left) and isSameTree(p.right,q.right)
    else :
        return False

# 已知前序中序求后序
def rebuild(pre, center): # 还原二叉树
    if not pre:
        return
    cur = Node(pre[0]) # 前序遍历的第一个值就是根节点
    index = center.index(pre[0]) # 在中序遍历中找到这个值
    cur.left = rebuild(pre[1:index + 1], center[:index]) # 值的左边为左子树部分前序遍历结果
    cur.right = rebuild(pre[index + 1:], center[index + 1:]) # 值的右边为右子树部分前序遍历结果
    return cur
```

## 判断两个字符串是否是变位词

```python
class Anagram:
    """判断两个字符串是否是变位词
    @:param s1: The first string
    @:param s2: The second string
    @:return true or false
    """
    def Solution1(s1,s2):
        alist = list(s2)
        pos1 = 0
        stillOK = True
        while pos1 < len(s1) and stillOK:
            pos2 = 0
            found = False
            while pos2 < len(alist) and not found:
                if s1[pos1] == alist[pos2]:
                    found = True
                else:
                    pos2 = pos2 + 1
            if found:
                alist[pos2] = None
            else:
                stillOK = False
            pos1 = pos1 + 1
        return stillOK

    def Solution2(s1,s2):
        alist1 = list(s1)
        alist2 = list(s2)
        alist1.sort()
        alist2.sort()
        pos = 0
        matches = True
        while pos < len(s1) and matches:
            if alist1[pos] == alist2[pos]:
                pos = pos + 1
            else:
                matches = False
        return matches

    def Solution3(s1,s2):
        c1 = [0]*26
        c2 = [0]*26
        for i in range(len(s1)):
            pos = ord(s1[i])-ord('a')
            c1[pos] = c1[pos] + 1
        for i in range(len(s2)):
            pos = ord(s2[i])-ord('a')
            c2[pos] = c2[pos] + 1
        j = 0
        stillOK = True
        while j<26 and stillOK:
            if c1[j] == c2[j]:
                j = j + 1
            else:
                stillOK = False
        return stillOK

print(Anagram.Solution1('abcd','dcba'))
print(Anagram.Solution2('abcde','edcbg'))
print(Anagram.Solution3('apple','pleap'))
```



# 网络基础

- TCP/IP分别在模型的哪一层：传输层/网络层
- socket长连接是什么意思；
- select和epoll你了解么，区别在哪；
- TIME_WAIT过多是因为什么；
- http一次连接的全过程：你来说下从用户发起request——到用户接收到response；
- http连接方式。get和post的区别，你还了解其他的方式么；
- 状态码你知道多少，比如200/403/404/504等等；

## 三次握手

1. 客户端通过向服务器端发送一个SYN来创建一个主动打开，作为三次握手的一部分。客户端把这段连接的序号设定为随机数 A。
2. 服务器端应当为一个合法的SYN回送一个SYN/ACK。ACK 的确认码应为 A+1，SYN/ACK 包本身又有一个随机序号 B。
3. 最后，客户端再发送一个ACK。当服务端受到这个ACK的时候，就完成了三路握手，并进入了连接创建状态。此时包序号被设定为收到的确认号 A+1，而响应则为 B+1。

## 四次挥手

​	*以客户端断开连接举例*

1. 客户端发送一个数据分段, 其中的 FIN 标记设置为1. 客户端进入 FIN-WAIT 状态. 该状态下客户端只接收数据, 不再发送数据.
2. 服务器接收到带有 FIN = 1 的数据分段, 发送带有 ACK = 1 的剩余数据分段, 确认收到客户端发来的 FIN 信息.
3. 服务器等到所有数据传输结束, 向客户端发送一个带有 FIN = 1 的数据分段, 并进入 CLOSE-WAIT 状态, 等待客户端发来带有 ACK = 1 的确认报文.
4. 客户端收到服务器发来带有 FIN = 1 的报文, 返回 ACK = 1 的报文确认, 为了防止服务器端未收到需要重发, 进入 TIME-WAIT 状态. 服务器接收到报文后关闭连接. 客户端等待 2MSL 后未收到回复, 则认为服务器成功关闭, 客户端关闭连接.

## ARP协议

地址解析协议(Address Resolution Protocol)，其基本功能为透过目标设备的IP地址，查询目标的MAC地址，以保证通信的顺利进行。它是IPv4网络层必不可少的协议，不过在IPv6中已不再适用，并被邻居发现协议（NDP）所替代。

## 幂等 Idempotence

> HTTP方法的幂等性是指一次和多次请求某一个资源应该具有同样的**副作用**。(注意是副作用)
>
> `GET http://www.bank.com/account/123456`，不会改变资源的状态，不论调用一次还是N次都没有副作用。请注意，这里强调的是一次和N次具有相同的副作用，而不是每次GET的结果相同。`GET http://www.news.com/latest-news`这个HTTP请求可能会每次得到不同的结果，但它本身并没有产生任何副作用，因而是满足幂等性的。
>
> DELETE方法用于删除资源，有副作用，但它应该满足幂等性。比如：`DELETE http://www.forum.com/article/4231`，调用一次和N次对系统产生的副作用是相同的，即删掉id为4231的帖子；因此，调用者可以多次调用或刷新页面而不必担心引起错误。
>
> POST所对应的URI并非创建的资源本身，而是资源的接收者。比如：`POST http://www.forum.com/articles`的语义是在`http://www.forum.com/articles`下创建一篇帖子，HTTP响应中应包含帖子的创建状态以及帖子的URI。两次相同的POST请求会在服务器端创建两份资源，它们具有不同的URI；所以，POST方法不具备幂等性。
>
> PUT所对应的URI是要创建或更新的资源本身。比如：`PUT http://www.forum/articles/4231`的语义是创建或更新ID为4231的帖子。对同一URI进行多次PUT的副作用和一次PUT是相同的；因此，PUT方法具有幂等性。

## RESTful架构(Representational State Transfer)

http://www.ruanyifeng.com/blog/2011/09/restful.html

> 每一个URI代表一种资源；
>
> 客户端和服务器之间，传递这种资源的某种表现层；
>
> 客户端通过四个HTTP动词 GET、POST、PUT、DELETE，对服务器端资源进行操作，实现"表现层状态转化"。

> RPC -> SOAP -> RESTful

# 数据库

- MySQL锁有几种；死锁是怎么产生的；
  - 悲观锁：假定会发生并发冲突，屏蔽一切可能违反数据完整性的操作
  - 乐观锁：假设不会发生并发冲突，只在提交操作时检查是否违反数据完整性。
- 为何，以及如何分区、分表；
- 了解join么，有几种，有何区别，A LEFT JOIN B，查询的结果中，B没有的那部分是如何显示的（NULL）；
- 索引类型有几种，BTree索引和hash索引的区别（我没答上来这俩在磁盘结构上的区别）；
- 手写：如何对查询命令进行优化；
- NoSQL了解么，和关系数据库的区别；redis有几种常用存储类型；
- 谈谈mysql字符集和排序规则？
- .varchar与char的区别是什么？大小限制？utf8字符集下varchar最多能存多少个字符
- 外键有什么用，是否该用外键？外键一定需要索引吗？

## 数据库索引

[MySQL索引背后的数据结构及算法原理](http://blog.codinglabs.org/articles/theory-of-mysql-index.html)

# Linux

- 讲一下你常用的Linux/git命令和作用；
- 查看当前进程是用什么命令，除了文件相关的操作外，你平时还有什么操作命令；

# 项目

- 简单的介绍下你在公司的项目，不管是不是后端相关的，主要是要体现出你干了什么；
- 你在项目中遇到最难的部分是什么，你是怎么解决的；
- 你看过django的admin源码么；看过flask的源码么；你如何理解开源；
- MVC / MTV；
- 缓存怎么用；
- 中间件是干嘛的；
  

