ascript和as3几乎是无缝结合的，您可以从ascript调用as3的接口（包括自定义类的接口），也可以从as3的代码里调用ascript的接口。

# Ascript类调用as3的接口 #

ascript调用as3的接口就像as3与as3的交互一样简单。下面这个例子演示了如何在Ascript类里调用as3的Math类，并把Math的一个属性赋值给Ascript类里的一个变量。

```
//这是一个Ascript类
package script
{
    public class AscriptClass
    {
        /**
         * pi值 
         */
        public var pi:Number;
        public function AscriptClass()
        {
            pi=Math.PI;
            trace("PI is "+pi);
        }
    }
}
```
想要运行上面的Ascript类的代码，需要在as3里进行下面的步骤：
  1. 初始化脚本引擎，关于如何初始化脚本引擎，请参考gettingStarted
  1. 将含有Ascript的文本文件加载进来到脚本引擎里。
  1. 在脚本引擎里初始化一个AscriptClass类的实例。

具体的as3代码如下：

```
package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import parser.Script;
    //项目的文档类
    public class AscriptTest extends Sprite
    {

        private var loader:URLLoader;
        public function AscriptTest()
        {
            loader=new URLLoader;
            loader.addEventListener(Event.COMPLETE,onLoadScriptComplete);
            loader.load(new URLRequest("script/AscriptClass.as"));
        }
        
        protected function onLoadScriptComplete(event:Event):void
        {
            var data:String=loader.data as String;
            Script.init(this);
            Script.LoadFromString(data);
            Script.execute("var ascriptIns=new AscriptClass();");
        }
    }
}
```

可以看到输出面板输出了以下内容

```
脚本类:__DY解析完成,可以创建其实例了
脚本类:AscriptClass解析完成,可以创建其实例了
PI is 3.141592653589793
成功创建脚本类=AscriptClass的实例
```

其中第1,2,4行的输出是脚本引擎自己的输出，第3行是我们的AscriptClass的构造函数的输出。

注意，Ascript调用as3的类或者是自定义的as3类，必须import。在早期的Ascript不支持按需类型导入的语法，Ascript2.0开始支持按需类型导入。

# as3调用Ascript的接口 #

在上面的例子里，我们始终是通过as3在执行Ascript代码，假如我们需要把某些内容从Ascript传递给as3呢？as3调用Ascript分别为调用Ascript定义的变量，Ascript的函数，以及实例化Ascript的类。

## as3调用Ascript变量 ##

让我们假想一个更具体的应用环境，假如我们用Ascript作配置文件（实际上我们的很多项目用Ascript来做配置文件），我们需要在as3里访问Ascript文件里配置的变量。假设我们有一个Ascript做的配置文件如下：

```
//Ascript文件 Config.as
var assetsURL:String="assets/";
var author:String="dayu";
var email:String="xiaoxiaosh01@gmail.com";
```

在上面的Ascript代码里，三个变量定义在脚本的最外层，也可以看做是脚本的全局变量。在as3里可以通过Script.vm访问到脚本的全局变量。下面的as3代码完整的显示了如何加载Ascript的文件并访问Ascript代码里的author变量。

```
package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import parser.Script;
    
    public class AscriptTest extends Sprite
    {

        private var loader:URLLoader;
        public function AscriptTest()
        {
            loader=new URLLoader;
            loader.addEventListener(Event.COMPLETE,onLoadScriptComplete);
            loader.load(new URLRequest("script/Config.as"));
        }
        
        protected function onLoadScriptComplete(event:Event):void
        {
            var data:String=loader.data as String;
            Script.init(this);
            Script.execute(data);
            trace(Script.vm.author);
        }
    }
}
```

## as3调用Ascript函数 ##

继续上面的例子，在Config.as里增加一个函数。Config.as变成：

```
//Ascript文件 Config.as
var assetsURL:String="assets/";
var author:String="dayu";
var email:String="xiaoxiaosh01@gmail.com";
function GetAuthorInfo():String{
    return "author："+author+" email:"+email;
}
```

as3里想要调用Ascript的GetAuthorInfo方法的时候，请按照下面的代码进行操作。这里省略了初始化脚本引擎以及加载Config.as文件的代码。

```
...初始化脚本引擎...
...加载Config.as...
var func:Function=Script.getFunc("GetAuthorInfo");
trace(func());
```

## as3里实例化Ascript类 ##

能够定义类是Ascript的特点之一。假如我们的方法和变量写在一个Ascript类里，我们想要访问Ascript类里定义的变量和方法，就需要先实例化这个类。

我们继续使用AscriptClass这个类，给它增加一个方法AscriptMethod。这个方法会返回传给它的两个参数之间比较大的一个。

```
//完整的AscriptClass代码
package script
{
    public class AscriptClass
    {
        /**
         * pi值 
         */
        public var pi:Number;
        public function AscriptClass()
        {
            pi=Math.PI;
            trace("PI is "+pi);
        }
        public function AscriptMethod(a:Number,b:Number):Number{
            return Math.max(a,b);
        }
    }
}
```

**注意：Ascript类不支持类方法和类变量。但是写static修饰符并不会报错，实际上脚本解释器会自动忽略变量和方法的修饰符，因此所有的变量和方法实际上都是public的**

想要在as3里调用AscriptClass的AscriptMethod方法，需要先实例化AscriptClass。

```
package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import parser.Script;
    
    public class AscriptTest extends Sprite
    {

        private var loader:URLLoader;
        public function AscriptTest()
        {
            loader=new URLLoader;
            loader.addEventListener(Event.COMPLETE,onLoadScriptComplete);
            loader.load(new URLRequest("script/AscriptClass.as"));
        }
        
        protected function onLoadScriptComplete(event:Event):void
        {
            var data:String=loader.data as String;
            Script.init(this);
            Script.LoadFromString(data);
            var ascriptIns:Object=Script.New("AscriptClass");
            trace(ascriptIns.AscriptMethod(120,110));
        }
    }
}
```

运行上面的代码，可以在输出窗口看到输出了120。