---
title: JSP基础
date: 2018-06-08 18:50
updated: 2018-06-08 18:50
tags: JAVA-Web
---
> JSP这么麻烦的东西就应该圆润地进垃圾桶！

<!-- more -->

# 1. JSP基础语法
## 1.1 JSP指令
- page：页面顶端，可有多个
- include：将外部文件嵌入当前jsp文件并解析
- taglib：使用标签库自定义的标签

## 1.2 JSP脚本、声明、表达式
```
<% java脚本代码%>
<%! Java代码%>//定义方法和变量，写入到
<%=表达式 %>//表达式不以分号结束
```

## 1.3 JSP页面生命周期
```flow
1=>start: 用户第一次发出请求index.jsp
2=>condition: 是否第一次请求
3=>operation: JSP引擎把该JSP文件转换成一个servlet，
生成字节码文件并执行jspInit()
4=>operation: 访问生成的字节码文件
5=>end: 解析执行，jspService()

1->2->3->5
2(yes)->3
2(no)->4->5
```
jspService()方法被调用来处理客户端请求。一请求一线程。

## 1.4 JSP四种范围对象的作用域
作用域范围从小到大顺序：
pageContext--request--session--application
 
其中：
**pageContext：**
作用域仅限于当前页面对象，可以近似于理解为java的this对象，离开当前JSP页面（无论是redirect还是forward），则pageContext中的所有属性值就会丢失。
**request：**
作用域是同一个请求之内，在页面跳转时，如果通过forward方式跳转，则forward目标页面仍然可以拿到request中的属性值。如果通过redirect方式进行页面跳转，由于redirect相当于重新发出的请求，此种场景下，request中的属性值会丢失。
**session：**
session的作用域是在一个会话的生命周期内，会话失效，则session中的数据也随之丢失。
**application：**
作用域是最大的，只要服务器不停止，则application对象就一直存在，并且为所有会话所共享。

# 2. JSP内置对象
 1. out
 2. request
 3. response
 4. session
 5. application
 6. Page
 7. pageContext
 8. exception
 9. config

## 2.1 out
缓冲区：Buffer，用碗吃饭
out对象：JspWriter类的实例
常用方法：
1. void println()向客户端打印字符串
2. void clear()清除缓冲区内容，在flush后使用会抛出异常
3. void clearBuffer()不抛异常
4. void flush()结算缓冲区内容到客户端
5. int getBufferSize()返回缓冲区字节大小，不设则为0
6. int getRemaining()返回缓冲区剩余空间
7. boolean isAutoFlush()返回缓冲区满时，是自动清空还是抛出异常
8. void close()关闭输出流

## 2.2 request
- 客户端请求封装在request对象中，通过它才能了解到客户的需求，然后做出响应。
- 它是HttpServletRequest类的实例。
- request对象具有请求域，即完成客户端的请求之前一直有效。

- request常用方法：
    1. String getParamenter(String name) 返回name指定参数的参数值
    2. String[] getParameterValues(String name)返回包含参数name的所有返回值
    3. void setAttribute(String,Object) 存储此请求中的属性
    4. object getAttribute(String name) 返回指定属性的属性值
    5. String getContentType() 得到请求体的MIME属性
    6. String getProtocol 返回请求用的协议类型及版本号
    7. String getServerName() 返回接受请求的服务器主机
    ```
    在作用域里设置键值对<%request.setAttribute("pwd","123456"); %>
    获取密码：<%=request.getAttribute("pwd") %><br>
    请求体的MIME类型：<%=request.getContentType() %><br>
    协议类型及版本号：<%=request.getProtocol() %><br>
    服务器主机名：<%=request.getServerName() %><br>
    服务器端口号：<%=request.getServerPort() %><br>
    请求文件的长度：<%=request.getContentLength() %><br>
    请求客户端的IP地址：<%=request.getRemoteAddr() %><br>
    <!--只能获取静态的IP地址，动态的话获取不到-->
    请求的真实路径：<%=request.getRealPath("request.jsp") %><br>
    请求的上下文路径：<%=request.getContextPath() %><br>
    
    ```
- 中文乱码问题：
    post表单提交：request.setCharacterEncoding("utf-8");
    URL传参：修改server.xml文件

