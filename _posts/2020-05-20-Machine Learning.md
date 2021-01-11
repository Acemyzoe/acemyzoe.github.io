---
title: Machine Learning
tags:
  - ML
---



# continual learning

持续学习：**可塑性**（学习新知识的能力）和**稳定性**（旧知识的记忆能力）

## **用已有的斧头解决问题**

针对**训练方法**（是否使用dropout）和不同的**激活函数**（logistic sigmoid/ rectified linear/ LWTA/ Maxout）对**灾难性遗忘问题**的影响。

**dropout**：网络中有非常多的连接，每一次参数更新的时候，随机的对这些连接做mask，mask掉的权重参数置零，不参与网络更新。dropout强迫网络把每一层的模式相对均匀的记忆在各个，相当于增加了模型的鲁棒性神经元中，使用dropout训练的模型size远大于不加dropout的模型大小。

## **造新斧头解决问题**

**Regularization**：在网络参数更新的时候**增加限制**，使得网络在学习新任务的时候不影响之前的知识。

**Ensembling:** 当模型学习新任务的时候，**增加新的模型**（可以是显式或者隐式的方式），使得多个任务实质还是对应多个模型，最后把多个模型的预测进行整合。

**Rehearsal：**在模型学习新任务的同时混合原来任务的数据，让模型能够学习新任务的同时兼顾的考虑旧任务。

**Dual-memory：**设计了两个网络，一个是fast-memory（短时记忆），另一个slow-memory（长时记忆），新学习的知识存储在fast memory中，fast-memory不断的将记忆整合transfer到slow-memory中。

**Sparse-coding:** 灾难性遗忘是因为模型在学习新任务（参数更新）时，把对旧任务影响重大的参数修改了。如果我们在模型训练的时候，人为的让模型参数变得**稀疏**（把知识存在少数的神经元上），就可以减少新知识记录对旧知识产生干扰的可能性。

# batch_size

- 样本集小(<2000)，直接使用batch梯度下降法，即btachsize=样本集大小。
- 样本集较大，一般为64-512。以128为分界线，测试64、256的训练效果。

- minbatch，选取为32或更小一些。选取为1，做纯SGD，磨低error。

# 数据预处理

## 归一化

```python
from sklearn import preprocessing
import numpy as np
 
x = np.array([[3., -1., 2., 613.],
              [2., 0., 0., 232],
              [0., 1., -1., 113],
              [1., 2., -3., 489]])
# 归一化
# MinMaxScaler方法归一到[0，1]，默认是对每一列做这样的归一化操作
min_max_scaler = preprocessing.MinMaxScaler()
x_minmax = min_max_scaler.fit_transform(x)
# MaxAbsScaler方法归一到[-1，1]
max_abs_scaler = preprocessing.MaxAbsScaler()
x_train_maxsbs = max_abs_scaler.fit_transform(x)
```

## 标准化

数据分析的过程中，比如线性规划这一类的分析，如果有些特征的数值远远高于或低于其他数值，通常称之为独立点、异常值或噪点，那么对于受噪点影响较大的模型就无法正确地去学习其他特征。

Standardization标准化：将特征数据的分布调整成标准正太分布，也叫高斯分布，过程为两步：去均值的中心化（均值变为0）；方差的规模化（方差变为1）。

```python
print("标准化之前的方差：", x.mean(axis=0))
print("标准化之前的标准差：", x.std(axis=0))
# 标准化
# scale方法，默认按照列进行标准化
x_scale = preprocessing.scale(x)
print("\n------------------\n标准化结果：\n", x_scale)
print("\n标准化之后的方差：", x_scale.mean(axis=0))
print("标准化之后的标准差：", x_scale.std(axis=0))
```

## 合并数据

### 堆叠合并

```python
pd.concat(objs, axis=0, join='outer', join_axes=None, ignore_index=False,
          keys=None, levels=None, names=None, verify_integrity=False,copy=True)
# objs：表示需要合并的表的组合[d1, d2]，接收多个Series, DataFrame, Panel 的组合，无默认；
# axis：默认为0，axis=0表示做列对齐，列名一致的话，将后表数据添加到前表的下几行；
#              axis=1表示做行对齐，行标签一致的话，将后表的数据添加到前表的后几列；
# join：默认为outer，接收‘inner’或‘outer’，表示取交集或并集；

# 纵向合并(concat或者append)
pd.concat([d1,d2], axis = 0, join='outer', sort=False)
d1.append(d2, sort=False) # append 方法对应的是 concat 函数中 axis = 0, join='outer' 的情况
```

### 主键合并

前后两个表按照一个或者多个键匹配的方式连接起来，一般是以某一或多列为键，匹配其他列，很类似 SQL 中的 join。

```python
pd.merge(left, right, how='inner', on=None, left_on=None, right_on=None,left_index=False, 
         right_index=False,sort=False,suffixes=('_x', '_y'), copy=True,
         indicator=False,validate=None)
# left, right：分别表示需要匹配的左表和右表，可接收的数据类型为 DataFrame；
# how：表示左右表的连接方式，默认为 inner ，可接收的取值为 left、right、inner、outer；
# on：表示左右表的连接主键，两个表的主键名称一致的时候才可以使用 on 参数，不一致时需使用left_on			right_on参数， on 参数默认为None，可接收的数据类型为 str 或 sequence
# left_on，right_on：分别表示左表和右表的连接主键，默认为None，可接收的数据类型为 str 或 sequence 
# sort：表示是否对合并后的数据进行排序，默认为False，可接收的数据类型为boolean 

# join 函数要求两个主键的名称必须相同
data1.join(data2, on=None,how='inner', lsuffix='', rsuffix='', sort=False)
```

### 重叠合并

同样一份数据存储在两张表中，将其中一个表的数据补充进另外一个表中，生成相对完整的数据。

```python
data1.combine_first(data2)
```

