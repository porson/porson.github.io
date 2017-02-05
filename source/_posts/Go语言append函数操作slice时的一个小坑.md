---
title: Go语言append函数操作slice时的一个小坑
date: 2017-02-05 15:56:37
tags: 
    - Golang
    - Python
---
{% cq %}在学习Go语言的slice时发现了这样的一个问题，当对slice进行追加的时候，数据会被追加回原数组当中。{% endcq %}

<!-- more -->

### 问题重现

```go
package main

import "fmt"

func main() {

	Array_list_1 := [10]byte{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'}
	Array_list_2 := [10]byte{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'}

	slice_list_1 := Array_list_1[2:5]
	slice_list_2 := Array_list_1[3:]
	b := append(slice_list_1, 'p')

	fmt.Println(Array_list_1)
	fmt.Println(Array_list_2)
	fmt.Println(slice_list_1)
	fmt.Println(slice_list_2)
	fmt.Println(b)
}

```

输出的结果是

```reStructuredText
[97 98 99 100 101 112 103 104 105 106]
[97 98 99 100 101 102 103 104 105 106]
[99 100 101]
[100 101 112 103 104 105 106]
[99 100 101 112]

Process finished with exit code 0
```

我创建了两个相同的队列，然后对他们当中的一个（Array_list_1）进行切片，然后对其中一个切片进行追加，结果发现对切片进行追加后，原数组的内容也发生了改变，由102变为了112。

### 原理解析

![](/images/post/2017205/slice.png)

查阅资料后得知，**slice是引用类型**，在内存中并没有属于自己的内存空间，而是**通过指针指向进行切片的队列**。由于队列分配的内存空间是连续的，所以如果slice的最后一个元素不是list的最后一个元素，那么在append的时候，**新追加的元素就会覆盖掉原数组的元素**。而由于slice是指针组织的，**所以这个list的所有slice都会被影响**。如果切片末尾元素就是队列的末尾元素，返回的 slice 数组指针将指向这个空间，而原数组的内容将保持不变，其它引用此数组的 slice 则不受影响。

```go
package main

import "fmt"

func main() {

	Array_list_1 := [3]byte{'a', 'b', 'c'}
	Array_list_2 := [3]byte{'a', 'b', 'c'}

	slice_list_1 := Array_list_1[:]
	slice_list_2 := Array_list_1[:]
	b := append(slice_list_1, 'p')

	fmt.Println(Array_list_1)
	fmt.Println(Array_list_2)
	fmt.Println(slice_list_1)
	fmt.Println(slice_list_2)
	fmt.Println(b)
}

```

输出结果

```reStructuredText
[97 98 99]
[97 98 99]
[97 98 99]
[97 98 99]
[97 98 99 112]

Process finished with exit code 0

```

由此拓展可以知道，所有对slice的修改都会对原list产生修改。所以使用的时候一定要小心。



### 再拓展

那么有的小伙伴可能会想，Python也是引用，会不会也存在同样的问题？

```python
In [1]: a = [1,2,3,4]

In [2]: b = a[2:3]

In [3]: print b
[3]

In [4]: b.append(9)

In [5]: print a
[1, 2, 3, 4]

In [6]: print b
[3, 9]
```

通过Ipython做实验，发现结果与Golang并不像同，这是为什么呢？

这其实与Python内部的内存管理机制有关。在Python当中，为了节省内存，所有相同的值都只会有一个实体存在于内存当中，其他的对象指示对这个值的引用。Python内存管理通过引用计数器来判断某个内存是否无效，然后进行垃圾清理。

而虽然Python是引用同一个地址，但是知识值是引用同一个地址。通过id函数我们可以发现Python当中的切片与原数组的关系。

```python
In [7]: id(a)
Out[7]: 139899423150448

In [8]: id(b)
Out[8]: 139899423211888

```

再来看一下下面这个例子，相信你也马上就能明白了。

这是对这两个list当中相同元素的地址。

```python
In [9]: id(a[2])
Out[9]: 39203112

In [10]: id(b[0])
Out[10]: 39203112
```

由此拓展，同理，如果slice的元素发生改变，也会修改相应的