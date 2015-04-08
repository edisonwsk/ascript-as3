# 总是执行不过？各种提示等等 #

首先确保Ascript文件的路径正确/是最新的，在实际开发过程中，有时候为了代码提示和类型检查会把Ascript放到项目文件里，但是输出的文件在bin-debug或者其他目录，就会找不到文件，如果有运行时错误，请先检查Ascript文件是否存在/是否是最新的。

# Ascript是否支持继承？ #

Ascript不支持继承，但是Ascript类的实例有一个\_super属性，可以通过instanceB.super=instanceA来实现调用父类的接口和属性，这里是B继承自A。下面的示例建立了一个AscriptClass类的实例ascriptIns，指定ascriptIns的父类是Math类：

```
...初始化脚本引擎...
...加载Ascript类文件...
var ascriptIns:Object=Script.New("AscriptClass");
ascriptIns._super=new Sprite;
trace(ascriptIns.x);
```

**注意：继承的功能没有经过太多的测试，请谨慎使用。**

# Ascript获得不了as3自定义类 #

Ascript通过反射机制来查找类。如果主程序没有引用这个类，则脚本找不到对应的类的引用。因此需要在程序中至少引用一次在脚本中需要调用的类。一个好的解决方案是，在as3主程序里声明一个变量：
```
var importArr:Array=[ClassA,ClassB...ClassN];
```
强制编译器引入这些类。