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

package parser
{
	import flash.display.Sprite;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import parse.Lex;
	import parse.ProxyFunc;
	import parse.TokenType;
	
	import parser.GNode;
	import parser.GNodeType;
	import parser.GenTree;
	//注意事项，如果要用那个_super，仅限_super的类为动态的。
	dynamic public class DY extends Proxy{
		private var __rootnode:GenTree;
		private var _classname:String;
		private var __vars:Object;//local_vars的堆栈顶
		private var local_vars:Array;//局部变量堆栈
		private var __API:Object;
		public var _super:Object;
		function DY(clname:String="__DY",explist:Array=null){
			_classname=clname;
			__rootnode=GenTree.Branch[clname];
			local_vars=[];
			__API=GenTree.Branch[clname].API;
			__API._root=Script._root;
			__API.stage=Script._root.stage;
			for(var o in Script.defaults){
				__API[o]=Script.defaults[o];
			}
			_super={};
			init(explist||[]);//初始化字段，调用构造函数
		}
		//
		override flash_proxy function callProperty(methodName:*, ... args):* {
			if(__rootnode.motheds[methodName]){
				var f:Function=ProxyFunc.getAFunc(this,methodName);
				return f.apply(this,args);
			}else if(_super[methodName] is Function){
				return callLocalFunc(_super,methodName,args);
			}
			executeError(_classname+">SUPER "+_super+">不存在此方法="+methodName);
			return null;
		}
		override flash_proxy function getProperty(name:*):* {
			return _super[name];
		}
		override flash_proxy function setProperty(name:*, value:*):void {
			_super[name] = value;
		}
		public function get _rootnode():GenTree{
			return __rootnode;
		}
		//以下是对所有的有语意的语法进行翻译
		private function init(explist:Array){
			for each(var o:GNode in _rootnode.fields){
				if(o.nodeType!=GNodeType.FunDecl){
					executeFiledDec(o);
				}
			}
			if(__rootnode.motheds[_classname]){
				call(_classname,explist);
			}
			return null;
		}
		private function executeFiledDec(node:GNode){
			if(node.nodeType==GNodeType.AssignStm){
				//assign的第一个节点为vardecal?
				this[node.childs[0].token.word]=getValue(node.childs[1]);
			}else if(node.nodeType==GNodeType.VarDecl){
				this[node.word]=0;//默认为0
			}
		}
		var isret:Boolean=false;//函数调用是否返回
		public function call(funcname:String,explist:Array){
			var re=null;
			try{
				var node:GNode=__rootnode.motheds[funcname];
				
				if(node && node.nodeType==GNodeType.FunDecl){
					var tisret=isret;
					isret=false;
					local_vars.push({});
					__vars=local_vars[local_vars.length-1];
					var node:GNode=_rootnode.motheds[funcname];
					
					re=FunCall(node,explist);
					
					local_vars.pop();
					if(local_vars.length>0){
						__vars=local_vars[local_vars.length-1];
					}else{
						__vars=null;
					}
					isret=tisret;
				}else if(_super[funcname] is Function){
					re=callLocalFunc(_super,funcname,explist);
				}else {
					executeError(_classname+"的方法:"+funcname+" 未定义");
				}
			}catch(e:Error){
				trace(funcname+explist);
				executeError(e.toString());
			}
			return re;
		}
		
		private function FunCall(node:GNode,explist:Array) {
			//trace(classname+">stlist="+tok.word);
			if(node.nodeType==GNodeType.FunDecl){
				var param:GNode=node.childs[0];
				for(var i:int=0;i<param.childs.length;i++){
					__vars[param.childs[i].word]=explist[i];//处理局部变量
				}
				var stms:GNode=node.childs[1];
				var re=executeST(node.childs[1]);//复合语句
				return re;
			}
		}
		
		public function executeST(node:GNode){
			/*static public var AssignStm=7;//语句
			static public var IfElseStm=8;//语句
			static public var WhileStm=9;//语句
			static public var ForStm=10;//语句
			static public var ReturnStm=11;//语句
			VarDecl//
			*/
			if(node.nodeType==GNodeType.Stms){
				for(var i:int=0;i<node.childs.length;i++){
					var re:Object=executeST(node.childs[i]);
					if(isret){
						return re;
					}
				}
			}else if(node.nodeType==GNodeType.AssignStm){
				var lnode:GNode=node.childs[0];//左侧节点
				var lvarr:Array;
				if(lnode.nodeType==GNodeType.VarDecl){
					//变量声明
					if(__vars){
						lvarr=[__vars,node.childs[0].word];
					}else{
						lvarr=[this,node.childs[0].word];
					}
				}else{
					lvarr=getLValue(lnode);
					if(lvarr.length!=2){
						throw new Error("左值取值失败="+lnode.toString());
					}
				}
				//
				var rvalue=getValue(node.childs[1]);//右侧取值
				
				var lv=lvarr[0];
				if(node.word=="="){
					if(lv==this && lvarr[1]=="_super"){
						var tthis=_super;
						lv[lvarr[lvarr.length-1]]=rvalue;
						//需要把之前的对象的声明字段加进来
						for(var o in tthis){
							_super[o]=tthis[o];
						}
					}else{
						lv[lvarr[lvarr.length-1]]=rvalue;
					}
					//lv[lvarr[lvarr.length-1]]=rvalue;
				}else if(node.word=="+="){
					lv[lvarr[lvarr.length-1]]+=rvalue;
					
				}else if(node.word=="-="){
					lv[lvarr[lvarr.length-1]]-=rvalue;
					
				}else if(node.word=="*="){
					lv[lvarr[lvarr.length-1]]*=rvalue;
					
				}else if(node.word=="/="){
					lv[lvarr[lvarr.length-1]]/=rvalue;
					
				}else if(node.word=="%="){
					lv[lvarr[lvarr.length-1]]%=rvalue;
				}
			}else if(node.nodeType==GNodeType.IfElseStm){
				for(var i:int=0;i<node.childs.length;i++){
					var cn:GNode=node.childs[i];
					if(cn.nodeType==GNodeType.ELSEIF){
						var exp=getValue(cn.childs[0]);
						if(exp){
							var re=executeST(cn.childs[1]);
							if(isret){
								return re;
							}
							break;
						}
					}else{
						//stlist
						var re=executeST(cn);
						if(isret){
							return re;
						}
					}
				}
			}else if(node.nodeType==GNodeType.INCREMENT){
				var arr:Array=getLValue(node.childs[0]);
				if(arr.length==2){
					if(node.word=="++"){
						re=arr[0][arr[1]];
						arr[0][arr[1]]+=1;
						return re;
					}else if(node.word=="--"){
						re=arr[0][arr[1]];
						arr[0][arr[1]]-=1;
						return re;
					}
				}
			}else if(node.nodeType==GNodeType.PREINCREMENT){
				var arr:Array=getLValue(node.childs[0]);
				if(arr.length==2){
					if(node.word=="++"){
						arr[0][arr[1]]+=1;
						return arr[0][arr[1]];
					}else if(node.word=="--"){
						arr[0][arr[1]]-=1;
						return arr[0][arr[1]];
					}
				}
			}else if(node.nodeType==GNodeType.VarDecl){
				//除了全局初始化声明，其他的都是局部变量
				var scope=__vars || this;
				scope[node.word]=0;//默认为0
			}else if(node.nodeType==GNodeType.ReturnStm){
				if(node.childs.length>0){
					
					var re=getValue(node.childs[0]);
					isret=true;
					return re;
				}
			}else if(node.nodeType==GNodeType.FunCall){
				
				getValue(node);
			}else if(node.nodeType==GNodeType.WhileStm){
				while(getValue(node.childs[0])){
					var re=executeST(node.childs[1]);
					if(isret){
						return re;
					}
				}
			}else if(node.nodeType==GNodeType.ForStm){
				var exp1=executeST(node.childs[0]);
				//var exp2;
				while(getValue(node.childs[1])){
					var re=executeST(node.childs[3]);//进行for内部的处理
					if(isret){
						return re;
					}
					executeST(node.childs[2]);//
				}
			}else if(node.nodeType==GNodeType.ForInStm){
				var varname=node.childs[0].word;
				var obj:Object=getValue(node.childs[1]);
				//
				for(var o in obj){
					__vars[varname]=o;
					var re=executeST(node.childs[2]);//
					if(isret){
						return re;
					}
				}
			}else if(node.nodeType==GNodeType.ForEACHStm){
				var varname=node.childs[0].word;
				var obj:Object=getValue(node.childs[1]);
				for each(var o in obj){
					__vars[varname]=o;
					var re=executeST(node.childs[2]);//
					if(isret){
						return re;
					}
				}
			}
			else if(node.nodeType==GNodeType.importStm){
				//
				var arr:Array=node.word.split(".");
				__API[arr[arr.length-1]]=Script.getDef(node.word);
			}
		}
		private function getLValue(node:GNode):Array{
			if(node.gtype== GNodeType.IDENT){
				//取得左值，其实就是取得scope,vname
				var var_arr:Array=[];
				for(var i:int=0;i<node.childs.length;i++){
					if(node.childs[i].nodeType==GNodeType.Index){//索引
						var_arr.push(getValue(node.childs[i].childs[0]));
					}else{//varID
						var_arr.push(node.childs[i].word);
					}
				}
				var vname:String=var_arr[0];
				//
				var scope=null;
				var bottem:int=0;
				if(vname=="this"){
					scope=this;
					bottem=1;
				}else if(vname=="_super"){
					scope=this;
				}else{
					if(__vars && __vars[vname]!=undefined){
						scope=__vars;
					}else if(_super.hasOwnProperty(vname) || _super[vname]!=undefined){
						scope=_super;
					}else if(_rootnode.motheds[vname]){
						scope=this;
					}else if(__API[vname]){
							scope=__API;
					}else if(Script._root.loaderInfo.applicationDomain.hasDefinition(vname)){
						scope=Script.getDef(vname);// as Class;
						bottem=1;
					}
				}
				//作用域有效
				var v=scope;
				if(v){
					if(var_arr.length<bottem){
						return [v];
					}
					for(var i:int=bottem;i<var_arr.length-1;i++){
						if(v){
							v=v[var_arr[i]];
						}
					}
					if(v!=undefined){
						var lastv=var_arr[var_arr.length-1];
						//v[lastv]==undefined && 
						return [v,lastv];
					}
				}
				executeError("无法找到变量的定义="+var_arr);
			}
			return [];
		}
		public function getValue(node:GNode){
			switch(node.nodeType){
				case GNodeType.IDENT:
					//自身是
					if(node.childs.length==1){
						//快速通道,优化目的
						var vname=node.childs[0].word;
						if(__vars && __vars[vname]!=undefined){
							return __vars[vname];
						}else if(this[vname]!=undefined){
							return this[vname];
						}else if(this._rootnode.motheds[vname]!=undefined){
							return ProxyFunc.getAFunc(this,vname);
						}else if(__API[vname]!=undefined){
							return __API[vname];
						}
					}
					var arr:Array=getLValue(node);
					if(arr.length==2){
						//没有属性
						if(arr[0][arr[1]]!=undefined){
							return arr[0][arr[1]];
						}
						//可能是脚本方法
						if(arr[0] is DY && arr[0]._rootnode.motheds[arr[1]]){
							return ProxyFunc.getAFunc(arr[0],arr[1]);
						}
					}else if(arr.length==1){
						return arr[0];
					}
					return undefined;//不存在这个变量啊
					break;
				case GNodeType.VarID:
					return node.word;
				case GNodeType.ConstID:
					return node.value;
					break;
				case GNodeType.MOP:
					var v1=getValue(node.childs[0]);
					var v2=getValue(node.childs[1]);
					if(node.word=="+"){
						return v1+v2;
					}else if(node.word=="-"){
						return v1-v2;
					}else if(node.word=="/"){
						return v1/v2;
					}else if(node.word=="*"){
						return v1*v2;
					}else if(node.word=="%"){
						return v1%v2;
					}else if(node.word=="|"){
						return uint(v1)|uint(v2);
					}else if(node.word=="&"){
						return uint(v1)&uint(v2);
					}
					break;
				case GNodeType.LOP:
					var v1=getValue(node.childs[0]);
					var v2=getValue(node.childs[1]);
					if(node.word=="||" || node.word=="or"){
						return v1 || v2;
					}else if(node.word=="&&"|| node.word=="and"){
						return v1 && v2;
					}
					break;
				case GNodeType.LOPNot:
					//逻辑非
					var v1=getValue(node.childs[0]);
					return !v1;
					break;
				case GNodeType.Nagtive:
					//-
					var v1=getValue(node.childs[0]);
					return -v1;
					break;
				case GNodeType.INCREMENT:
					var arr:Array=getLValue(node.childs[0]);
					if(arr.length==2){
						var temp=arr[0][arr[1]];
						if(node.word=="++"){
							arr[0][arr[1]]=arr[0][arr[1]]+1;
						}else if(node.word=="--"){
							arr[0][arr[1]]=arr[0][arr[1]]-1;
						}else{
							executeError("解释出错=递增操作符未设置值");
						}
						return temp;
					}
					executeError("解释出错=递增操作符未设置值");
					break
				case GNodeType.PREINCREMENT:
					//----------------------
					var arr:Array=getLValue(node.childs[0]);
					if(arr.length==2){
						if(node.word=="++"){
							arr[0][arr[1]]=arr[0][arr[1]]+1;
						}else if(node.word=="--"){
							arr[0][arr[1]]=arr[0][arr[1]]-1;
						}else{
							executeError("解释出错=递增操作符未设置值");
						}
						return arr[0][arr[1]];
					}
					executeError("解释出错=递增操作符未设置值");
					break;
				case GNodeType.COP:
					var v1=getValue(node.childs[0]);
					var v2=getValue(node.childs[1]);
					if(node.word==">"){
						return v1>v2;
					}else if(node.word=="<"){
						return v1<v2;
					}else if(node.word=="=="){
						return v1==v2;
					}else if(node.word=="!="){
						return v1!=v2;
					}
					break;
				case GNodeType.newArray:
					//新数组
					if(node.childs.length>0){
						var exps:GNode=node.childs[0];
						var explist:Array=[];
						for(var i=0;i<exps.childs.length;i++){
							explist[i]=getValue(exps.childs[i]);
						}
						return explist;
					}
					return [];
				case GNodeType.newObject:
					//新数组
					if(node.childs.length>0){
						var newobj:Object={};
						for(var i=0;i<node.childs.length;i+=2){
							newobj[node.childs[i].word]=getValue(node.childs[i+1]);
						}
						return newobj;
					}
					return {};
				case GNodeType.newClass:
					var c:Class;
					var identnode:GNode=node.childs[0];
					//
					var arrr:Array=identnode.word.split(".");
					if(__API[arrr[arrr.length-1]]){
						c=__API[arrr[arrr.length-1]];
					}else if(Script._root.loaderInfo.applicationDomain.hasDefinition(identnode.word)){
						c=Script.getDef(identnode.word) as Class;
					}
					
					var explist:Array=[];
					if(node.childs.length==2){
						var param:GNode=node.childs[1];
						for(var i:int=0;i<param.childs.length;i++){
							explist[i]=getValue(param.childs[i]);
						}
					}
					if(c){
						var re;
						return newLocalClass(c,explist);
					}else{
						if(GenTree.Branch[identnode.word]){
							re=new DY(identnode.word,explist);
							//Debug.log("成功创建脚本类="+re.classname+"的实例");
							return re;
						}else{
							trace("脚本类="+identnode.word+"尚未定义");
							return null;
						}
					}
					break;
				case GNodeType.FunCall:
					//函数调用
					//2个子节点，一个是函数名，一个是参数
					var ident:GNode=node.childs[0];//
					var vname_arr:Array=[];
					for(var i:int=0;i<ident.childs.length;i++){
						if(ident.childs[i].nodeType==GNodeType.Index){
							vname_arr[i]=getValue(ident.childs[i].childs[0]);
						}else{
							vname_arr[i]=ident.childs[i].word;
						}
					}
					var explist:Array=[];
					if(node.childs.length==2){
						var param:GNode=node.childs[1];
						for(var i:int=0;i<param.childs.length;i++){
							explist[i]=getValue(param.childs[i]);
						}
					}
					var vname:String=vname_arr[0];
					if(vname_arr.length==1){
						//API部分
						if(vname=="trace" || vname=="output"){//API
							if(Script.output){
								Script.output(explist.join(","));
							}else{
								trace(explist.join(","));
							}
						}else{
							
							if(_super[vname] is Function){
								return callLocalFunc(_super,vname,explist);
							}else if(Script.defaults[vname] is Function){
								(Script.defaults[vname] as Function).apply(null,explist);
							}else if(__rootnode.motheds[vname]==undefined){
								if(Script.__globaldy._rootnode.motheds[vname]==undefined){
									//自身不存在该方法
									if(__API[vname]){
										return callLocalFunc(__API,vname,explist);
									}
									for each(var o in __API){
										if(o.hasOwnProperty(vname)){//本地方法
											return callLocalFunc(o,vname,explist);
										}
									}
									trace("类和全局都不存在该脚本方法="+vname+",是否缺少imoprt?");
								}else{
									return Script.__globaldy.call(vname,explist);
								}
							}else{
								return call(vname,explist);
							}
						}
						return;
					}
					/**/
					var scope=__vars;
					var bottom:int=0;
					if(vname=="this"){
						scope=this;
						bottom=1;
					}else{
						if(scope==null || scope[vname]==undefined){
							//字段变量
							scope=this;
							if(scope[vname]==undefined){
								//看看API是否存在相关的方法
								var loadstatic=true;
								if(__API[vname]!=undefined){
									scope=__API[vname];
									bottom=1;
									loadstatic=false;
								}
								if(loadstatic){
									//静态类，或者全局变量
									if(Script._root.loaderInfo.applicationDomain.hasDefinition(vname)){
										scope=Script.getDef(vname);
										bottom=1;
									}else if(Script.__globaldy[vname]){
										scope=Script.__globaldy;
										bottom=0;
									}
								}
							}
						}
					}
					if(scope==null){
						executeError("未定义方法="+vname);
					}
					for(var i:int=bottom;i<vname_arr.length-1;i++){
						scope=scope[vname_arr[i]];
					}
					var lastvname:String=vname_arr[vname_arr.length-1];
					//trace(scope,scope is Iterpret);
					if(scope is DY){
						re=scope.call(lastvname,explist);
						return re;
					}else{
						re=callLocalFunc(scope,lastvname,explist);
					}
					return re;
					break;
				default:
					executeError("解析出错=未知的语句");
			}
		}
		private function callLocalFunc(scope:Object,vname:String,explist:Array){
			return (scope[vname] as Function).apply(scope,explist);
		}
		private function newLocalClass(c:Class,explist:Array){//vname,
			var re;
			
			switch (explist.length){
				case 0:
					re=new c();
					break;
				case 1:
					re=new c(explist[0]);
					break;
				case 2:
					re=new c(explist[0],explist[1]);
					break;
				case 3:
					re=new c(explist[0],explist[1],explist[2]);
					break;
				case 4:
					re=new c(explist[0],explist[1],explist[2],explist[3]);
					break;
				case 5:
					re=new c(explist[0],explist[1],explist[2],explist[3],explist[4]);
					break;
				case 6:
					re=new c(explist[0],explist[1],explist[2],explist[3],explist[4],explist[5]);
					break;
				case 7:
					re=new c(explist[0],explist[1],explist[2],explist[3],explist[4],explist[5],explist[6]);
					break;
				case 8:
					re=new c(explist[0],explist[1],explist[2],explist[3],explist[4],explist[5],explist[6],explist[7]);
					break;
				default:
					executeError("解析出错=未知的语句");
			}
			return re;
		}
		private function executeError(str:String){
			trace("executeError="+str);
		}
	}
}