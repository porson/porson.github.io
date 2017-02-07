---
title: Go语言自制简易WebServer
date: 2017-02-07 11:12:44
tags: Golang
---
{%cq%}
姿势：如何自己搭建一个简易WebServer。
{%endcq%}

<!-- more -->

```go
package main

import (
	"fmt"
	"log"
	"net/http"
	"strings"
)

func sayhelloName(w http.ResponseWriter, r *http.Request) {
	// 解析参数,默认是不会解析的
	r.ParseForm()
	// 这些信息是输出到服务器端的打印信息
	fmt.Println(r.Form)

	// 获取输入的URL地址
	fmt.Println("path", r.URL.Path)
	//fmt.Println("scheme", r.URL.Scheme)

	// 获得传递的参数
	fmt.Println(r.Form["url_long"])
	for k, v := range r.Form {
		fmt.Println("key:", k)
		fmt.Println("val:", strings.Join(v, ","))
	}

	// 返回结果
	fmt.Fprintf(w, "Hello 李鹏翔!") // 这个写入到 w 的是输出到客户端的
}
func main() {
	// 设置访问的路由
	http.HandleFunc("/", sayhelloName)        
	// 设置监听的端口10160	
	err := http.ListenAndServe(":10160", nil) 

	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
```

Go语言实现WebServer是一件非常容易的事情。

通过这个简单的WebServer我们可以很轻松的实现REST接口。

那你也许就会问,我们的nginx、apache服务器不需要吗？Go就是不需要这些，因为他直接就监听tcp端口了，做了nginx做的事情，然后sayhelloName这个其实就是我们写的逻辑函数了，其实就是controller。
