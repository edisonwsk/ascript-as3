package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import parser.Script;
	
	import starling.core.Starling;

	/**
	 * 这个例子仅仅是作为acript使用的一个例子
		重要:
		 1.用到了Tweenlite,Starling,请自行下载并引用这2个类库
		 2.ascript类库也请自行编译为swc引用
		 3.例子中script目录下的as文件将作为ascript脚本运行，不过你可以在开发的时候忽略掉这一点,
		 用熟悉的as3的语法编写,享受充分的语法提示和错误提示
		 4,当你编写完成,需要对其按脚本运行的时候,则必须将其复制到发布目录下,如 bin-debug/script
		 5.新版的ascript类库使用了文件系统,需要引入air类库，同时定义条件编译参数:-define=CONFIG::air,true
	 * @author dayu
	 * 2013.9.14
	 */	
	public class TestAscript extends Sprite
	{
		public function TestAscript()
		{
			//初始化脚本环境,
			Script.init(this,null);
			//
			//------------以下为测试
			//新建一个脚本类,返回一个脚本类的实例对象p
			var p=Script.New("ClassA");
			var t=getTimer();
			trace(p.a(100));//100次的递归函数调用
			trace("耗时="+(getTimer()-t));//耗时计算
			//
			TweenLite.defaultEase=Linear.easeNone;
			//测试显示对象+TweenLite;
			
			//创建100个随机运动的小球
			for(var i=0;i<100;i++){
				Script.New("TestTweenLite",this);
			}
			//是的，你会看到脚本的效率并不低
			
			//接下来我们测试下最热的starling
			//开启后可以在屏幕上进行绘制
			starling();
		}
		private var mStarling:Starling;
		public function starling(){
			stage.align = StageAlign.TOP_LEFT;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;   
			Starling.handleLostContext = true;
			Starling.multitouchEnabled=true;
			// create our Starling instance   
			mStarling = new Starling(StarlingRoot, stage); 
			//mStarling.simulateMultitouch=true;
			// set anti-aliasing (higher the better quality but slower performance)   
			mStarling.antiAliasing = 2; 
			mStarling.showStats=true;
			// start it!  
			//initGestrue();
			//
			mStarling.start();
			
		}
	}
}