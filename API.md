自ascript2.0.1版本以来，ascript缩减了可见的公共变量和方法，使得as3和ascript的交互更加简单和集中。下面将具体说明各个变量和方法的使用。

# 公共变量 #

## Script.root ##
Script.root默认指向Script.init时传入的第一个参数，当然你也可以动态指定Script.root的值并在代码的任何地方访问它。

## Script.scriptdir ##
该变量定义了脚本默认的加载地址，默认地址为script/，可以手动定义成其他地址，在查找相关的类文件时会根据scriptdir来加载类文件，比如在某个Ascript类里import了一个包的操作。

## Script.vm ##
vm上保存了脚本的全局函数和全局变量。关于全局变量的定义可以参考[gettingStarted](gettingStarted.md)


# 公共方法 #

## Script.init ##