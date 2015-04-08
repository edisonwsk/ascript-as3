# AScript起航 #

AScript的使用非常简单，因为它和ActionScript几乎完全一样，并且运行于as上。
关于如何运行AScript和初始化脚本引擎，请参考HowtoUse。
## 变量 ##
### 局部变量 ###
AScript的变量声明方式如下
```
var aaa=2;
```
AScript本身是不对变量类型进行检查的，但是可以在声明变量的时候声明类型，比如
```
var aaa:int=2;
```
AScript会自动忽略冒号后面的类型。虽然AScript不会对代码进行类型检查，但是仍然建议您写上变量的类型，由于AScript和as几乎一摸一样，所以通常情况下可以使用flash builder或其他ide书写代码，写上变量的类型可以减少警告，并可以利用ide的类型检查进行一定程度上的检查。
### 全局变量 ###
可以在as3的代码中指定全局变量，然后在AScript里调用。如下：
```
Script.vm.aaa=12;
Script.execute("trace(aaa);");//输出为12
```
和as一样局部变量如果和全局变量重名会优先调用局部变量。
```
Script.vm.aaa=12;
Script.execute("var aaa:int=2;trace(aaa);");//输出为2
```
还有一种特殊的方式可以创建全局变量。Script.init接受的第二个可选参数是一个AScript类文件（关于AScript的类的详细信息可以参考本章余下的章节）。脚本引擎初始化的时候会自动创建该类的实例，并且将Script.vm指向这个类的实例。在类中定义的变量也就成了全局变量。
```
Script.init(this,"class Cla{var aaa=12}");
Script.execute("trace(aaa);");//输出12
trace(Script.vm.aaa);//输出12
```
运行上面的代码，可以在output窗口看到一段描述文字，如下：
```
脚本类:Cla解析完成,可以创建其实例了
脚本类:__DY解析完成,可以创建其实例了
```
这表示脚本引擎的初始化。
## 函数 ##
下面的例子定义了一个AScript函数Add，并在ActionScript中调用它。
```
Script.declare("function Add(a,b){return a+b;}");
var func:Function=Script.getFunc("Add");
trace(func(200,200));//将输出400
```
## 类 ##
AScript的特色之一是可以定义类。并且定义类的方式和as3非常相似。
下面的代码定义了一个AScript类。
```
class Cla{
   var aaa=12;
   function Add(){
      aaa++;
   }
}
```
同变量一样，你可以给使用as3的类修饰符，但是AScript会自动忽略这些类修饰符。在AScript类里定义的变量aaa默认是public的，并且不能修改。类中定义的方法也一样。

关于Ascript类的更多操作，可以查看WorkwithAS3。详细讲解了Ascript和as3的交互。