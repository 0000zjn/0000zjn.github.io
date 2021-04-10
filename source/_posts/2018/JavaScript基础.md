---
title: JavaScript基础
date: 2018-07-13 14:48
updated: 2018-07-13 14:48
tags: JS
---
> 重学JavaScript时做的笔记。JS的语法真的是让人又爱又恨~
# 1. Sundry
- switch()参数可为多种类型
- 标签：
    ```
    outerloop:
    for (var i = 0; i < 10; i++)
    {
        innerloop:
        for (var j = 0; j < 10; j++)
        {
            if (j > 3)
            {
                break;
            }
            if (i == 2)
            {
                break innerloop;//跳过了i=2的情况
            }
            if (i == 4)
            {
                break outerloop;//i=4时结束
            }
            document.write("i=" + i + " j=" + j + "");
        }
    }
    ```

<!-- more -->

- constructor 属性返回变量的构造函数的原型
    ```
    (3.14).constructor//返回ƒ String() { [native code] }
    
    function isArray(myArray) {
        return myArray.constructor.toString().indexOf("Array") > -1;
    }
    ```
- 严格模式：`"use strict";`
- Operator + 可用于将变量转换为数字：
    ```
    var y = "5";      // y 是一个字符串
    var x = + y;      // x 是一个数字
    ```
    
- Form提交前验证：
    ```
    <form onsubmit="return validate()">
    //validate方法返回false则不提交
    ```
    
- 变量声明时如果不使用var关键字，那么它就是一个全局变量，即便它在函数内定义。
- eval('str')
    解析器解析str代码，功能上类似于Function

- 变量、函数提升机制：
    ```
    var c = 2;
    function c(){
　　    console.log(1);
    }
    c();
    //报错，c未定义。
    //var c 和函数c被提升，c=2是表达式，后执行。
    //所以c()时，c不再是一个函数。
    ```

# 2. 正则
- `var patt=/pattern/modifiers;`
- pattern（模式） 以^开头，$结尾

- test() 方法用于检测一个字符串是否匹配某个模式
    ```
    /e/.test("The best things in life are free!");
    >> true
    ```
    
- exec() 方法用于检索字符串中的正则表达式的匹配(返回第一个匹配值)
    ```
    /e[1-9]/.exec("The be1st things in life are fre2e!");
    >>e1
    ```
    

# 3. 错误
- try-catch：
    ```
    try { 
        adddlert("Welcome guest!"); 
    } catch(err) { 
        txt+="错误描述：" + err.message; 
        alert(txt); 
    } 
    ```
 
- throw：err即throw
    ```
    try { 
        if(x == "")  throw "值为空";
    }
    catch(err) {
        message.innerHTML = "错误: " + err;
    }       
    ```

# 4. JSON
- 将一个 JSON 字符串转换为 JavaScript 对象(使可操作)
    ```
    var text = '{ "sites" : [' +
        '{ "name":"Runoob" , "url":"www.runoob.com" },' +
        '{ "name":"Google" , "url":"www.google.com" },' +
        '{ "name":"Taobao" , "url":"www.taobao.com" } ]}';
    
    obj = JSON.parse(text);
    document.getElementById("demo").innerHTML = obj.sites[1].name + " " + obj.sites[1].url;
    ```
- 将 JavaScript 值转换为 JSON 字符串(单行)
> JSON.stringify(value[, replacer[, space]]);


# 5. 函数
- 显式参数(Parameters)就是形参，隐式参数(Arguments)：实参
- 实例对象、类对象、局部变量(局部函数)
    ```
    function Person(national,age)
    {
        this.age = age;  //实例对象，每个示例不同
        Person.national = national;  //类对象,所用实例公用
        var bb = 0; //局部变量，外面不能访问（类似局部函数）
    }
    ```

- 创建新方法
    ```
    //原型属性、方法，此方法可被所有String对象使用
    String.prototype.funcName=function(){}
    //以字面量方法创建
    String.prototype = {
        constructor:String;
        //如果不写，新对象的构造器会重写String的构造器即Object(花括号)
        name:"zs";
        id:1
    }
    //实例属性、方法（实例通过.__proto__访问）
    str.funcName=function(){}
    ```

- 函数自动调用(只会执行一次)：
    ```
    <p id="demo"></p>
    <script>
    (function(){
        document.getElementById("demo").innerHTML = "Hello! 我是自己调用的";
    })();
    </script>
    ```

- 用构造函数调用函数
    ```
    // 构造函数:
    function myFunction(arg1, arg2){
        this.firstName = arg1;
        this.lastName = arg2;//如果直接当方法调用，this指window对象
        this.fullName = function(){
            return this.firstName + " " + this.lastName;
        }
    }
    var x = new myFunction("John","Doe");
    console.log(x.fullName());          // "John Doe"
    console.log(x.firstName);           // 返回 "John"
    ```

- 用函数方法调用函数（call() 和 apply()）（对象冒充），this指一参
    ```
    function myFunction(a, b) {
        return a * b;
    }
    myObject = myFunction.call(myObject, 10, 2);     // 返回 20
    //或
    myArray = [10, 2];
    myObject = myFunction.apply(myObject, myArray);  // 二参为参数数组
    ```
 
- 闭包（closure）：
    - 就是能够读取其他函数内部变量的函数，在JS中，只有子函数可以访问父函数的内部变量。
    - 即：闭包是可访问上一层函数作用域里变量的函数，即便上一层函数已经关闭。
    + 所以只要把子函数作为返回值，我们就可以在父函数外部读取它的私有变量且该变量不会随父函数结束而回收。
    + 实例：
        ```
        var add = (function () {
            var counter = 0;
            return function () {return counter += 1;}
        })();
        //自我调用使函数只执行一次，设置私有计数器为0。并返回函数表达式。
        add();
        add();
        add();
        //计数器为 3
        ```
        
    - 优点（应用场景）
        - 希望一个变量长期驻扎在内存当中；
        - 避免全局变量的污染；
        - 私有成员的存在
- arguments 对象
    在函数代码中，使用特殊对象arguments，开发者无需明确指出参数名，就能访问它们。
    ```
    function sayHi() {
        if (arguments[0] == "bye") {
            return;
        }
        alert(arguments[0]);
    }
    ```
    
    还可以用 arguments 对象检测函数的参数个数:`arguments.length`
    因为ECMAScript不会验证传递给函数的参数个数是否等于函数定义的参数个数，所以用 arguments 对象判断传递给函数的参数个数，即可模拟函数重载。

- Function 对象（类）
    **函数实际上是功能完整的对象。**
    **所有函数都应看作 Function 类的实例**
    所以Function 类可以表示开发者定义的任何函数，类似于java的反射。
    ```
    //下面这个函数

    function sayHi(sName, sMessage) {
      alert("Hello " + sName + sMessage);
    }
    //还可以这样定义它：
    
    var sayHi = new Function("sName", "sMessage", "alert(\"Hello \" + sName + sMessage);");
    ```

# 6. DOM
1. 获取元素
    ```
    var x=document.getElementById("intro");
    var y=document.getElementsByTagName("p");//返回DOM集合非数组
    var x=document.getElementsByClassName("intro");
    document.querySelector("p.example");//获取文档中class="example"的第一个<p>元素
    querySelectorAll();//返回所有的元素
    ```

2. 改变 HTML 内容
    ```
    document.getElementById("p1").innerHTML="新文本!";
    document.getElementById("p1").outerHTML="<p id='p2'>新文本!</p>";
    ```

3. 改变 HTML 属性
    ```
    document.getElementById("image").src="landscape.jpg";
    ```

4. 改变CSS
    ```
    document.getElementById("p2").style.color="blue";
    ```
5. [HTML DOM事件][1]
    - onclick
    - onload 和 onunload（进入或离开页面）（处理cookie）
    - onchange（对输入字段的验证）
    - onmouseover 和 onmouseout
    - onmousedown、onmouseup 以及 onclick
    - onfocus（输入框获得焦点）
6. EventListener
    - addEventListener() 方法
        ```
        element.addEventListener(event, function, useCapture);
        element.addEventListener("click", function(){alert("1");});
        element.addEventListener("click", function(){myFunction(p1, p2);});
        ```
        
        第一个参数是事件的类型 (如"click",无"on")。
        第二个参数是事件触发后调用的函数名（无括号）/匿名函数体。
        第三个参数true:事件捕获；false:事件冒泡。默认false。可选。
        可向同一个元素中添加多个事件句柄。
        用"匿名函数"调用带参数的函数。
    - 事件冒泡或事件捕获
        在'冒泡'中，内部元素的事件先触发，再触发外部元素事件
        在'捕获'中，外部元素的事件先触发，再触发内部元素事件
    - 移除由 addEventListener()方法添加的事件句柄
        element.removeEventListener("mousemove", myFunction);
7. 节点
    ```
    var para = document.createElement("p");
    var node = document.createTextNode("这是一个新的段落。");
    para.appendChild(node);
    var element = document.getElementById("div1");
    element.appendChild(para);
    ```
    
    - 创建DOM节点 `document.createElement("p")`
    - 创建文本节点 `document.createTextNode("文本")`
    - 添加子元素到尾部 `parent.appendChild(child)`
    - 添加新元素到开始位置 `insertBefore()`
    - 删除节点 `child.parentNode.removeChild(child);`
    - 父节点 `child.parentNode`
    - 子节点 `childNodes`
    - 第/最后一个子节点 `firstChild` `lastChild`
    - 下/上一个兄弟节点 `nextSibling` `previousSibling`

# 7. AJAX
## 7.1 原生xmlhttp
例子：
```
xmlhttp=new XMLHttpRequest();
xmlhttp.onreadystatechange=function()
{
    if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
		console.log(xmlhttp.responseText);
    }
}
xmlhttp.open("POST","http://www.runoob.com/try/ajax/demo_post.php",true);
xmlhttp.setRequestHeader("Content-type","application/json;charset=UTF-8");
xmlhttp.send(jsonData);
```
- 为防止得到缓存结果，可在地址添加随机参数:
    `"/ajax/demo_get.php?t=" + Math.random()`
- 如果通过 GET 方法发送信息，请向 URL 添加信息：
    `"/ajax/demo_get2.php?fname=Henry&lname=Ford"`
- onreadystatechange：
    存储函数（或函数名），每当 readyState 属性改变时，就会调用该函数。
- readyState：	
    存有 XMLHttpRequest 的状态。从 0 到 4 发生变化。
    
    0: 请求未初始化
    1: 服务器连接已建立
    2: 请求已接收
    3: 请求处理中
    4: 请求已完成，且响应已就绪
- status：
    200: "OK"；404: 未找到页面

- Async = false
    会等到服务器响应就绪才继续执行
    缺省值为true

- 回调函数（封装，多次使用）
    函数A作为参数(函数引用)传递到另一个函数B中，并且在函数B执行函数A。
    我们就说函数A叫做回调函数。
    如果没有名称(函数表达式)，就叫做匿名回调函数。
    ```
    var xmlhttp;
    function loadXMLDoc(url,cfunc)
    {
        xmlhttp=new XMLHttpRequest();
        xmlhttp.onreadystatechange=cfunc;
        xmlhttp.open("GET",url,true);
        xmlhttp.send();
    }
    function myFunction()
    {
    	loadXMLDoc("/try/ajax/ajax_info.txt",function()
    	{
    		if (xmlhttp.readyState==4 && xmlhttp.status==200)
    		{
    			console.log(xmlhttp.responseText);
    		}
    	});
    }
    ```

## 7.2 jQuery
```
$.ajax({
    type: "post",
    url: "Demo.aspx/SayHello",
    data: {},
    contentType: "application/json; charset=utf-8",
    dataType: "json",//预期服务器返回的数据类型
    success: function(data) {
        alert(data.d);//返回的数据用data.d获取内容
    },
    error: function(err) {
        alert(err);
    }
});
```

  [1]: http://www.runoob.com/jsref/dom-obj-event.html