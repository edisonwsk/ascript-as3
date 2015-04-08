## ascript交流QQ群:264282406 ##

# 什么是Ascript #

一个as3写的脚本解释器，动态解释执行as3代码。

Ascript是一种解释型脚本语言,用as3实现,并且能和as3无缝结合的一种动态执行的脚本,无需编译.即可执行。

Ascript并不想帮你编写大量的代码,Ascript让你用少量的代码解决动态数据和动态逻辑配置等问题。

Ascript是一个小巧而嵌入式的语言,可以帮助你测试自己的API,语法和其母语as3基本相同,会方便任何熟悉此类语言的人轻易使用,实际上,这个语言能直接运行大部分as3类.

## 2013年12月2日 发布Ascript2.0.2 ##

更新内容：

去掉代码中大部分的警告

语句结束时允许省略分号

<font color='#ff0000'><i><b>由于google code不再允许更新下载，请移步<br>
<a href='https://github.com/softplat/ascript'>https://github.com/softplat/ascript</a>
访问最新的源码</b></i></font>


## 2013年11月11日 发布Ascript2.0.1 ##

更新内容：

整理能够开放的接口，去掉不需要开放的接口

去掉代码中一部分的警告

去掉编译参数设置

修正函数返回的参数类型

修复bug:

修复了在ascript内取as3中写在vm上的变量的一个bug

## 2013年10月29日 迁移到github ##

https://github.com/softplat/ascript

<font color='#ff0000'><i><b>google code项目的源代码将不再更新，仅更新下载和wiki部分</b></i></font>


## 2013年10月28日 增加文档 ##

在wiki里增加了Ascript和as3交互的文档[WorkwithAS3](WorkwithAS3.md)


## 2013年10月27日 重要说明 ##
ascript.softplat.com此处的教程写于2011年，是针对ascript1.0的版本。
新版的ascript2.0支持以下语法:
  * if,else,if else,switch,for,for in,for each,is,while,break,continue,return.
  * 支持大部分运算符。不支持3元运算符。
  * 语法上不支持set,get属性和匿名函数，不支持Vector。
  * ascript性能和as3差距较大，所以底层尽量还是用as3。
ascript适用做逻辑层需要动态更新的东西。包括ios平台的动态逻辑部署,新手引导,任务,还有一个比较不错的用途是在线教程，可以直接允许用修改代码立即看结果。