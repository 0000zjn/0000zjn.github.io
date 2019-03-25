---
title: Java虚拟机
date: 2019-03-21 00:17
tags: Java
---
# 一、概念

虚拟机：指以软件的方式模拟具有完整硬件系统功能、运行在一个完全隔离环境中的完整计算机系统 ，是物理机的软件实现。常用的虚拟机有VMWare，Visual Box，Java Virtual Machine（Java虚拟机，简称JVM）。

<!-- more -->

Java虚拟机阵营：Sun HotSpot VM、BEA JRockit VM、IBM J9 VM、Azul VM、Apache Harmony、Google Dalvik VM、Microsoft JVM…

# 二、启动流程

{% asset_img slug Java虚拟机 %}
{% asset_img 640.webp 启动流程 %}

# 三、基本架构

{% asset_img 2.webp %}
Java运行时编译源码(.java)成字节码，由jre运行。jre由java虚拟机（jvm）实现。Jvm分析字节码，后解释并执行。

{% asset_img 3.webp %}
JVM由三个主要的子系统构成：
1. 类加载器子系统
2. 运行时数据区（内存）
3. 执行引擎

# 四、类加载器子系统

{% asset_img 4.webp %}
类装载包括了加载，连接（验证、准备、解析（可选）），初始化。其中类加载工作由 ClassLoader 及其子类负责。

- 加载：在硬盘上查找并通过IO读入字节码文件
- 连接：执行校验、准备、解析（可选）步骤
- 校验：校验字节码文件的正确性
- 准备：给类的静态变量分配内存，并赋予默认值
- 解析：将符号引用转为直接引用，类装载器装入类所引用的其他所有类
{% asset_img 5.webp %}
- 初始化：对类的静态变量初始化为指定的值，执行静态代码块

# 五、类加载器体系结构

{% asset_img 6.webp %}
1．启动类加载器：负责加载JRE的核心类库，如jre目标下的rt.jar,charsets.jar等
2．扩展类加载器：负责加载JRE扩展目录ext中JAR类包
3．系统类加载器：负责加载ClassPath路径下的类包
4．用户自定义加载器：负责加载用户自定义路径下的类包


# 六、类加载机制（双亲委派）

全盘负责委托机制。全盘负责，当一个ClassLoader加载一个类时，除非显示的使用另一个ClassLoader，该类所依赖和引用的类也由这个ClassLoader载入。
委托机制：指先委托父类加载器寻找目标类，在找不到的情况下采用自己的路径中查找并载入目标类。

# 七、运行时数据区

{% asset_img 7.webp %}

# 八、堆（Java堆）

虚拟机启动时创建，用于存放对象实例，几乎所有的对象（包含常量池）都在堆上分配内存，当对象无法再该空间申请到内存时将抛出OutOfMemoryError异常。同时也是垃圾收集器管理的主要区域。可通过 -Xmx –Xms 参数来分别指定最大堆和最小堆。线程共享。
{% asset_img 8.webp %}

# 九、栈（Java栈）

是java方法执行的内存模型，为虚拟机执行java方法，每个方法在执行的同时都会创建一个栈帧（用于存储局部变量表，操作数栈，动态链接，方法出口等信息）。线程独占。
{% asset_img 9.webp %}
Jvm对该区域规范了两种异常：
1. 线程请求的栈深度大于虚拟机栈所允许的深度，将抛出StackOverFlowError异常。
2. 若虚拟机栈可动态扩展，当无法申请到足够内存空间时将抛出OutOfMemoryError。通过jvm参数–Xss指定栈空间，空间大小决定函数调用的深度。

# 十、本地方法栈

为虚拟机执行native方法，其他规范与java栈类似。不同类型的虚拟机对该区域可自由实现。线程独占。

# 十一、PC寄存器（程序计数器）

用来存储待执行指令的地址。分支，循环，跳转，异常处理，线程恢复等功能都需要依赖pc寄存器。线程独占。
若线程执行的是一个java方法，则pc寄存器中保存的是待执行指令的地址。若执行的是一个native方法，则pc寄存器中为空。

# 十二、元数据区

元数据区取代了永久代，本质和永久代类似，都是对JVM规范中方法区的实现，区别在于元数据区并不在虚拟机中，而是使用本地内存。元数据区在频繁使用，也会发生OutOfMemory异常。

元数据区的动态扩展，默认–XX:MetaspaceSize值为21MB的高水位线。一旦触及则Full GC将被触发并卸载没有用的类（类对应的类加载器不再存活），然后高水位线将会重置。新的高水位线的值取决于GC后释放的元空间。如果释放的空间少，这个高水位线则上升。如果释放空间过多，则高水位线下降。
{% asset_img 10.webp %}

# 十三、执行引擎

{% asset_img 11.webp %}

执行引擎读取运行时数据区的字节码并逐个执行

1. 解释器：解释器更快地解释字节码,但执行缓慢,解释一句执行一句。
2. JIT编译器：JIT编译器消除了解释器的缺点。执行引擎通过解释器转换字节码，当它发现重复的代码时，将使用JIT编译器，它编译整个字节码并将其更改为本地代码。这个本地代码将直接用于重复的方法调用，这提高了系统的性能。
> JIT的构成组件为：
中间代码生成器（Intermediate Code Generator）：生成中间代码 。
代码优化器（Code Optimizer）：负责优化上面生成的中间代码 。
目标代码生成器（Target Code Generator）：负责生成机器代码或本地代码 。
分析器（Profiler）：一个特殊组件，负责查找热点（被多次调用的方法）
3. 垃圾收集器：收集和删除未引用的对象。程序可调用System.gc()触发垃圾收集，但不能保证执行。
4. 本地方法接口（JNI）：JNI将与本机方法库进行交互，并提供执行引擎所需的本机库。
5. 本地方法库：执行引擎所需的本机库的集合。

# 十四、垃圾收集（GC：Garbage Collection）
- 如何识别垃圾，判定对象是否可被回收？

引用计数法：给每个对象添加一个计数器，当有地方引用该对象时计数器加1，当引用失效时计数器减1。用对象计数器是否为0来判断对象是否可被回收。缺点：无法解决循环引用的问题。

根搜索算法：也称可达性分析法，通过“GC ROOTs”的对象作为搜索起始点，通过引用向下搜索，所走过的路径称为引用链。通过对象是否有到达引用链的路径来判断对象是否可被回收（可作为GC ROOTs的对象：虚拟机栈中引用的对象，方法区中类静态属性引用的对象，方法区中常量引用的对象，本地方法栈中JNI引用的对象）。

- Java 中的堆是 GC 收集垃圾的主要区域，GC 分为两种：Minor GC、Full GC( 或称为 Major GC)。

Minor GC：新生代（Young Gen）空间不足时触发收集，由于Java 中的大部分对象通常不需长久存活，新生代是GC收集频繁区域，所以采用复制算法。

Full GC：老年代（Old Gen）空间不足或元空间达到高水位线执行收集动作，由于存放大对象及长久存活下的对象，占用内存空间大，回收效率低，所以采用标记-清除算法。

# 十五、GC算法

## 按照回收策略划分为：标记-清除算法，标记-整理算法，复制算法。

1.标记-清除算法：分为两阶段“标记”和“清除”。首先标记出哪些对象可被回收，在标记完成之后统一回收所有被标记的对象所占用的内存空间。不足之处：1.无法处理循环引用的问题2.效率不高3.产生大量内存碎片（ps：空间碎片太多可能会导致以后在分配大对象的时候而无法申请到足够的连续内存空间，导致提前触发新一轮gc）
{% asset_img 12.webp %}

2.标记-整理算法：分为两阶段“标记”和“整理”。首先标记出哪些对象可被回收，在标记完成后，将对象向一端移动，然后直接清理掉边界以外的内存。
{% asset_img 13.webp %}

3.复制算法：把内存空间划为两个相等的区域，每次只使用其中一个区域。gc时遍历当前使用区域，把正在使用中的对象复制到另外一个区域中。算法每次只处理正在使用中的对象，因此复制成本比较小，同时复制过去以后还能进行相应的内存整理，不会出现“碎片”问题。不足之处：1.内存利用率问题2.在对象存活率较高时，其效率会变低。
{% asset_img 14.webp %}

## 按分区对待可分为：增量收集算法，分代收集算法

1.增量收集:实时垃圾回收算法，即：在应用进行的同时进行垃圾回收，理论上可以解决传统分代方式带来的问题。增量收集把对堆空间划分成一系列内存块，使用时先使用其中一部分，垃圾收集时把之前用掉的部分中的存活对象再放到后面没有用的空间中，这样可以实现一直边使用边收集的效果，避免了传统分代方式整个使用完了再暂停的回收的情况。

2.分代收集:（商用默认）基于对象生命周期划分为新生代、老年代、元空间，对不同生命周期的对象使用不同的算法进行回收。
{% asset_img 15.webp %}

## 按系统线程可分为：串行收集算法，并行收集算法，并发收集算法

1. 串行收集:使用单线程处理垃圾回收工作，实现容易，效率较高。不足之处：1.无法发挥多处理器的优势 2.需要暂停用户线程
2. 并行收集:使用多线程处理垃圾回收工作，速度快，效率高。理论上CPU数目越多，越能体现出并行收集器的优势。不足之处：需要暂停用户线程
3. 并发收集:垃圾线程与用户线程同时工作。系统在垃圾回收时不需要暂停用户线程

# 十六、GC收集器
垃圾收集算法是内存回收的理论基础，而垃圾收集器就是内存回收的具体实现。

1.Serial 收集器主要针对新生代的收集，是最基本最古老的收集器，它是单线程收集器，工作时必须暂停所有用户线程。该收集器采用复制算法。           
Serial Old收集器主要针对老年代收集，采用标记-整理算法，实现简单高效，但会停顿。
{% asset_img 16.webp %}

2.ParNew收集器是Serial的多线程版本，针对新生代采用复制算法使用多线程进行垃圾收集（并行收集器，响应优先）。

3.Parallel Scavenge采用复制算法针对新生代的多线程收集器（并行收集器，吞吐优先）。可控制吞吐量和停顿时间，即吞吐量 = 运行用户代码时间 / (运行用户代码时间+垃圾收集时间)。
Parallel Old收集器是Parallel Scavenge收集器的老年代版本（并行收集器），使用多线程和标记-整理算法。
{% asset_img 17.webp %}

4.CMS（Current MarkSweep）收集器针对老年代，是一种以获取最短回收停顿时间为目标的收集器，它是一种并发收集器，采用的是标记-清除算法。
{% asset_img 19.webp %}

5.G1的新生代类似于ParNew，采用复制算法算法，当新生代占用达到一定比例的时候，开始收集。老年代类似于CMS，不同点是采用标记-整理算法。
G1因此它是一款并行与并发收集器，能充分利用多CPU、多核环境。并且它能建立可预测的停顿时间模型。

{% asset_img 20.webp %}
{% asset_img 21.webp %}
与CMS收集器相比G1收集器有以下特点：

1. 空间整合，G1收集器采用标记-整理算法，不会产生内存空间碎片。分配大对象（直接进Humongous区，专门存放短期巨型对象，不用直接进老年代，避免Full GC的大量开销）不会因为无法找到连续空间而提前触发下一次GC。（年青代拷贝、老年代转移对象无空闲分区、巨型对象无连续分区时触发Full GC，开销极大应该避免）
2. 可预测停顿，降低停顿时间是G1和CMS的共同关注点，但G1除了追求低停顿外，还能建立可预测的停顿时间模型，能让使用者明确指定在一个长度为N毫秒的时间内，消耗在垃圾收集上的时间不得超过N毫秒，几乎达到Java实时系统（RTSJ）级的垃圾收集器。
3. G1将Java堆划分为多个大小相等的独立区域（Region），虽保留新生代和老年代的概念，但不再是物理隔阂了，它们都是（可以不连续）Region的集合。

# 十七、收集器常用组合
{% asset_img 22.webp %}
{% asset_img 23.webp %}

# 十八、JVM性能调优思路
{% asset_img 24.webp %}

# 十九、理解GC日志
{% asset_img 24.webp %}

```
[GC [PSYoungGen: 8192K->1000K(9216K)] 16004K->14604K(29696K), 0.0317424 secs] [Times: user=0.06 sys=0.00, real=0.03 secs]

[GC [PSYoungGen: 9192K->1016K(9216K)] 22796K->20780K(29696K), 0.0314567 secs] [Times: user=0.06 sys=0.00, real=0.03 secs]

[Full GC [PSYoungGen: 8192K->8192K(9216K)] [ParOldGen: 20435K->20435K(20480K)] 28627K->28627K(29696K), [Metaspace: 8469K->8469K(1056768K)], 0.1307495 secs] [Times: user=0.50 sys=0.00, real=0.13 secs]

[Full GC [PSYoungGen: 8192K->8192K(9216K)] [ParOldGen: 20437K->20437K(20480K)] 28629K->28629K(29696K), [Metaspace: 8469K->8469K(1056768K)], 0.1240311 secs] [Times: user=0.42 sys=0.00, real=0.12 secs]
```
# 二十、常见异常
```
StackOverflowError:（栈溢出）

OutOfMemoryError: Java heap space（堆空间不足）

OutOfMemoryError: GC overhead limit exceeded  （GC花费的时间超过 98%, 并且GC回收的内存少于 2%）
```
# 二十一、GC参数
```
堆栈设置

-Xss:每个线程的栈大小

-Xms:初始堆大小，默认物理内存的1/64

-Xmx:最大堆大小，默认物理内存的1/4

-Xmn:新生代大小

-XX:NewSize:设置新生代初始大小

-XX:NewRatio:默认2表示新生代占年老代的1/2，占整个堆内存的1/3。

-XX:SurvivorRatio:默认8表示一个survivor区占用1/8的Eden内存，即1/10的新生代内存。

-XX:MaxMetaspaceSize:设置元空间最大允许大小，默认不受限制，JVM Metaspace会进行动态扩展。

垃圾回收统计信息

-XX:+PrintGC

-XX:+PrintGCDetails

-XX:+PrintGCTimeStamps

-Xloggc:filename

收集器设置

-XX:+UseSerialGC:设置串行收集器

-XX:+UseParallelGC:设置并行收集器

-XX:+UseParallelOldGC:老年代使用并行回收收集器

-XX:+UseParNewGC:在新生代使用并行收集器

-XX:+UseParalledlOldGC:设置并行老年代收集器

-XX:+UseConcMarkSweepGC:设置CMS并发收集器

-XX:+UseG1GC:设置G1收集器

-XX:ParallelGCThreads:设置用于垃圾回收的线程数

并行收集器设置

-XX:ParallelGCThreads:设置并行收集器收集时使用的CPU数。并行收集线程数。

-XX:MaxGCPauseMillis:设置并行收集最大暂停时间

-XX:GCTimeRatio:设置垃圾回收时间占程序运行时间的百分比。公式为1/(1+n)

CMS收集器设置

-XX:+UseConcMarkSweepGC:设置CMS并发收集器

-XX:+CMSIncrementalMode:设置为增量模式。适用于单CPU情况。

-XX:ParallelGCThreads:设置并发收集器新生代收集方式为并行收集时，使用的CPU数。并行收集线程数。

-XX:CMSFullGCsBeforeCompaction:设定进行多少次CMS垃圾回收后，进行一次内存压缩

-XX:+CMSClassUnloadingEnabled:允许对类元数据进行回收

-XX:UseCMSInitiatingOccupancyOnly:表示只在到达阀值的时候，才进行CMS回收

-XX:+CMSIncrementalMode:设置为增量模式。适用于单CPU情况

-XX:ParallelCMSThreads:设定CMS的线程数量

-XX:CMSInitiatingOccupancyFraction:设置CMS收集器在老年代空间被使用多少后触发

-XX:+UseCMSCompactAtFullCollection:设置CMS收集器在完成垃圾收集后是否要进行一次内存碎片的整理

G1收集器设置

-XX:+UseG1GC:使用G1收集器

-XX:ParallelGCThreads:指定GC工作的线程数量

-XX:G1HeapRegionSize:指定分区大小(1MB~32MB，且必须是2的幂)，默认将整堆划分为2048个分区

-XX:GCTimeRatio:吞吐量大小，0-100的整数(默认9)，值为n则系统将花费不超过1/(1+n)的时间用于垃圾收集

-XX:MaxGCPauseMillis:目标暂停时间(默认200ms)

-XX:G1NewSizePercent:新生代内存初始空间(默认整堆5%)

-XX:G1MaxNewSizePercent:新生代内存最大空间

-XX:TargetSurvivorRatio:Survivor填充容量(默认50%)

-XX:MaxTenuringThreshold:最大任期阈值(默认15)

-XX:InitiatingHeapOccupancyPercen:老年代占用空间超过整堆比IHOP阈值(默认45%),超过则执行混合收集

-XX:G1HeapWastePercent:堆废物百分比(默认5%)

-XX:G1MixedGCCountTarget:参数混合周期的最大总次数(默认8)
```

# 二十二、性能分析和监控工具

- Jps：虚拟机进程状况工具
- Jstat：虚拟机统计信息监视工具
- Jinfo：虚拟机配置信息工具
- Jmap：内存映像工具
- Jhat：虚拟机堆转储快照分析工具
- Jstack：堆栈跟踪工具
- JConsole：java监视与管理控制台
- VisualVM：故障处理工具

> Learned from 鲁班学院