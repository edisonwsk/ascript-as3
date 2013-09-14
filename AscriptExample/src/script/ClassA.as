package script
{
	/**
	 * 脚本类无法继承于其他对象，默认继承于Object 
	 * @author dayu
	 * 
	 */
	public class ClassA
	{
		public function ClassA()
		{
			trace(a(10));
		}
		function a(b){
			if(b>1){
				return b+a(b-1);
			}
			return 1;
		}
	}
}