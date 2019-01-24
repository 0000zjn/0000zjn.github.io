---
title: PHP语法与基础
date: 2017-07-03 20:34
tags: PHP
---

---
## 1. 常用函数
---
### 1.1 函数定义与使用
```
function sum($a, $b) {
    echo $a + $b;
}
sum(1,2);
```
<!-- more -->

---
### 1.2 维度打击函数
serialize方法将对象序列化为字符串，用于存储或者传递数据，然后在需要的时候通过unserialize将字符串反序列化成对象进行使用。
```
class Car {
    public $name = 'car';
}
$a = new Car();
$str = serialize($a); //对象序列化成字符串
echo $str.'<br>';
$b = unserialize($str); //反序列化为对象
var_dump($b);
```
---
### 1.3 `clone()`复制对象
```
class Car {
    public $name = 'car';
    
    public function __clone() {
        $obj = new Car();
        $obj->name = $this->name;
    }
}
$a = new Car();
$a->name = 'new car';
$b = clone $a;
var_dump($b);
```
---
### 1.4 `isset()` 检测变量是否设置（null）
PHP和C类似，0 "0" false "" 都以0保存，当然它们的类型不同。===下可区别。
```
if(isset($arr0))
    print_r($arr0);
```
---
### 1.5 输出
`var_dump()` 打印类型
`print_r()` 打印复合类型 如数组 对象
`print()` 输出字符串
`echo()` 普通输出，不能输出数组

---
### 1.6 `foreach()` 遍历
```php
<?php
$students = array(
'2010'=>'令狐冲',
'2011'=>'林平之',
'2012'=>'曲洋',
'2013'=>'任盈盈',
'2014'=>'向问天',
'2015'=>'任我行',
'2016'=>'冲虚',
'2017'=>'方正',
'2018'=>'岳不群',
'2019'=>'宁中则',
);//10个学生的学号和姓名，用数组存储

//使用循环结构遍历数组,获取学号和姓名  

foreach($students as $v)
{
    echo $v;//输出 姓名
    echo "<br />";
}
foreach($students as $key =>$v){ 
    echo $key.":".$v;//输出 学号：姓名
	echo "<br />";
}
?>
```
---
### 1.7 字符串函数

`str_replace(find,replace,string,count)`替换
find	必需。规定要查找的值。
replace	必需。规定替换 find 中的值的值。
string	必需。规定被搜索的字符串。
count	可选。一个变量，对替换数进行计数。

`trim()`去两端空格
rtrim去右边空格，ltrim去左边空格。

`strlen()` `mb_strlen(str,lang)`尺子
strlen是英文尺子，mb是其他尺子。
lang是编码格式，utf-8即 "utf8" 。

`substr(str,start,length)` `mb_substr(str,start,length,lang)`截肢
```
$str='i love you';//截取love这几个字母
echo substr($str, 2, 4);//为什么开始位置是2呢，因为substr函数计算字符串位置是从0开始的，也就是0的位置是i,1的位置是空格，l的位置是2。从位置2开始取4个字符，就是love。

$str='我爱你，中国';//截取中国两个字
echo mb_substr($str,4,2,'utf8');//为什么开始位置是4呢，和上一个例子一样，因为mb_substr函数计算汉字位置是从0开始的，也就是0的位置是我,1的位置是爱，4的位置是中。从位置4开始取2个汉字，就是中国。中文编码一般是utf8格式
```

`strpos(字典,字,start[可选])`查找定位

`sprintf('%01.2f', $str);`格式化字符串
%   开始
0   位数不足时用0填充
1   最短位数为1(含小数点)，不足用填充位填补
.   小数点
2   小数点后保留两位
f   float

`implode()` `explode()`字符串数组分割转换
```
$str = 'apple,banana';
print_r(explode(',', $str));//结果显示array('apple','banana')

$arr = array('Hello', 'World!');
print_r(implode('', $arr));//结果显示Hello World!
```

`addslashes()`转义
```
$str = "what's your name?";
echo addslashes($str);//输出：what\'s your name?
```

`preg_match()`正则
```
$p = '/apple/';
$str = "apple banna";
if (preg_match($p, $str)) {
    echo 'matched';
}
```

<br/>
---
### 1.7 `exists`类
```
function func() {
    echo 'exists';
}
$name = 'func';
if (function_exists('func') ) {//判断函数是否存在
    $name();
}

class MyClass{
}
if (class_exists('MyClass')) {// 使用前检查类是否存在
    $myclass = new MyClass();
}

$filename = 'test.txt';
if (!file_exists($filename)) {
    echo $filename . ' not exists.';
}
```
---
## 2. Array数组
---
### 2.1 定义及初始化
```php
$arr = array();
$fruit = array("苹果","香蕉","菠萝");
print_r($fruit);//输出的是人能看懂的数组结构

$arr[0]='苹果';//赋值方法1

$arr = array('0'=>'苹果');//方法2 左键右值

$arr = array('苹果','55');//方法3

foreach($this->tags as $tag)
    $ids[] = $this->_saveTag($tag);//方法4 连续赋值，键值会自增
```
---
### 2.2 数组的分类
* 索引数组 - 带有数字索引的数组
```
$arr = array(0=>'苹果');
```
* 关联数组 - 带有指定键的数组(使用字符串为键名)
```
$arr = array('0'=>'苹果');
```
* 多维数组 - 包含一个或多个数组的数组

---
### 2.3 访问数组内容
```
$arr0 = $arr['0'];//或$arr[0]即索引数组

foreach($fruit as $k=>$v){
    echo "数组中的第$i个值为$fruit[$i]";//必须用双引号
    echo "数组中的第".$i."个值为".$fruit[$i];//或者用连接符
}
```
---
## 3. PHP类和对象
---
### 3.1 类和对象的定义
```
<?php
//定义一个类
class Car {
    public $name = '汽车';      //默认
    static $color2 = '白色';    //静态属性
    protected $corlor = '黑色'; //受保护的
    private $price = '100000';  //私有
    function getName() {
        return $this->name;     //伪变量调用当前对象的属性
    }
    public function getPrice() {
        return $this->price;    //内部方法可以访问私有属性
    }
}

$car = new Car();       //实例化一个car对象
$car->name = '奥迪A6';  //设置对象的属性值
echo $car->getName();   //调用对象的方法 输出对象的名字
echo Car::$color2;      //使用::类名+双冒号直接访问静态对象（不能用this）
//echo $car->color;     //错误 受保护的属性不允许外部调用
//echo $car->price;     //错误 私有属性不允许外部调用
```
---
### 3.2 静态成员
+ 静态方法中，$this伪变量不允许使用。
+ 可以使用self，parent，static在内部调用静态方法与属性。
+ 使用::类名+双冒号直接访问静态对象
```
class Car {
    private static $speed = 10;
    
    public static function getSpeed() {
        return self::$speed;
    }
    
    public static function speedUp() {
        return self::$speed+=10;
    }
}
class BigCar extends Car {
    public static function start() {
        parent::speedUp();
    }
}

BigCar::start();
echo BigCar::getSpeed();
```
---
### 3.3 受保护的方法的使用
例一：如果构造函数定义成了私有方法，则不允许直接实例化对象了，这时候一般通过静态方法进行实例化。(这样的方法可以控制对象的创建，只允许有一个全局唯一的对象。)
```
class Car {
    private function __construct() {
        echo 'object create';
    }

    private static $_object = null; //因为只在getInstance()里使用一次，且内容私密所以是private
    public static function getInstance() {
        if (empty(self::$_object)) {
            self::$_object = new Car(); //内部方法可以调用私有方法，因此这里可以创建对象；静态::
        }
        return self::$_object;
    }
}
//$car = new Car();         //这里不允许直接实例化对象
$car = Car::getInstance();  //通过静态方法来获得一个实例
```
例二：
`speedUp()`被保护，所以用同类内部的`start()`方法来调用`speedUp()`。
```
class Car {
    private $speed = 0;
    
    public function getSpeed() {
        return $this->speed;
    }
    
    protected function speedUp() {
        $this->speed += 10;
    }
    
    //增加start方法，使他能够调用受保护的方法speedUp实现加速10
    public function start(){
       $this->speedUp();
    }
}
$car = new Car();
$car->start();
echo $car->getSpeed();
```
---
### 3.4 构造函数
具有构造函数的类，会在每次对象创建的时候调用该函数，因此常用来在对象创建的时候进行一些初始化工作。
例一：
```
class Car {
   function __construct() {
       print "构造函数被调用\n";
   }
}
$car = new Car(); //实例化的时候 会自动调用构造函数__construct，这里会输出一个字符串
```
例二：在子类中如果定义了__construct则不会调用父类的__construct，如果需要同时调用父类的构造函数，需要使用parent::__construct()显式的调用。
```
class Car {
   function __construct() {
       print "父类构造函数被调用\n";
   }
}
class Truck extends Car {
   function __construct() {
       print "子类构造函数被调用\n";
       parent::__construct();
   }
}
$car = new Truck();
```
---
### 3.5 析构函数
使用__destruct()进行定义，析构函数指的是当某个对象的所有引用被删除，或者对象被显式的销毁时会执行的函数。
```
class Car {
   function __construct() {
       print "构造函数被调用 \n";
   }
   function __destruct() {
       print "析构函数被调用 \n";
   }
}
$car = new Car(); //实例化时会调用构造函数
echo '使用后，准备销毁car对象 \n';
unset($car); //销毁时会调用析构函数
```
---
## 4. 其他
---
### 4.1 Tips
#### 4.1.1 对象比较
当同一个类的两个实例的所有属性都相等时，可以使用比较运算符==进行判断，当需要判断两个变量是否为同一个对象的引用时，可以使用全等运算符===进行判断。
#### 4.1.2 命名空间的别名
```
use ****\Response as Res;

$r = new Res('Oops', 400);
$r->send();
```
####4.1.3 全局命名空间
如Exception类，
```
$ex = new Exception();  //错，PHP会在当前命名空间中寻找exception类

throw new \Exception(); //对，\告诉PHP在全局命名空间中寻找该类
```
---
### 4.2 `list()`语言结构
```php
<?php
function numbers() {
    return array("狗","猪","猫");
}
list ($a, $b, $c) = numbers();
echo "我们的宠物有一只$a,一只$b以及一只 $c"
?>
```
---
### 4.3 `const()`语言结构
+ const用于类成员变量的定义，一经定义，不可修改。Define不可以用于类成员变量的定义，可用于全局常量。
+ Const不能再条件语句中定义常量
```
if (...){
    const FOO = 'BAR';    // 无效的invalid
}
if (...) {
    define('FOO', 'BAR'); // 有效的valid
}
```
+ const采用普通的常量名称，define可以采用表达式作为名称
```
const  FOO = 'BAR';
for ($i = 0; $i < 32; ++$i) {
    define('BIT_'.$i, 1 << $i);
}
```
+ const只能接受静态的标量，而define可以采用任何表达式
```
const BIT_5 = 1 << 5;    // 无效的invalid
define('BIT_5', 1 << 5); // 有效的valid
```
+ const定义的常量时大小写敏感，而define可以通过第三个参数（为true表示大小写不敏感）来指定大小写是否敏感。
```
define('FOO', 'BAR', true);
echo FOO; // BAR
echo foo; // BAR
```
---
### 4.4 可变函数
+ 所谓可变函数，即通过变量的值来调用函数，因为变量的值是可变的，所以可以通过改变一个变量的值来实现调用不同的函数。
+ 经常会用在回调函数、函数列表，或者根据动态参数来调用不同的函数。
+ 可变函数的调用方法为变量名加括号。
```
function func() {
    echo 'my function called.';
}
$name = 'func';
//调用可变函数
$name();
```
---
### 4.5 双冒号::作用域限定操作符的使用
+ 用变量在类定义外部访问
```
class Fruit {
    const CONST_VALUE = 'Fruit Color';
}
$classname = 'Fruit';
echo $classname::CONST_VALUE; //使用变量代替类名
echo Fruit::CONST_VALUE;
```
+ 在类定义外部使用（const）
+ 子类调用父类类方法
```php
class Fruit
{
    static function color()
    {
        return "color";
    }

    static function showColor()
    {
        echo "show " . self::color();
    }
}

class Apple extends Fruit
{
    static function color()
    {
        return "red";
    }
}
Apple::showColor();// output is "show color"!
```
+ 重写的属性方法
+ 静态
```
class Fruit {
    const CONST_VALUE = 'Fruit Color';
}

class Apple extends Fruit
{
    public static $color = 'Red';

    public static function doubleColon() {
        echo parent::CONST_VALUE;
        echo self::$color;
    }
}
Apple::doubleColon();
```
---
### 4.6 接口-例
`DocumentStore`类 实现从不同来源收集文本，下面是它的代码实现过程
接口在其中的作用就是给`HtmlDocument`和`StreamDocument`提供统一的实现方法
其他人只要知道如何实现接口，就可以完美使用、设计、拓展`DocumentStore`类
#### 4.6.1 接口的定义
定义Documentable接口：
```
interface Documentable
{
    public function getId();
    
    public function getContent();
}
//该定义表明：实现Documentable接口的任何对象都必须提供一个公开的getId()和getContent()
//作用：可以定义多个不同的实现方式
```
#### 4.6.2 接口的代码实现
定义HtmlDocument类：
```
class HtmlDocument implements Documentable
{
    protected $url;
    
    public function __construct($url)
    {
        $this->url = $url;
    }
    
    public function getId()
    {
        return $this->url;
    }
    
    public function getContent();
    {
        //balabala
        
        return $html;
    }
}
```
定义StreamDocument类：
```
class HtmlDocument implements Documentable
{
    protected $balabala;
    
    public function __construct($url)
    {
        //balabala
    }
    
    public function getId()
    {
        //balabala
    }
    
    public function getContent();
    {
        //balabala
        
        return $streamContent;
    }
}
```
#### 4.6.3 将多个同一接口的实现方法进行整合
定义文档存储类`DocumentStore`
```
class DocumentStore
{
    protected $data = [];//用于存储的数组
    
    public function addDocument(Documentable $document)//存入文档
    {
        //传入实现方法对象，调用其统一的方法
        $key = $document->getId();          //键
        $value = $document->getContent();   //值
        $this->data[$key] = $value;         //保存
    }
    
    public function getDocuments()//取出文档
    {
        return $this->data;
    }
}
```
#### 4.6.4 如何使用`DocumentStore`类
```
<?php
//创建文档存储对象
$documentStore = new DocumentStore();

//添加HTML文档
$htmlDoc = new HtmlDocument('https://php.net');
$documentStore->addDocument($htmlDoc);

//添加流文档
streamDoc = new StreamDocument(fopen('stream.txt', 'rb'));//使用不一样的方法对象
$documentStore->addDocument($htmlDoc);//一样的调用代码

print_r($documentStore->getDocuments());//输出看看
```