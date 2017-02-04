---
title: 'Python字符串加密实现'
date: 2017-02-04 09:46:57
tags: Python
---
{% cq %}之前负责的一个项目是针对公司测试、实验环境提供一套共用的脚本审核发布系统，其中涉及到了自定义数据库与发布帐号的注册。由于是共用系统，为了账户信息的安全，对敏感字段进行了加密处理。
以下是整理的笔记以及总结的一些方法论。{% endcq %}

<!-- more -->

### 字符串加密基本思路
#### 可逆加密
> 可还原加密是指对加密后生成的字符串进行解密，可以得到原字符串。

这种加密的实现方法有很多种，平时使用较多的一个是采用base64模块，再就是自己写加密算法实现。
##### Base64
> Base64是网络上最常见的用于传输8Bit字节代码的编码方式之一。

Base64就是利用a-z，A-Z，0-9外加'+'和'/'（最后两个特殊符号会根据不同的Base64变种而有所不同）这总共64个字符对原字符串进行处理替换，来达到对使原字符串不可见的效果。
但是这种加密算法非常简单，是可逆的，安全性很低。
Base64算法的简单规则如下：
1. 把3个字符变成4个字符。
2. 每76个字符加一个换行符。
3. 最后的结束符也要处理。

[点击我查看更多Base64](http://baike.baidu.com/link?url=E8-vj9CcIckBaSvpw_Sx-9Y7RhpXBR1hctrI9hiGgdQ6YAwuXE0U_jPLsOoLatdlgxNecox6_CYoiUHixX5P0q)
##### 自定义加密算法
通过自己设计的加密规则对字符串进行处理，来达到字符串不可见的效果。
这个方法的安全性在于加密算法的保密性。
#### 不可逆加密 
##### 摘要算法
常见的'MD5'、'SHA1'这些加密就是摘要算法加密。（就是哈希算法）
> 其实摘要算法不是加密算法，无法通过摘要反推明文，只能用于防篡改，但是它的单向计算特性决定了可以在不存储明文口令的情况下验证用户口令。

摘要算法最长用在文件完整性校验，密码验证等不需要反推只需要对比的场景下。
所以，为什么QQ密码只能重置不能找回。所以，付费MD5解密都是骗人的。

---
### 示例代码
#### Base64
```python
import base64

s1 = base64.encodestring('hello world')
s2 = base64.decodestring(s1)
print s1, s2
```
输出结果
```
aGVsbG8gd29ybGQ=
hello world
```

#### 摘要算法
##### MD5
```python
import hashlib

test_string = '123456'

md5 = hashlib.md5()
md5.update(test_string.encode('utf-8'))
md5_encode = md5.hexdigest()
print(md5_encode)

sha1 = hashlib.sha1()
sha1.update(test_string.encode('utf-8'))
sha1_encode = sha1.hexdigest()
print(sha1_encode)
```
输出结果
```
e10adc3949ba59abbe56e057f20f883e 
7c4a8d09ca3762af61e59520943dc26494f8941b
```
多次追加

```python
md5 = hashlib.md5()
md5.update('how to use md5 in ')
md5.update('python hashlib?')
print md5.hexdigest()
```
加盐
```python
# 方法1（固定盐）
def calc_md5(password):
    return get_md5(password + 'the-Salt')

# 方法2（用户名盐）
db = {}
def register(username, password):
    db[username] = get_md5(password + username + 'the-Salt')
```

##### SHA1
```python
import hashlib

sha1 = hashlib.sha1()
sha1.update('how to use sha1 in ')
sha1.update('python hashlib?')
print sha1.hexdigest()
```
SHA1的结果是160 bit字节，通常用一个40位的16进制字符串表示。

比SHA1更安全的算法是SHA256和SHA512，不过越安全的算法越慢，而且摘要长度更长。

### 其他
有没有可能两个不同的数据通过某个摘要算法得到了相同的摘要？完全有可能，因为任何摘要算法都是把无限多的数据集合映射到一个有限的集合中。这种情况称为碰撞，比如Bob试图根据你的摘要反推出一篇文章'how to learn hashlib in python - by Bob'，并且这篇文章的摘要恰好和你的文章完全一致，这种情况也并非不可能出现，但是非常非常困难。
