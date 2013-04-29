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

package parse {
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.text.engine.BreakOpportunity;
	import flash.utils.Dictionary;

	//import util.col.Set;
	/**
       * @author dayu
       */
      public class Lex extends EventDispatcher{
            var str:String;
            var line:int;//记录当前分析的行
			var lines:Array;//
            var ptr:uint;//当前指针
            public var words:Array;//一个文件最终被分成单词。
            var word:String;//当前正在分析的串
            var ch:String;//当前字符
            var loadnew:Boolean=false;
			static public var treecach:Dictionary=new Dictionary();
			var undot:Boolean=false;//是否忽略dot
			
            function Lex(_str:String,_undot=false){
                  ptr=0;
				  undot=_undot;
				  line=0;
				  lines=[];
				  _str=_str.replace(/\r/g,"");//\r不是换行,不过如果存在的话，是个问题
				  lines=_str.split("\n");
                  words=[];
                  str=_str;
                  nextChar();
                  //brace=[];
                  while(ptr<str.length+1){
					  try{
                  			var tk:Token=getNextWord();
					  }catch(e){
						  trace(e);
					  }
                    if(tk){
	                 	// trace(tk,tk.word,words.length);
                    	if(tk.type==TokenType.keyimport){
							//tk.word=="import"
                    		//将之后的字符串处理了,作为API的成员
							 words.push(tk);
                    		 tk=getNextWord();
							 words.push(tk);
                    		 if(tk.type==TokenType.ident){
                    		 	var vname_arr:Array=tk.value;
                    		 }else{
								 parseError("导入的类不存在="+tk.word);
                    		 }
                    		 continue;
                    	}
                    	words.push(tk);
                    }
                  }
            }
	        private function skipIgnored():void {
				skipWhite();
				skipComments();
				skipWhite();
				skipComments();
				skipWhite();
			}
			
			/**
			 * Skips comments in the input string, either
			 * single-line or multi-line.  Advances the character
			 * to the first position after the end of the comment.
			 */
			private function skipComments():void {
				var br:Boolean=false;
				while ( ch == '/' ) {
					// Advance past the first / to find out what type of comment
					if(br){
						break;
					}
					nextChar();
					switch ( ch ) {
						case '/': // single-line comment, read through end of line
							var zhushi:String="";
							nextChar();
							while ( ch !='\n' && ch != '\r' ){
								zhushi+=ch;
								nextChar();
							}
							if(ch=='\n'){
								line++;
							}
							break;
						
						case '*': // multi-line comment, read until closing */
							nextChar();
							// try to find a trailing */
							while ( true ) {
								if ( ch == '*' ) {
									// check to see if we have a closing /
									nextChar();
									if ( ch == '/') {
										// move past the end of the closing */
										nextChar();
										break;
									}
								} else {
									// move along, looking if the next character is a *
									nextChar();
								}
								// when we're here we've read past the end of 
								// the string without finding a closing */, so error
								if ( ch == '' ) {
									parseError( "Multi-line comment not closed" );
								}
							}
							break;
						// Can't match a comment after a /, so it's a parsing error
						default:
							//不是注释回到起点
							ptr-=2;
							nextChar();
							var ttt=str.substr(ptr,20);
							br=true;
							break;
							//parseError( "Unexpected " + ch + " encountered (expecting '/' or '*' )" );
					}
				}
			}
			
			/**
			 * Skip any whitespace in the input string and advances
			 * the character to the first character after any possible
			 * whitespace.
			 */
			private function skipWhite():void {
				
				// As long as there are spaces in the input 
				// stream, advance the current location pointer past them
				while(isWhiteSpace(ch)){
					//trace("skip="+ch+"字符");
					if(ch=='\n'){
						line++;
					}
					nextChar();
					//trace("next="+ch+"字符");
				}
				
			}
			
			/**
			 * Determines if a character is whitespace or not.
			 *
			 * @return True if the character passed in is a whitespace
			 *	character
			 */
			private function isWhiteSpace( ch:String ):Boolean {
				return (ch==' ' || ch == '　' || ch == ' ' || ch == '\t' || ch == '\r' || ch == '\n');
			}
			private function getNextWord():Token{
            	skipIgnored();
            	var token:Token=new Token();
            	// examine the new character and see what we have...
				switch ( ch ) {
					case '{':
						token.type = TokenType.LBRACE;
						token.word = '{';
						token.value=token.word;
						nextChar();
						break
						
					case '}':
						token.type = TokenType.RBRACE;
						token.word = '}';
						token.value=token.word;
						nextChar();
						break
				
					case '(':
						token.type = TokenType.LParent;
						token.word= '(';
						token.value=token.word;
						nextChar();
						break
						
					case ')':
						token.type = TokenType.RParent;
						token.word= ')';
						token.value=token.word;
						nextChar();
						break
					case '.':
						token.type = TokenType.DOT;
						token.word = '.';
						token.value=token.word;
						nextChar();
						break
					case ';':
						token.type = TokenType.Semicolon;
						token.word = ';';
						token.value=token.word;
						nextChar();
						break
					case ',':
						token.type = TokenType.COMMA;
						token.word = ',';
						token.value=token.word;
						nextChar();
						break;
					case '-':
					case '+':
						var cc:String=ch;
						var nc:String=this.str.charAt(ptr);
						//trace(nc);
						if(nc=="="){
							token.type = TokenType.Assign;
							token.word= ch+"=";
							token.value=token.word;
							nextChar();
							nextChar();
						}else if(cc==nc){
							//++,--
							token.type = TokenType.INCREMENT;
							token.word= ch+ch;
							token.value=token.word;
							nextChar();
							nextChar();
						}else{
							token.type = TokenType.MOP;
							token.word= ch;
							token.value=token.word;
							nextChar();
						}
						break;
					case '*':
					case '/':
					case '%':
						var cc:String=ch;
						var nc:String=this.str.charAt(ptr);
						//trace(nc);
						if(nc=="="){
							token.type = TokenType.Assign;
							token.word= ch+"=";
							token.value=token.word;
							nextChar();
							nextChar();
						}else{
							token.type = TokenType.MOP;
							token.word= ch;
							token.value=token.word;
							nextChar();
						}
						break;
					case '&':
						var nc=this.str.charAt(ptr);
						if(nc=="&"){
							nextChar();
							token.type = TokenType.LOP;
							token.word = "&&";
							token.value=token.word;
							nextChar();
						}else{
							//位与
							token.type = TokenType.MOP;
							token.word= ch;
							token.value=token.word;
							nextChar();
						}
						break;
					case '|':
						var nc:String=this.str.charAt(ptr);
						if(nc=="|"){
							nextChar();
							token.type = TokenType.LOP;
							token.word = "||";
							token.value=token.word;
							nextChar();
						}else{
							//位或
							token.type = TokenType.MOP;
							token.word = ch;
							token.value=token.word;
							nextChar();
						}
						break;
					case '[':
						token.type = TokenType.LBRACKET;
						token.word = '[';
						token.value=token.word;
						nextChar();
						break
					case ']':
						token.type = TokenType.RBRACKET;
						token.word = ']';
						token.value=token.word;
						nextChar();
						break
					case ':':
						token.type = TokenType.Colon;
						token.word= ':';
						token.value=token.word;
						nextChar();
						break;
					case '!':
						nextChar();
						if(ch=="="){
							token.type = TokenType.COP;
							token.word = "!=";
							token.value=token.word;
							nextChar();
						}else{
							//逻辑非？单元操作符
							token.type = TokenType.LOPNot;
							token.word= "!";
							token.value=token.word;
						}
						break;
					case '=':
						nextChar();
						if(ch=="="){
							token.type = TokenType.COP;
							token.word = "==";
							token.value=token.word;
							nextChar();
						}else{
							token.type = TokenType.Assign;
							token.word = "=";
							token.value=token.word;
						}
						break;
					case '>':
						nextChar();
						if(ch=="="){
							token.type = TokenType.COP;
							token.word = ">=";
							token.value=token.word;
							nextChar();
						}else{
							token.type = TokenType.COP;
							token.word = ">";
							token.value=token.word;
						}
						break;
					case '<':
						nextChar();
						if(ch=="="){
							token.type = TokenType.COP;
							token.word= "<=";
							token.value=token.word;
							nextChar();
						}else{
							token.type = TokenType.COP;
							token.word = "<";
							token.value=token.word;
						}
						break;
					//字符串常量
					case '\"': // the start of a string
						token.word=readString();
						token.value=token.word;
						token.type=TokenType.constant;
						break;
					case "'": // the start of a string
						token.word=readString();
						token.value=token.word;
						token.type=TokenType.constant;
						break;
					case "#": // the start of a string
						nextChar();
						word="";
						while (isDigit(ch) || (ch>='a' && ch<='f')|| (ch>='A' && ch<='F')) {
							word+=ch;
							nextChar();
						}
						token.word=word;
						token.value=uint(parseInt(word,16));
						token.type=TokenType.constant;
						break;
					default: 
						// see if we can read a number
						if ( isDigit( ch ) || ch == '-' ) {
							//数字
							word=ch;
							nextChar();
							if(ch=="x" && word=="0"){
								//无符号的16进制数
								nextChar();
								word="";
								while (isDigit(ch) || (ch>='a' && ch<='f')|| (ch>='A' && ch<='F')) {
									word+=ch;
									nextChar();
								}
								token.word=word;
								token.value=uint(parseInt(word,16));
								token.type=TokenType.constant;
							}else{
								var ischar=false;
								
								while (ch=='_' || isDigit(ch) || ch==".") {
									if(ch=='_'){
										ischar=true;
										//shword+='_';
									}
									word+=ch;
									nextChar();
								}
								if(ischar){
									token.word=word;
									//特殊ident
									token.value=word;
									token.type=TokenType.ident;
								}else{
									token.word=word;
									//数字常量
									token.value=Number(word);
									token.type=TokenType.constant;
								}
							}
						}else if (isAlpha(ch)) {
							word=ch;
							nextChar();
							//  || ch == '.'
							while (isAlpha(ch) || isDigit(ch) || ch == '_' || ch == '/') {
								word+=ch;
								nextChar();
							}
							if(word.charAt(word.length-1)=='.'){
								parseError("ID不允许后后缀");
							}
							token.word=word;
							token.value=word.split('.');
							//trace(token.value);
							if(Token.wordpatten.indexOf("|"+word+"|")>=0){
								token.type=TokenType["key"+word];
								if(word=="new"){
									loadnew=true;
								}
							}else{
								if(token.word=="false"){
									token.type=TokenType.constant;
									token.value=false;
									token.word="false";
								}else if(token.word=="true"){
									token.type=TokenType.constant;
									token.value=true;
									token.word="true";
								}else if(token.word=="null"){
									token.type=TokenType.constant;
									token.value=null;
									token.word="null";
								}else{
									token.type=TokenType.ident;
								}
							}
						}else if ( ch == '' ) {
							// check for reading past the end of the string
							return null;
						} else {
							// not sure what was in the input string - it's not
							// anything we expected
							parseError(this.ptr+ "Unexpected " + str.substr(this.ptr) + " encountered" );
						}
				}
				return token;
            }
			private function isHexDigit( ch:String ):Boolean {
				// get the uppercase value of ch so we only have to compare the value between 'A' and 'F'
				var uc:String = ch.toUpperCase();
				
				// a hex digit is a digit of A-F, inclusive ( using our uppercase constraint )
				return ( isDigit( ch ) || ( uc >= 'A' && uc <= 'F' ) );
			}
            /**
		 * Attempts to read a string from the input string.  Places
		 * the character location at the first character after the
		 * string.  It is assumed that ch is " before this method is called.
		 *
		 * @return the JSONToken with the string value if a string could
		 *		be read.  Throws an error otherwise.
		 */
			private function readString():String {
				// the token for the string we'll try to read the string to store the string we'll try to read
				var s:String = "";
				// advance past the first "
				var mychar=ch;
				//-------------
				nextChar();
				while ( ch != mychar && ch != '' ) {
					// unescape the escape sequences in the string
					if ( ch == '\\' ) {
						// get the next character so we know what to unescape
						nextChar();
						switch ( ch ) {
							case '"': // quotation mark
								s += '"';
								break;
							case '/':	// solidus
								s += "/";
								break;
							case '\\':	// reverse solidus
								s += '\\';
								break;
							case 'b':	// bell
								s += '\b';
								break;
							case 'f':	// form feed
								s += '\f';
								break;
							case 'n':	// newline
								s += '\n';
								break;
							case 'r':	// carriage return
								s += '\r';
								break;
							case 't':	// horizontal tab
								s += '\t'
								break;
							default:
								// couldn't unescape the sequence, so just pass it through
								s += '\\' + ch;
						}
					} else {
						// didn't have to unescape, so add the character to the string
						s += ch;
					}
					// move to the next character
					nextChar();
				}
				// we read past the end of the string without closing it, which is a parse error
				if ( ch == '' ) {
					parseError( "Unterminated string literal" );
				}
				// move past the closing " in the input string
				nextChar();
				// attach to the string to the token so we can return it
				return s;
			}
            private function nextChar():String{
                  ch=str.charAt(ptr++);
                  /*汉字的unicode编码范围
                  \u4e00-\u9fa5
                  A-Z,65-90,a-z,97-122;
                  0-9,48-57*/
                  return ch;      
            }
            
           /**
		 * Determines if a character is a digit [0-9]
		 * @return True if the character passed in is a digit
		 */
			private function isDigit( ch:String ):Boolean {
				return ( ch >= '0' && ch <= '9' );
			}
            private function isAlpha(c:String){
            	var v=c.charCodeAt(0);
				if(undot &&　c=="."){
					return true;
				}
              if(v<127){
                    if((v<91 && v>64)|| (v>96 && v<123) || v==95){//小写字母//大写字母//下划线
                          return true;
                    }
              }else{
                    if(v>=0x4e00 && v<=0x9fa5){
                          return true;
                    }
              }
              return false;
            }
		private function parseError( message:String ):void {
			throw new Error("词法分析出错:"+message+"当前位置="+ ptr);
		}
      }
}
