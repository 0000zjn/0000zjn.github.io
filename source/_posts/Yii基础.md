---
title: Yii基础
date: 2017-07-06 11:20
updated: 2017-07-06 11:20
tags: PHP
toc: true
---
> Yii框架基础笔记

<!-- more -->

# 1. 控制器
## 1.1 介绍
+ 命名空间与引用
```
namespace app\controllers;
use yii\web\Controller;
```
+ 命名
 + 控制器：以大写字母开头，加'Controller'后缀：TestController.php
 + 方法：在控制器里叫操作，'action'加大写字母开头的方法名：actionIndex()
 + 类名与文件名相同
+ 访问控制器
访问TestController的index操作（r=控制器/操作）：
http://basic/web/index.php`?r=test/index`
当方法名非开头有大写时，actionShowUser()：
http://basic/web/index.php`?r=test/show-user`

## 1.2 内置函数
+ 时间(年)：
```<?= date('Y') ?>```
+ 重定向：
```$this->redirect(['site/index']);//数组内为调用控制器+操作```
+ 回主页：
```$this->goHome();```
+ 返回上一个页面：
```$this->goBack();```
+ 刷新：
```$this->refresh();//死循环报错```

## 1.3 请求处理request
+ 地址栏get：GET用于信息获取，而且应该是安全的和幂等的。
地址栏：http://basic/web/index.php?r=test/index&id=3
取参：
```
$request = \YII::$app->request; //YII全局变量，以\表根。或引入命名空间use YII;省去\
echo $request->get('id',20);    //when ！return，return 20，optional
```
+ 表单post：POST表示可能修改变服务器上的资源的请求。
```$request->post('name', 2333);```
+ 判定请求类型：
```
if ($request->isPost) {
    echo 'This is Post method.';
} elseif ($request->isGet) {
    echo 'This is Get method.';
}
```
+ IP地址
```echo $request->userIp;```
---
## 1.4 响应处理response
```$res = \YII::$app->response;```
+ 状态码
```$res->statusCode = '404';```
+ 头部
```
$res->headers->add('pragma', 'no-cache');//添加html头pragma,不要缓存
$res->headers->set('pragma', 'max-age=5');//修改
$res->headers->remove('pragma');//删除
```
+ 跳转
```
$res->headers->add('location','http://www.baidu.com');//跳转，试图访问的对象已经被移到别的位置了，到该头部指定的位置去取。
$this->redirect('http://www.baidu.com', 302);//controller跳转专用函数
```
+ 下载
```
$res->headers->add('content-disposition', 'attachment;filename="a.jpg"');//attachment附件形式
$res->sendFile('robots.txt');//下载当前页面文件目录下的robots.txt
```

## 1.5 session
```
$session = \YII::$app->session; //设置变量

$session->open();               //开启session

if($session->isActive){         //判断session是否开启
    echo "session is active.";
}

$session->set('user', '张三');  //设置方法一

$session['user'] = '张三';      //设置方法二

echo $session['user'];          //取session

$session->remove('user');       //删除方法一

unset($session['user']);        //删除方法二

```

## 1.6 cookie
```
$cookie = \YII::$app->cookies;  //设置变量

$cookie_data = array('name'=>'user','value'='zhangsan');

$cookie->add(new Cookie($cookie_data));     //赋值，覆盖式修改

$cookie->remove('id');          //删除

$cookies = \YII::$app->request->cookies;    //取cookie
echo $cookies ->getValue('users',400);      //when !found'users' return'400' it's optional value
```

# 2. 视图（页面）
## 2.1 创建
在views目录下创建控制器同名文件夹test，小写即可。
文件夹内新建页面php，可以直接使用html代码，可添加`<?php ?>`标签来进行using等操作

## 2.2 使用
```return $this->renderPartial('index');        //使用test/index视图文件```

## 2.3 传值
控制器：TestController
```
$hello_str= "Hello God";
$test_arr=array(1,2);

$data = array();                                //创建数组存放数据

$data['view_hello_str'] = $hello_str;           //加入'view_hello_str'键
$data['view_test_arr'] = $test_arr;             //加入数组键

return $this->renderPartial('index', $data);    //使用index视图文件并传递数据data
```
视图：index.php
```
<?=$view_hello_str;?>
<?=$view_test_arr[0];?>
```
---
## 2.4 传值的安全问题
控制器：TestController
```
$hello_str= "Hello God";
$data = array();                                //创建数组
$data['view_hello_str'] = $hello_str;           //加入'view_hello_str'键
return $this->renderPartial('index', $data);    //使用index视图文件的同时把数组data传递过去
```
视图：index.php
```
<?php
use yii\helpers\Html;
use yii\helpers\HtmlPurifier;
?>
<h1><?=Html::encode($view_hello_str);?></h1>            <!--方法一：转义-->
<h1><?=HtmlPurifier::process($view_hello_str);?></h1>   <!--方法二：过滤script-->
```
---
## 2.5 布局文件（模板）
1. 在views/layouts文件夹下新建php布局
2. 控制器声明所用视图
3. render()方法将视图嵌入布局并显示

视图：
```
<h1>index</h1>
```
布局：
```php
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Document</title>
    </head>
    <body>
        <?=$content;?>          <!--视图插入到这里-->
    </body>
</html>
```
控制器：
```
public $layout = 'common';      //用$layout声明所用的布局文件
public function actionShowUser()
{
    return $this->render('index');  
    //render决定访问当前活动时服务器要渲染的视图，render会渲染layout，而renderPartial不会渲染
    //render()的实际上是先renderPartial view文件，然后renderFile layoutfile,并将view文件的结果做为$content变量传入。 
}
```
更新：
```
方案1:控制器内成员变量
public $layout = false; //不使用布局
public $layout = "main"; //设置使用的布局文件

方案2：控制器成员方法内
$this->layout = false; //不使用布局
$this->layout = "main"; //设置使用的布局文件

方案3：视图中选择布局
$this->context->layout = false; //不使用布局
$this->context->layout = 'main'; //设置使用的布局文件
```
---
## 2.6 视图的嵌套
控制器：
```
public function actionShowUser()
{
    return $this->renderPartial('index');//只渲染index
}
```
视图index：
```
<h1>hello index</h1>
<?php
echo $this->render('about', array('v_hello_str'=>'hello world'));
//参数一：在index视图中嵌入about视图
//参数二：传递数组，理同“传值”
?>
```
视图about：
```
<h1>hello about</h1>
<h1><?=$v_hello_str;?></h1>
```
---
## 2.7 数据块
控制器：
```
public $layout = 'common';
public function actionIndex()
{
    return $this->render('index');
}
```
布局：
```
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Document</title>
    </head>
    <body>
        <?php if (isset($this->blocks['block1'])) :?>
            <?=$this->blocks['block1'];?>   <!--这句也可以直接使用-->
        <?php else :?>
            <h1>hello Common</h1>   <!--也可以用花括号把语句写在php标签-->
        <?php endif?>
        <?=$content;?>
    </body>
</html>
```
视图：
```
<?php $this->beginBlock('block1');?>    <!--数据块block1-->
<h1>indexBlock</h1>
<?php $this->endBlock();?>
```

# 3. 数据模型

## 3.1 连接数据库与Yii
/config/db.php
advanced\common\config\main-local.php
## 3.2 什么是活动记录：
Active Record （活动记录，以下简称AR）提供了一个面向对象的接口， 用以访问数据库中的数据。
+ 一个 AR 类关联一张数据表， 每个 AR 对象对应表中的一行，对象的属性（即 AR 的特性Attribute）映射到数据行的对应列。
+ 一条活动记录（AR对象）对应数据表的一行，AR对象的属性则映射该行的相应列。
+ 使用控制器来使用AR。

## 3.3 活动记录的声明
数据模型：
```
<?php
namespace app\models;
use yii\db\ActiveRecord;
class Test extends ActiveRecord //类名与与表名一致
{
}
```
控制器：
```
<?php
namespace app\controllers;
use yii\web\Controller;
use app\models\Test;//拓展创建的AR
class TestController extends Controller
{   
}
```

## 3.4查询 findBySql()
```
$sql = 'select * from test where id=1';
$results = Test::findBySql($sql)->all();//继承自AR，将返回的每条记录包装成一个对象，将对象组装成数组，并用all()返回一个数组
print_r($results);
```
## 3.5 占位符防注入
```
$sql = 'select * from test where id=:id';//':id' is 占位符
$id = '1';
$results = Test::findBySql($sql,array(':id'=>$id))->all();
```
## 3.6 简化版-数组查询法 find()
```
$results = Test::find()
    ->where(['id'=>1])      //id=1
    ->all();
    //->where(['>','id',0])   //id>0
    //->where(['between','id',1,2])       //id>=1 and id<=2
    //->where(['like','title','title1'])  //title like "%title1%"
print_r($results);
```

## 3.7 选择查询-分页
```
SELECT * form 表名 WHERE 条件 limit 5,10; //检索6-15条数据

SELECT * form 表名 WHERE 条件 limit 5,-1; //检索6到最后一条数据(-1)

SELECT * form 表名 WHERE 条件 limit 5; //检索前5条数据，换句话说，LIMIT n 等价于 LIMIT 0,n。

//Yii写法：
$query->limit(10)->offset(20);      //21开始的10条数据
```

## 3.8 删除
```
//删除第一条
$results = Test::find()->where(['id'=>1])->all();//取出数据
$results[0]->delete();
//全删
Test::deleteAll();
//条件删除
Test::deleteAll('id>0');
PostCollectModel::deleteAll(['user_id'=>610,'post_id'=>10]);
//占位符
Test::deleteAll('id>:id',array(':id'=>0));
```
## 增加
```
$test = new Test;       //创建一个AR的对象
$test->id = 3;
$test->title = 'title3';
$test->save();          //存入
```

## 3.9输入合法验证
AR：
```
public function rules(){
    return [
        ['id','integer'],   //列名，验证器
        ['title','string','length'=>[0,5]]
    ];
}
```
控制器：
```
$test->validate();              //save前进行验证，错误则中止
if($test->hasErrors()){         //$test->getErrors()返回错误信息
    echo 'data is error';
    die;
}
```

## 3.10 改
```
$test = Test::find()->where(['id'=>4])->one();  //one()只返回一个对象，可酌情替换all()
$test->title = 'title4';
$test->save();
```
## 3.11 增减updateCounters
```
$model 即为models对象
例1：
$model->updateCounters(array('count'=>1), 'id='.$model->id);//自动叠加1
$model->updateCounters(array('count'=>-1), 'id='.$model->id);//自动递减1
例2：
$model = PostModel::findOne($post_id);
$model->updateCounters(['collect'=>1]);
```
## 3.12 关联查询一
根据顾客查订单（一查多）：
```
use app\models\Order;       //引入订单表的AR
use app\models\Customer;    //顾客表

class TestController extends Controller
{   
    public function actionIndex()
    {
        //关联查询
        $customer = Customer::find()
        ->where(['name'=>'zhangsan'])
        ->one();
        
        $orders = $customer
            ->hasMany('app\models\Order',['customer_id'=>'id'])
            //'app..'可用 Order::className 替换，好像没什么用
            ->asArray()         //以数组方式显示,便于浏览
            ->all();
            
        print_r($orders);
    }
}
```
封装查询：
Customer AR类：
```
public function getOrder()
{
    $orders = $this->hasMany(Order::className,['customer_id'=>'id'])->asArray()->all();
    //用$this代替$customer                     ↑表结构↑
    return $orders;
}
```
控制器：
```
$customer = Customer::find()
        ->where(['name'=>'zhangsan'])
        ->one();
$orders = $customer->getOrders();
//被封装，如果表出现变动，只需修改AR，消除了控制器和模型的耦合
//也可以这样，调用__get()，转化成getOrders()方法，并在最后生成->all()
//$orders = $customer->orders;//推荐写法
//所以需要删除getOrder()最后重复的->all()
print_r($orders);
```

## 3.13 关联查询二
根据订单查询顾客（一查一）：
Order：
```
public function getCustomer()
{
    return $this
    ->hasOne(Customer::className,['id'=>'customer_id'])
    ->asArray();
}
```
Controller：
```
$order = Order::find()->where(['id'=>1])->one();
$customer = $order->getCustomer()->one();
//或者这么写：
$customer = $order->customer;
print_r($customer);
```

## 3.14 查询结果缓存
```
$customer = $order->customer;//取值
unset($order->customer);    //清空
$customer = $order->customer;//再次取值
```

## 3.15 多次查询优化
```
//select * from customer
//select * from order where customer_id in(...)
//加上with后，查询的是所有顾客id的集合，
$customers = Customer::find()->with('orders')->all();
foreach($customers as $customer){   //那么就不会调用下面的sql语句了，一共只进行2次查询
    $orders = $customer->orders;    //select * from order where customer_id = ...
}
```