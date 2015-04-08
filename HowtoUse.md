# 使用AScript前的准备 #

使用AScript仅需要简单的几个步骤。首先要将AScript.swc包含到项目库路径。

如果您对这部分内容非常熟悉，可直接进入下一部分：初始化脚本引擎
## Flash Builder中的配置 ##
在需要使用AScript的项目右键，选择属性，打开项目属性面板，进行如下设置。将AScript.swc添加到项目的库路径。

![http://farm3.staticflickr.com/2881/9310586483_c4c851b988_o.jpg](http://farm3.staticflickr.com/2881/9310586483_c4c851b988_o.jpg)

# 初始化脚本引擎 #
通过以下代码初始化脚本引擎。注意参数`root`需要指向文档类实例。
```
Script.init(root);
```
推荐您使用AScript2.0版本，因为AScript1.2版本存在一些问题。
如果您想采用1.2版本，具体帮助请参考http://ascript.softplat.com/
# 执行AScript代码 #
ascript的执行需要依赖as。让我们通过FlashBuilder来示范一个例子。
我们先写一行非常简单的AScript代码。谨记AScript和ActionScript非常相似。比如下面的代码，和ActionScript一模一样。
```
trace("I am AScript!!!");
```
想要执行这行代码，需要将这行代码变为String类型的字符串，然后在含有AScript.swc的项目内通过Script.execute方法执行。
```
Script.execute("trace('I am AScript!!!');");
```
可以在output窗口看到trace语句执行的结果，输出了一段话I am AScript!!!。
至此您可以开始体验AScript的各种特性。
更多内容请访问APIReference