---
title: IDEA使用技巧
date: 2019-03-27 23:29:06
tags: IDE
---

<script>
  var head = document.getElementsByTagName('head')[0];
  var css = "<style>.article img{width: 100%;}</style>";
  head.innerHTML+=css;
</script>
# 一、后缀补全
<!-- more -->

这个功能可以使用代码补全来模板式地补全语句，如遍历循环语句（for、foreach）、使用 String.format() 包裹一个字符串、使用类型转化包裹一个表达式、根据判（非）空或者其它判别语句生成 if 语句、用 instanceOf 生成分支判断语句等。

使用的方式也很简单，就是在一个表达式后按下点号 . ，然后输入一些提示或者在列表中选择一个候选项，常见的候选项下面会给出 GIF 演示。

### 1、var 声明
{% asset_img 1.gif %}
### 2、null 判空
{% asset_img 2.gif %}
### 3、notnull 判非空
{% asset_img 3.gif %}
### 4、nn 判非空
{% asset_img 4.gif %}
### 5、for 遍历
{% asset_img 5.gif %}
### 6、fori 带索引的遍历
{% asset_img 6.gif %}
### 7、not 取反
{% asset_img 7.gif %}
### 8、if 条件判断
{% asset_img 8.gif %}
### 9、cast 强转
{% asset_img 9.gif %}
### 10、return 返回值
{% asset_img 10.gif %}
