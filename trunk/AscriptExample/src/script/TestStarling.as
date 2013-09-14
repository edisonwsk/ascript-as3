package script
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;

	public class TestStarling
	{
		var view:Sprite;
		var mBrush:Image;
		private var mRenderTexture:RenderTexture;
		public function TestStarling(_sp:Sprite)
		{
			view=_sp;
			view.addEventListener(Event.ADDED_TO_STAGE, onAdded); 
			
		}
		public function onAdded (e:Event):void 
		{
			// TODO Auto Generated method stub
			// create a Bitmap object out of the embedded image 
			var brush:BitmapData=new BitmapData(32,32,true,0xffff0000); 
			// create a Texture object to feed the Image object 
			var texture:Texture = Texture.fromBitmapData(brush); 
			//view.addChild(new Image(texture));
			// create the texture to draw into the texture 
			mBrush = new Image(texture); 
			// set the registration point 
			mBrush.pivotX = mBrush.width >> 1; 
			mBrush.pivotY = mBrush.height >> 1; 
			// scale it 
			//mBrush.scaleY = 0.5;
			//mBrush.scaleX = 0.5;
			// creates the canvas to draw into 
			mRenderTexture = new RenderTexture(view.stage.stageWidth, view.stage.stageHeight,true);
			// we encapsulate it into an Image object 
			var canvas:Image = new Image(mRenderTexture); 
			// show it 
			view.addChild(canvas); 
			// listen to mouse interactions on the stage 
			view.stage.addEventListener(TouchEvent.TOUCH, onTouch); 
		} 
		private function onTouch(event:TouchEvent):void 
		{
			// retrieves the entire set of touch points (in case of multiple fingers on a touch screen) 
			var touches = event.getTouches(view); 
			for each (var touch:Touch in touches) 
			{ 
				// if only hovering or click states, let's skip 
				if (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.ENDED){
					continue; 
				}
				// grab the location of the mouse or each finger 
				var location:Point = touch.getLocation(view); 
				// positions the brush to draw 
				mBrush.x = location.x; 
				mBrush.y = location.y; 
				//mRenderTexture.clear();
				// draw into the canvas 
				mRenderTexture.draw(mBrush); 
			} 
		} 
	}
}