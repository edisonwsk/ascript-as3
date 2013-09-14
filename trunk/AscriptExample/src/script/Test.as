package script
{
	import flash.display.Sprite;
	import flash.utils.getTimer;
	/**
	 * 脚本类无法继承于其他对象，默认继承于Object 
	 * @author dayu
	 * 
	 */
	public class Test
	{
		var sp:Sprite;
		public function Test()
		{
			sp=new Sprite();
		}
		function add(){
			var st=getTimer();
			sp.x++;
			a(20);
			trace("耗时="+(getTimer()-st));
		}
		function a(b){
			if(b>1){
				return b+a(b-1);
			}
			return 1;
		}
	}
}