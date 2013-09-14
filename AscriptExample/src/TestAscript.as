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
	 * 其中用到了Tweenlite,请自行下载并引用该类库
	 * ascript类库也请自行编译引用
	 * 因为新版的ascript类库兼容脚本的动态加载，使用了文件系统,需要引入air类库，同时定义编译参数:-define=CONFIG::air,true
	 * @author dayu
	 * 2013.9.14
	 */	
	public class TestAscript extends Sprite
	{
		public function TestAscript()
		{
			//初始化脚本环境,
			Script.init(this,null);
			//所有script目录下的as文件为ascript脚本文件和as3文件基本兼容，因此你可以用as3的编辑器进行书写
			//享受充分的语法提示
			//然而当你需要对其按脚本运行的时候,你必须将其copy到发布目录下,如 bin-debug
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