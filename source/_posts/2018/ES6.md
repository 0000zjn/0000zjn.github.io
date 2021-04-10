---
title: ES6
date: 2018-11-06 17:16
updated: 2019-06-04 14:18
tags: JS
---
# 0. 箭头函数

箭头函数里指向的this是声明此函数的地方（比如window），所以涉及指向问题（如new、this等操作）需考虑用function还是箭头函数。

<!-- more -->

# 1. 常量：let和const
- 暂时性死区
    如果区块中存在let和const命令，这个区块对这些命令声明的变量，从一开始就形成了封闭作用域。凡是在声明之前就使用这些变量，就会报错。

    ```
    var tmp = 123;
    if (true) {
        tmp = 'abc'; // ReferenceError
        let tmp;
    }
    //上面代码中，存在全局变量tmp，但是块级作用域内
    //let又声明了一个局部变量tmp，导致后者绑定这个块级作用域，
    //所以在let声明变量前，对tmp赋值会报错。
    ```
    总之，在代码块内，使用let命令声明变量之前，该变量都是不可用的。这在语法上，称为“暂时性死区”（temporal dead zone，简称 TDZ）。


# 2. Promise
## 2.1 常用方法
- Promise.prototype.then()：参数A B分别为promise的resolve,reject的回调函数，参数至少填一个
- Promise.prototype.catch()：可视为.then(null,func2)的简写
- Promise.resolve()：快速创建一个状态为fulfilled(解决)的Promise对象，参数为.then()的参数的参数
- Promise.reject()：快速创建一个状态为rejected(拒绝)的Promise对象，参数为回调函数的参数
- Promise.all()：将多个Promise对象变成一个Promise对象
- Promise.race()：和all()同样接受多个对象，不同的是，race()接受的对象中，哪个对象返回的快就返回哪个对象

## 2.2 示例代码
- then()的链式使用
```
//第一个异步任务
function run_a(){
    return new Promise(function(resolve, reject){
        //假设已经进行了异步操作，并且获得了数据
        resolve("step1");
    });
}
//第二个异步任务
function run_b(data_a){
    return new Promise(function(resolve, reject){
        //假设已经进行了异步操作，并且获得了数据
        console.log(data_a);
        resolve("step2");
    });
}
//第三个异步任务
function run_c(data_b){
    return new Promise(function(resolve, reject){
        //假设已经进行了异步操作，并且获得了数据
        console.log(data_b);
        resolve("step3");
    });
}

//连续调用
run_a().then(function(data){
    return run_b(data);
}).then(function(data){
    return run_c(data);
}).then(function(data){
    console.log(data);
});

/*运行结果
  step1
  step2
  step3
*/
```
- then()和catch()
```
 new Promise((resolve,reject) => {
    resolve('成功了');
    console.log('Promise过程代码');
    reject('失败了');
}).then(result => {
    console.log(result,"resovle执行");
}, result => {
    console.log(result,"reject执行");
})
//结果："成功了 resovle执行"
//没有变成失败的原因：状态从pending变成fullfilled后不可变了
```
等效于：promise(...).then(...).catch(...)
```
 new Promise((resolve,reject) => {
    resolve('成功了');
    console.log('Promise过程代码');
    reject('失败了');
}).then(result => {
    console.log(result,"resovle执行");
}).catch(result => {
    console.log(result,"reject执行");
})
```
- Promise.all()
```
let p1 = Promise.resolve(123);
let p2 = Promise.resolve('hello');
let p3 = Promise.resolve('success');


Promise.all([p1,p2,p3]).then(result => {
    console.log(result);
})
//结果：[ 123, 'hello', 'success' ]
```
成功之后就是数组类型，当所有状态都是成功状态才返回数组，只要其中有一个的对象是reject的，就返回reject的状态值。
```
let p1 = Promise.resolve(123);
let p2 = Promise.resolve('hello');
let p4 = Promise.reject('error');

Promise.all([p1,p2,p4]).then(result => {
    console.log(result);
}).catch(result => {
    console.log(result);
});
//结果：error
```
## 2.3 异常处理
Pormise内部的错误外界用try-catch捕捉不到，抛出的错误只能通过.catch()来捕捉，所以建议**在Promise链的尾部接一个catch**：
```
try {
    let p = new Promise((resolve, reject) => {
        throw new Error("I'm error");
    });
}catch(e) {
    console.log('catch',e);//无法执行
}


new Promise((resolve, reject) => {
    throw new Error("I'm error");
}).catch(result => {
    console.log(result);//可以打印
});
```
