package
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	
	import parser.Script;
	
	import script.TestStarling;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	public class StarlingRoot extends Sprite
	{
		private var mRenderTexture:RenderTexture; 
		private var mBrush:Image; 
		var teststarling;
		public function StarlingRoot() 
		{ 
			//as3执行模式
			var useScript=true;
			if(useScript){
				//脚本执行模式,加载的脚本执行
				teststarling=Script.New("TestStarling",this);
			}else{
				//as3编译执行模式
				teststarling=new TestStarling(this);
			}
			
		}
		
	}
}