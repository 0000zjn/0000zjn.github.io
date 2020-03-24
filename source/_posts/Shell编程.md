---
title: Shell编程问题笔记
date: 2019-08-05
updated: 2019-08-13
tags: Shell
---

# 1. 获取指定第几个正则匹配结果

<!-- more -->

MAC环境下不支持 r 参数
`sed -nr "s/$RLV_REG/\2/p" filename`
可使用 -E 代替
`sed -n -E "s/$RLV_REG/\2/p" filename`

# 2. 正则修改文件内容

MAC环境下的bash不支持 `sed -i "REG" filename` 来直接修改文件内容。
`-i tmp` 在MAC下指添加备份后缀 `.tmp`，作用与下文行2相同。

通用解决方案：
```
# 把结果保存到新的文件，再把文件重命名来覆盖原文件
sed 's/\"API_VERSION\"/'${tagName}'/' filename > filename.tmp
mv filename.tmp filename
```