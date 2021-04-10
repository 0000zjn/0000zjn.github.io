---
title: Node.js入门笔记
date: 2018-07-19 09:27
updated: 2018-07-19 09:27
tags: JS
---
> Node.js 是一个基于 Chrome V8 引擎的 JavaScript 运行环境。
> Node + React 开发真的好方便~

<!-- more -->

# 1. NPM
- 安装：`npm install <Module Name>@可空版本号`
- 使用：`var express = require('express');`
- 本地安装 装在CLI当前目录 node_modules 下；全局安装 装在node下
- 更新：`npm update express`
- 淘宝镜像：`npm install -g cnpm --registry=https://registry.npm.taobao.org`
    使用：`cnpm install [name]`

# 2. Sundry
- Node.js 基本上所有的事件机制都是用设计模式中**观察者模式**实现
    当一个对象的状态发生改变时，所有依赖于它的对象都得到通知并被自动更新
- Node.js 异步编程的直接体现就是回调，Node 所有 API 都支持回调函数。

# 3. 创建服务器
```
//添加http依赖
var http = require("http");

//创建服务器（匿名形式写入回调）
http.createServer(function(request, response) {
    response.writeHead(200, {"Content-Type": "text/plain"});
    response.write("Hello World");
    response.end();
}).listen(8888);
```

# 4. 文件操作file system
1. 读写文件
    ```
    const fs = require('fs');
    
    //readFile(文件名,function(err,data))
    fs.readFile('aaa.txt',function(err,data){
        if(err){
            console.log('读取失败');
        }else{
            console.log(data.toString());
        }
    });
    
    //writeFile(文件名,内容,function(err))
    fs.writeFile('bbb.txt','123',function(err){
        console.log(err);
    });
    ```
2. 打开文件
    > fs.open(path, flags[, mode], callback)
    
    - path - 文件的路径。
    - flags - 文件打开的行为。具体值详见下文。
    - mode - 设置文件模式(权限)，文件创建默认权限为 0666(可读，可写)。
    - callback - 回调函数，带有两个参数如：callback(err, fd)。
    ```
    var fs = require("fs");
    
    // 异步打开文件
    console.log("准备打开文件！");
    fs.open('input.txt', 'r+', function(err, fd) {
       if (err) {
           return console.error(err);
       }
      console.log("文件打开成功！");     
    });
    ```
3. 获取文件信息
    > fs.stat(path, callback)

    ```
    var fs = require('fs');
    
    fs.stat('/Users/liuht/code/itbilu/demo/fs.js', function (err, stats) {
        console.log(stats.isFile());         //true
    })
    ```
4. 关闭文件

    ```
    fs.close(fd, function(err){
        if (err){
            console.log(err);
        }
        console.log("文件关闭成功");
    });
    ```

# 5. http数据解析
## 5.1 GET解析
- querystring解析(亦用于POST)
```
const querystring = require('querystring');

json = querystring.parse('user=blue&pass=12345&age=18');
console.log(json);
>> { user: 'blue', pass: '12345', age: '18' }
```
- url解析
```
const urlLib = require('url');
//二参：是否把query进行query转换
var obj=urlLib.parse('http://www.zjn.com/index?a=123&b=654',true);
console.log(obj);

>>  Url {
    protocol: 'http:',
    slashes: true,
    auth: null,
    host: 'www.zjn.com',
    port: null,
    hostname: 'www.zjn.com',
    hash: null,
    search: '?a=123&b=654',
    query: { a: '123', b: '654' },
    pathname: '/index',
    path: '/index?a=123&b=654',
    href: 'http://www.zjn.com/index?a=123&b=654' }
```

## 5.2 POST
```
const http = require('http');
const querystring = require('querystring');

http.createServer(function(req,res){
    //POST-req分段发送
    var str='';
    //data-有一段数据到达(多次)
    var i=0;
    req.on('data',function(data){
        console.log(`第${i++}次收数据`)
        str+=data;
    });
    //end-数据全部到达标记(一次)
    req.on('end',function(){
        var POST=querystring.parse(str);
        console.log(POST);
    });
}).listen(8080);
```

# 6. 模块
## 6.1 自定义模块
```
//mod.js
var a = 12;
exports.b = 23;//输出的对象加前缀exports.
module.exports={b,c=2,d=4};//批量输出
//1.js
const mod1 = require('./mod');//模块在node_modules目录下时./可省
console.log(mod1.a);
console.log(mod1.b);

//输出：
undefined
23
```

# 7. [事件][1]
## 7.1 事件绑定
> eventEmitter.on(event, listener)为事件绑定监听器,监听器为回调函数
> .emit(event, [arg1],[arg2], [...])触发,参数为监听器参数
> .once(event,listener)一次性监听器

```
// 引入 events 模块
var events = require('events');
// 创建 事件触发器 对象
var eventEmitter = new events.EventEmitter();

// 2.创建事件处理程序
var connectHandler = function connected() {
    console.log('1.连接成功。');
    // 3.触发 data_received 事件
    eventEmitter.emit('data_received');
}

// 绑定 connection 事件处理程序
eventEmitter.on('connection', connectHandler);
// 绑定 data_received 事件(使用匿名函数)
eventEmitter.on('data_received', function () {
    console.log('2.数据接收成功。');
});

// 1.触发 connection 事件 
eventEmitter.emit('connection');

console.log("3.程序执行完毕。");
```
> 输出：
> $ node main.js
> 1.连接成功。
> 2.数据接收成功。
> 3.程序执行完毕。

## 7.2 error 事件
内置，一般要为会触发 error 事件的对象设置监听器，避免程序崩溃
```
readerStream.on('error', function(err){
   console.log(err.stack);
});
```

# 8. Buffer
1. 编码
    ```
    //用from创建buffer对象（安全）
    const buf = Buffer.from('runoob', 'ascii');
    
    // 输出 72756e6f6f62
    console.log(buf.toString('hex'));
    
    // 输出 cnVub29i
    console.log(buf.toString('base64'));
    ```
2. 写入缓冲区
    ```
    buf.write(string[, offset[, length]][, encoding])
    ```
    
    > string - 写入缓冲区的字符串。
    > offset - 缓冲区开始写入的索引值，默认为 0 。
    > length - 写入的字节数，默认为 buffer.length
    > encoding - 使用的编码。默认为 'utf8' 。
    > 返回实际写入的大小

# 9. Stream
- 所有的 Stream 对象都是 EventEmitter 的实例。
## 9.1 从文件读入流
```
var fs = require("fs");
var data = '';

// 创建可读流
var readerStream = fs.createReadStream('input.txt');

// 设置编码为 utf8。
readerStream.setEncoding('UTF8');

// 处理流事件 --> data, end, and error
readerStream.on('data', function(chunk) {
   data += chunk;
});

readerStream.on('end',function(){
   console.log(data);
});

readerStream.on('error', function(err){
   console.log(err.stack);
});

console.log("程序执行完毕");
```
> 程序执行完毕
> &input.txt的内容

## 9.2 写入流到文件
```
var fs = require("fs");
var data = '菜鸟教程官网地址：www.runoob.com';

// 创建一个可以写入的流，写入到文件 output.txt 中
var writerStream = fs.createWriteStream('output.txt');

// 使用 utf8 编码写入数据
writerStream.write(data,'UTF8');

// 标记文件末尾
writerStream.end();

// 处理流事件 --> data, end, and error
writerStream.on('finish', function() {
    console.log("写入完成。");
});

writerStream.on('error', function(err){
   console.log(err.stack);
});
```

## 9.3 管道流
- 从一个流中获取数据并将数据传递到另外一个流中。
![此处输入图片的描述][2]
```
var fs = require("fs");

// 创建一个可读流
var readerStream = fs.createReadStream('input.txt');

// 创建一个可写流
var writerStream = fs.createWriteStream('output.txt');

// 管道读写操作
// 读取 input.txt 文件内容，并将内容写入到 output.txt 文件中
readerStream.pipe(writerStream);

console.log("程序执行完毕");
```

## 9.4 链式流
: 创建多个流操作链，一般用于管道操作。
- 压缩文件
```
var fs = require("fs");
var zlib = require('zlib');

// 压缩 input.txt 文件为 input.txt.gz
fs.createReadStream('input.txt')
  .pipe(zlib.createGzip())
  .pipe(fs.createWriteStream('input.txt.gz'));
  
console.log("文件压缩完成。");
```
- 解压文件
```
var fs = require("fs");
var zlib = require('zlib');

// 解压 input.txt.gz 文件为 input.txt
fs.createReadStream('input.txt.gz')
  .pipe(zlib.createGunzip())
  .pipe(fs.createWriteStream('input.txt'));
  
console.log("文件解压完成。");
```

# 10. express
非侵入性：保留了原生的功能，添加了一些方法。
只提供最简单的功能，使用中间件(插件)拓展功能。
链式操作：多次用`server.use`对请求进行处理(7.3)

- query方法解析get请求：
```
//1.添加依赖
const express = require('express');
//2.创建服务
var server=express();
//3.use添加响应，处理请求
server.get('/login',function(req,res){
    //内置query方法
    var user = req.query['user'];
    res.send('欢迎'+user,200);//send比原生的write功能更强大，可以放各种类型参数
    res.end();
});
//4.监听端口
server.listen(8080);
```
## 10.1 三种方法
- .get() - 处理get请求
- .post() - 处理post请求
- .all() - 可处理所有请求

## 10.2 静态资源
- express-static
```
const express = require('express');
//1.添加依赖
const expressStatic = require('express-static');

var server = express();
server.listen(8080);

//2.use使用插件
//指定静态资源目录，可从url直接访问
server.use(expressStatic('./www'));
```
## 10.3 GET/POST解析
- GET:exoress中req.query['user']直接解析
- POST:
    - 用body-parser
    ```
    const bosyParser=require('body-parser');
    
    //use函数无路径参数时，指接受所有请求
    server.use(bodyParser.urlencoded({
    extended:false,     //扩展模式：默认为true，不建议
    limit:2*1024*1024   //2M
    }));
    srver.use('/',function(req,res){
        console.log(req.body);//POST
    });
    ```
    - 手动实现
    ```
    //server.js
    const bodyParser2=require('./lib/my-body-paser');
    server.use(bodyParser2);
    srver.use('/',function(req,res){
    console.log(reg.body);
    });
    
    //my-body-parser.js
    const querystring = require('querystring');
    
    module.exports=function(req,res,next){
        var str = '';
        req.on('data',function(data){
            str+=data;
        });
        req.on('end',function(){
            req.body=querystring.parse(str);
            next();
        });
    }
    ```

## 10.4 链式操作
```
srver.use('/',function(req,res,next){
    console.log('a');
    next();//让下一个处理者处理
});
srver.use('/',function(req,res){
    console.log('b');
});
```
> a
b

# 11. Cookie & Seesion
## 11.1 设置、删除Cookie
```
server.use('/aaa/a.html', function (req, res) {
    //path：在此目录下生效，maxAge：生存毫秒
    res.cookie('user', 'blue', {path: '/aaa', maxAge: 30 * 24 * 3600 * 1000});
    //删除
    res.clearCookie('user');
    
    res.send('ok');
});
```

## 11.2 读取Cookie
```
//依赖cookie-parser
const cookieParser = require('cookie-parser');

server.use(cookieParser());

server.use('/', function (req, res) {
    console.log(req.cookies);
    
    res.send('ok');
});
```

## 11.3 签名Cookie
```
//依赖cookie-parser
const cookieParser = require('cookie-parser');
//签名
server.use(cookieParser('wesdfw4r34tf'));

server.use('/', function (req, res){
    res.cookie('user', 'blue', {signed: true});
    //读取
    console.log('签名cookie：', req.signedCookies);
    console.log('无签名cookie：', req.cookies);
    
    res.send('ok');
});
```

## 11.4 Session
- 加密是强制的
```
const cookieParser = require('cookie-parser');
const cookieSession = require('cookie-session');
//密钥
var arr=[];
for(var i=0;i<10000;i++){
  arr.push('sig_'+Math.random());
}
//会生成(session id)一个sess Cookie和一个sess.sig Cookie
server.use(cookieParser());
server.use(cookieSession({
    name: 'sess',
    keys: arr,
    maxAge: 2 * 3600 * 1000
}));

server.use('/', function (req, res) {
    //读取、修改
    if (req.session['count'] == null) {
        req.session['count'] = 1;
    } else if(req.session['count'] == 100) {
        //删除
        delete req.session;
    } else {
        req.session['count']++;
    }
    console.log(req.session['count']);

    res.send('ok');
});
```

# 12. 文件上传
- 文件名会被自动重命名防重名
```
const express = require('express');
const multer = require('multer');
const fs = require('fs');
//解析路径
const pathLib = require('path');

var server = express();
//指定存放路径和文件限制
server.use(multer({dest: './www/upload/'}).any());

server.post('/', function (req, res) {
    //新文件名
    var newName = req.files[0].path +
        pathLib.parse(req.files[0].originalname).ext;
    //重命名
    fs.rename(req.files[0].path, newName, function (err) {
        if (err)
            res.send('上传失败');
        else
            res.send('成功');
    });
});

server.listen(8080);
```

# 13. 数据库
mysql库的connection连接之后不要断开，不然后面无法再使用。可用连接池。
## 13.1 查
```
var mysql  = require('mysql');  

var connection = mysql.createConnection({     
    host     : 'localhost',       
    user     : 'root',              
    password : '123456',       
    port: '3306',                   
    database: 'test', 
}); 
//连
connection.connect();

var sql = 'SELECT * FROM websites';
//查
connection.query(sql,function (err, result) {
        if(err){
          console.log('[SELECT ERROR] - ',err.message);
          return;
        }
 
       console.log('-----------SELECT-----------');
       console.log(result);
       console.log('----------------------------\n\n');  
});
//断
connection.end();
```

## 13.2 增
```
var addSql = 'INSERT INTO websites(Id,name,url,alexa,country) VALUES(0,?,?,?,?)';
var addSqlParams = ['菜鸟工具', 'https://c.runoob.com','23453', 'CN'];
//增
connection.query(addSql,addSqlParams,function (err, result) {
    if(err){
        console.log('[INSERT ERROR] - ',err.message);
        return;
    }        
    
    console.log('-------------INSERT---------------');
    //console.log('INSERT ID:',result.insertId);        
    console.log('INSERT ID:',result);        
    console.log('----------------------------------\n\n');  
});
```

## 13.3 改
```
var modSql = 'UPDATE websites SET name = ?,url = ? WHERE Id = ?';
var modSqlParams = ['菜鸟移动站', 'https://m.runoob.com',6];
//改
connection.query(modSql,modSqlParams,function (err, result) {
    if(err){
        console.log('[UPDATE ERROR] - ',err.message);
        return;
    }        
    console.log('-----------UPDATE-----------');
    console.log('UPDATE affectedRows',result.affectedRows);
    console.log('----------------------------\n\n');
});
```

## 13.4 删
```
var delSql = 'DELETE FROM websites where id=6';
//删
connection.query(delSql,function (err, result) {
    if(err){
        console.log('[DELETE ERROR] - ',err.message);
        return;
    }        
    
    console.log('-------------DELETE-------------');
    console.log('DELETE affectedRows',result.affectedRows);
    console.log('--------------------------------\n\n');  
});
```

## 13.5 连接池
```
var mysql = require('mysql');
var pool  = mysql.createPool({
    host: '',
    user: '',
    password: '',
    port: '',
    database: '',
});

exports.query = function(sql, cb){
    pool.getConnection(function(err, connection) {
        connection.query(sql, cb);
        connection.release();
    });
}
```

  [1]: https://www.runoob.com/nodejs/nodejs-event.html
  [2]: http://www.runoob.com/wp-content/uploads/2015/09/bVcla61