/*
The MIT License

Copyright (c) 2009 作者:dayu qq:32932813

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

http://code.google.com/p/ascript-as3/
http://ascript.softplat.com/
*/       

package parse
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import parser.DY;
	
	public class ProxyFunc
	{
		static var dics:Dictionary=new Dictionary();
		static public function getAFunc(_it:DY,fn:String):Function{
			if(!dics[_it]){
				dics[_it]=new Dictionary();
			}
			if(!dics[_it][fn]){
				dics[_it][fn]=new ProxyFunc(_it,fn);
			}
			return dics[_it][fn].Func;
		}
		//
		var it:DY;//首先明确是哪个脚本类的哪个方法
		var funcname:String;//这是it监听函数名。
		public function ProxyFunc(_it:DY,fn:String)
		{
			it=_it;
			funcname=fn;
		}
		public function Func(...args){
			try{
				return it.call(funcname,args);
			}catch(e:Error){
				trace(e.getStackTrace());
			}
		};

	}
}