/*
The MIT License

Copyright (c) 2009 dayu qq:32932813

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
	public class TokenType
	{
		public var id:int;
		public function TokenType(_id:int)
		{
			id=_id;
		}
		static public var ident:TokenType=new TokenType(1);//标识符
		static public var constant:TokenType=new TokenType(2);//常量
		//
		public static var Assign:TokenType=new TokenType(3);//赋值运算符
		//
		static public var MOP:TokenType=new TokenType(4);//数学运算符
		static public var LOP:TokenType=new TokenType(5);//逻辑运算符
		
		static public var COP:TokenType=new TokenType(6);//比较运算符
		static public var INCREMENT:TokenType=new TokenType(7);//递增操作运算符
		//
		
		static public var LOPNot:TokenType=new TokenType(40);//单元逻辑运算符
		//
		static public var keyclass:TokenType=new TokenType(10);//关键字
		static public var keyimport:TokenType=new TokenType(11);//关键字
		static public var keyfunction:TokenType=new TokenType(12);//关键字
		static public var keyif:TokenType=new TokenType(13);//关键字
		static public var keyelse:TokenType=new TokenType(14);//关键字
		
		static public var keyfor:TokenType=new TokenType(15);//关键字
		static public var keywhile:TokenType=new TokenType(16);//关键字
		static public var keyvar:TokenType=new TokenType(17);//关键字
		static public var keyreturn:TokenType=new TokenType(18);//关键字
		static public var keynew:TokenType=new TokenType(19);//关键字
		static public var keyextends:TokenType=new TokenType(20);//关键字
		static public var keypackage:TokenType=new TokenType(42);//关键字
		static public var keyin:TokenType=new TokenType(43);//关键字
		//2011.9.6,添加3个关键字
		static public var keypublic:TokenType=new TokenType(44);//关键字
		static public var keyprivate:TokenType=new TokenType(45);//关键字
		static public var keyprotected:TokenType=new TokenType(46);//关键字
		//2011.9.7,添加7个关键字
		static public var keyswitch:TokenType=new TokenType(47);//关键字
		static public var keycase:TokenType=new TokenType(48);//关键字
		static public var keybreak:TokenType=new TokenType(49);//关键字
		static public var keydefault:TokenType=new TokenType(50);//关键字
		static public var keycontinue:TokenType=new TokenType(51);//关键字
		//
		static public var keytry:TokenType=new TokenType(52);//关键字
		static public var keycatch:TokenType=new TokenType(53);//关键字
		static public var keyfinally:TokenType=new TokenType(54);//关键字
		static public var keyeach:TokenType=new TokenType(55);//关键字
		//
		
		//分割符---------
		//大括号{}
		public static var LBRACE:TokenType=new TokenType(21);
		public static var RBRACE:TokenType=new TokenType(22);
		//小括号()
		public static var LParent:TokenType=new TokenType(23);
		public static var RParent:TokenType=new TokenType(24);
		//.
		public static var DOT:TokenType=new TokenType(25);
		//逗号,
		public static var COMMA:TokenType=new TokenType(26);
		//分号;
		public static var Semicolon:TokenType=new TokenType(27);
		
		//null
		public static var NULL:TokenType=new TokenType(29);
		//方括号
		public static var LBRACKET:TokenType=new TokenType(30);
		public static var RBRACKET:TokenType=new TokenType(31);
		//冒号
		public static var Colon:TokenType=new TokenType(32);
		
		//
		
	}
}