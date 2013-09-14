package script
{
	import com.greensock.TweenLite;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * 脚本类无法继承于其他对象，默认继承于Object 
	 * 但是脚本类可以创建任何其他as3和脚本对象,当然包括显示对象
	 * 这个例子使用了Tweenlite
	 * @author dayu
	 * 
	 */
	public class TestTweenLite
	{
		var box:Shape;
		var scene:Sprite;
		public function TestTweenLite(sc:Sprite)
		{
			scene=sc;
			box=new Shape();
			box.graphics.beginFill(0x0,1);
			box.graphics.drawCircle(0,0,20);
			scene.addChild(box);
			TweenLite.to(box,1,{x:Math.random()*550,y:Math.random()*550,onComplete:oncom});
		}
		function oncom(){
			TweenLite.to(box,1,{x:Math.random()*550,y:Math.random()*550,onComplete:oncom});
		}
	}
}