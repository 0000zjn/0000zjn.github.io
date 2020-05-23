---
title: Node.js多线程
date: 2020-04-13 15:17:49
updated: 2020-04-17 14:42:23
tags: Node.js
---

# 前言
Node.js 通过提供 cluster、child_process API 创建 **子进程** 的方式来赋予Node.js“多线程”能力。但是这种创建进程的方式会**牺牲共享内存**，并且数据通信必须通过json进行传输。（有一定的局限性和性能问题）

基于此 Node.js V10.5.0 提供了 worker_threads，它比 child_process 或 cluster更轻量级。worker_threads 的出现让 Node.js 拥有**多工作线程**。

与 child_process 或 cluster 不同，worker_threads 可以共享内存，通过传输 ArrayBuffer 实例或共享 SharedArrayBuffer 实例来实现。

<!-- more -->

# 一、child_process（子进程）
node的单线程使得在主线程不能进行CPU密集型操作，否则会阻塞主线程。对于CPU密集型操作，在node中通过child_process可以创建独立的子进程，父子进程通过IPC通信，子进程可以是外部应用也可以是node子程序，子进程执行后可以将结果返回给父进程。

## 创建子进程

### 1.spawn ： 子进程中执行的是非node程序，提供一组参数后，执行的结果以流的形式返回。
spawn同样是用于执行非node应用，且不能直接执行shell，与`execFile`相比，`spawn`执行应用后的结果并不是执行完成后一次性的输出的，而是以流的形式输出。

```javascript
let cp = require('child_process');
let cat = cp.spawn('cat', ['input.txt']);
let sort = cp.spawn('sort');
let uniq = cp.spawn('uniq');

cat.stdout.pipe(sort.stdin);
sort.stdout.pipe(uniq.stdin);
uniq.stdout.pipe(process.stdout);
console.log(process.stdout);
```

执行后，最后的结果将输入到process.stdout中。如果input.txt这个文件较大，那么以流的形式输入输出可以明显减小内存的占用，通过设置缓冲区的形式，减小内存占用的同时也可以提高输入输出的效率。

### 2.execFile：子进程中执行的是非node程序，是一个应用，提供一组参数后，执行的结果以回调的形式返回。

````javascript
child_process.execFile('echo', ['hello', 'world'], function (err, stdout) {
    console.log(stdout);// hello world
});
````

execFile类似于执行了名为echo的应用，然后传入参数。execFlie会在process.env.PATH的路径中依次寻找是否有名为'echo'的应用，找到后就会执行。默认的process.env.PATH路径中包含了'usr/local/bin'，而这个'usr/local/bin'目录中就存在了这个名为'echo'的程序，传入hello和world两个参数，执行后返回。

### 3.exec：子进程执行的是非node程序，传入一串shell命令，执行后结果以回调的形式返回。

````javascript
child_process.exec('echo hello world', function (err, stdout) {
    console.log(stdout);// hello world
});
````

### 4.fork：子进程执行的是node程序，提供一组参数后，执行的结果以流的形式返回，与`spawn`不同，`fork`生成的子进程只能执行node应用。

在javascript中，在处理大量计算的任务方面，HTML里面通过web work来实现，使得任务脱离了主线程。node中提供了fork方法，通过fork方法在单独的进程中执行node程序，并且通过父子间的IPC通道通信，子进程接受父进程的信息，并将执行后的结果返回给父进程。

在子进程中：

**通过 process.on('message') 和 process.send() 的机制来接收和发送消息。**

在父进程中：

**通过 child.on('message') 和 child.send() 的机制来接收和发送消息。**

具体例子，在child.js中：
````javascript
process.on('message', function (msg) {
    process.send(msg)
})
````
在parent.js中：
````javascript
let child_process = require('child_process');
let child = child_process.fork('./child');
child.on('message', function (msg) {
    console.log('got a message is', msg);
});
child.send('hello world');
````
执行parent.js会在命令行输出：got a message is hello world

### 同步执行的子进程
exec、execFile、spawn和fork执行的子进程都是默认异步的，子进程的运行不会阻塞主进程。除此之外，child_process模块同样也提供了execFileSync、spawnSync和execSync来实现同步的方式执行子进程。

## 其他方法

### subprocess.disconnect()
关闭父进程与子进程之间的 IPC 通道，一旦没有其他的连接使其保持活跃，则允许子进程正常退出。
可以通过在父进程中调用：`child.disconnect()`来实现断开父子间IPC通信。
当子进程是一个 Node.js 实例时（例如使用 `child_process.fork()` 衍生），也可以在子进程中调用 `process.disconnect()` 方法来关闭 IPC 通道。

### subprocess.kill([signal])
向子进程发送一个信号。 如果没有给定参数，则进程将会发送 'SIGTERM' 信号。 如果 kill() 成功，则此函数返回 true，否则返回 false。


# 二、cluster（集群）
node的单线程，以单一进程运行，因此无法利用多核CPU以及其他资源，为了调度多核CPU等资源，node还提供了cluster模块，利用多核CPU的资源，使得可以通过一串node子进程去处理负载任务，同时保证一定的负载均衡性。

cluster 底层就是 child_process，它通过一个**父进程**管理一堆**子进程**的方式来实现集群的功能。master 进程做总控，启动 1 个 agent 和 n 个 worker，agent 来做任务调度，获取任务，并分配给某个空闲的 worker 来做。

官网例子：

```javascript
const cluster = require('cluster');
const http = require('http');
const numCPUs = require('os').cpus().length;

if (cluster.isMaster) {
    console.log(`主进程 ${process.pid} 正在运行`);

    // 衍生工作进程。
    for (let i = 0; i < numCPUs; i++) {
        cluster.fork();
    }

    cluster.on('exit', (worker, code, signal) => {
        console.log(`工作进程 ${worker.process.pid} 已退出，code：${code}，signal：${signal}`);
    });
} else {
    // 工作进程可以共享任何 TCP 连接。
    // 在本例子中，共享的是 HTTP 服务器。
    http.createServer((req, res) => {
        res.writeHead(200);
        res.end('你好世界\n');
    }).listen(8000);

    console.log(`工作进程 ${process.pid} 已启动`);
}
```

# 三、worker_threads（工作线程）
工作线程对于执行 CPU 密集型的 JavaScript 操作非常有用。 它们在 I/O 密集型的工作中用途不大。 Node.js 的内置的异步 I/O 操作比工作线程效率更高。

官方例子：

```javascript
const {Worker, isMainThread, parentPort, workerData} = require('worker_threads');

if (isMainThread) {
    module.exports = function parseJSAsync(script) {
        return new Promise((resolve, reject) => {
            const worker = new Worker(__filename, {
                workerData: script
            });
            worker.on('message', resolve);
            worker.on('error', reject);
            worker.on('exit', (code) => {
                if (code !== 0)
                    reject(new Error(`工作线程使用退出码 ${code} 停止`));
            });
        });
    };
} else {
    const {parse} = require('一些 js 解析库');
    const script = workerData;
    parentPort.postMessage(parse(script));
}
```

## 重要方法

### port.postMessage(value[, transferList])
 - value <any> 传输值（或指针）
 - transferList <Object[]> 传输内存（指针指向的）
 
将JavaScript值发送到此通道的接收端。值将以与HTML结构化克隆算法兼容的方式进行传输。

特别是，与JSON的显着区别是：

`value`可能包含循环引用。
`value`可能包含内置JS类型的实例，例如RegExps，BigInts，Maps，Sets等。
`value`可能包含使用`ArrayBuffers`和`SharedArrayBuffers`的类型化数组。
`value`可能包含`WebAssembly.Module`实例。
`value`可能不包含`MessagePort`s以外的本机（C ++支持）对象。

```javascript
const { MessageChannel } = require('worker_threads');
const { port1, port2 } = new MessageChannel();

port1.on('message', (message) => console.log(message));

const circularData = {};
circularData.foo = circularData;// 循环引用
// Prints: { foo: [Circular] }
port2.postMessage(circularData);
```

`transferList`可能是`ArrayBuffer`和`MessagePort`对象的列表。传输后，它们将不再在通道的发送端使用（即使它们不包含在`value`中）。与子进程不同，当前不支持传输句柄（例如网络套接字）。

如果`value`包含`SharedArrayBuffer`实例，则可以从任一线程访问这些实例。它们不能在`transferList`中列出。

`value`可能包含不在`transferList`中的`ArrayBuffer`实例；在这种情况下，底层内存将被复制而不是移动。

```javascript
const { MessageChannel } = require('worker_threads');
const { port1, port2 } = new MessageChannel();

port1.on('message', (message) => console.log(message));

const uint8Array = new Uint8Array([ 1, 2, 3, 4 ]);
// 这发出了`uint8Array`的副本：
port2.postMessage(uint8Array);
// 这不会复制数据，但会导致`uint8Array`无法使用：
port2.postMessage(uint8Array, [ uint8Array.buffer ]);

//从`.on('message')`接收到的原始副本和副本中都可以访问`sharedUint8Array`的内存：
const sharedUint8Array = new Uint8Array(new SharedArrayBuffer(4));
port2.postMessage(sharedUint8Array);

//这会将新创建的消息端口传输到接收器。
//例如，这可用于在作为同一父线程的子级的多个`Worker`线程之间创建通信通道。
const otherChannel = new MessageChannel();
port2.postMessage({ port: otherChannel.port1 }, [ otherChannel.port1 ]);
```

由于对象克隆使用结构化克隆算法，因此不会保留不可枚举的属性，属性访问器和对象原型。特别是，在接收方，`Buffer`对象将作为普通的`Uint8Arrays`读取。

消息对象将被立即克隆，并且可以在发出后进行修改而不会产生副作用。

有关此API背后的序列化和反序列化机制的更多信息，请参见v8模块的序列化API。