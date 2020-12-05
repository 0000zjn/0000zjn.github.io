---
title: Git笔记
date: 2019-06-04 15:53
updated: 2020-05-16
tags: 版本控制
---

# 1. 修改commit

<!-- more -->

当commit遇到这两种需求：
1. 修改上次commit的Message
2. 当前add合并到上次的commit
git commit --amend

# 2. 常用git别名设置：

```
git config --global alias.co checkout
git config --global alias.a add
git config --global alias.s 'status -s'
git config --global alias.ps push
git config --global alias.pl pull
git config --global alias.pr 'pull --rebase'
git config --global alias.cm 'commit -m'
git config --global alias.ca 'commit --amend'
git config --global alias.rh 'reset HEAD'
git config --global alias.si 'submodule init'
git config --global alias.su 'submodule update --remote'
git config --global alias.br 'branch'
git config --global alias.spm 'stash push -m'
git config --global alias.sl 'stash list'
git config --global alias.sa 'stash apply'
git config --global alias.sd 'stash drop'
git config --global alias.sc 'stash clear'
git config --global alias.comd '!git checkout master && git merge develop && git push && git checkout develop'
```

显示：

```
git config --global -l
```

删除：

```
git config --global --unset alias.
```

# 3. rebase

git pull时可以加上--rebase参数，使之不产生Merge点，保证了代码的整洁:
`git pull --rebase`
把它设置为默认操作：
git config --global pull.rebase true

如果在rebase的过程中有冲突，这时Git会停止rebase并让用户去解决冲突。解决完冲突后，用`git add`命令去更新这些内容，然后不用执行`git -commit`，直接执行`git rebase --continue`，这样git会继续apply余下的补丁。

git rebase --abort 会回到rebase操作之前的状态，之前的提交的不会丢弃；

git rebase --skip 则会将引起冲突的commits丢弃掉；

# 4. 换行符

文本文件所使用的换行符，在不同的系统平台上是不一样的。UNIX/Linux 使用的是 `0x0A(LF)`，早期的 Mac OS 使用的是 `0x0D(CR)`，后来的 OS X 在更换内核后与 UNIX 保持一致了。但 DOS/Windows 一直使用 `0x0D0A(CRLF)` 作为换行符。

跨平台协作开发是常有的，不统一的换行符确实对跨平台的文件交换带来了麻烦。最大的问题是，在不同平台上，换行符发生改变时，Git 会认为整个文件被修改，这就造成我们没法 diff，不能正确反映本次的修改。还好 Git 在设计时就考虑了这一点，其提供了一个 autocrlf 的配置项，用于在提交和检出时自动转换换行符，该配置有三个可选项：

- true: 提交时转换为 LF，检出时转换为 CRLF
- false: 提交检出均不转换
- input: 提交时转换为LF，检出时不转换

用如下命令即可完成配置：
```
# 提交时转换为LF，检出时转换为CRLF
git config --global core.autocrlf true

# 提交时转换为LF，检出时不转换
git config --global core.autocrlf input

# 提交检出均不转换
git config --global core.autocrlf false
```
如果把 `autocrlf` 设置为 false 时，那另一个配置项 `safecrlf` 最好设置为 ture。该选项用于检查文件是否包含混合换行符，其有三个可选项：

- true: 拒绝提交包含混合换行符的文件
- false: 允许提交包含混合换行符的文件
- warn: 提交包含混合换行符的文件时给出警告

配置方法：
```
# 拒绝提交包含混合换行符的文件
git config --global core.safecrlf true

# 允许提交包含混合换行符的文件
git config --global core.safecrlf false

# 提交包含混合换行符的文件时给出警告
git config --global core.safecrlf warn
```

# 5. Git add 参数解析：

git add -A  提交所有变化，不限于当前目录
git add -u  提交被修改(modified)和被删除(deleted)文件，不包括新文件(new)
git add .   提交新文件(new)和被修改(modified)文件，不包括被删除(deleted)文件，仅限当前目录

# 6. 拉取远程分支到本地并切换到此分支：

老（可以本地自定义名字）：

```
git checkout -b dev origin/develop
```

新（简化）：

````
git checkout --track origin/develop
````

再简化：

````
git checkout -t origin/develop
````
