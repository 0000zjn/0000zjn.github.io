---
title: Yii高效篇
date: 2017-07-09 11:19
tags: Yii
---

# 1. 延迟加载
## 1.1 类的延迟加载
原版：
```
<?php
class Class1{}  //空的Class1&Class2
```
<!-- more -->
```
<?php
Require('class\Class1.php');
require('class\Class2.php');    //加载两个class

$is_girl = $_GET['sex']==0?true : false;    //使用get方法传值
if($is_girl){
    echo 'This is a girl!';     //但其实只要其中一个
    $class1 = new class1;
}else{
    echo 'not a girl';
    $class2 = new Class2;
}
```
优化：
```
<?php
$is_girl = $_GET['sex']==0?true : false;
if($is_girl){
    echo 'This is a girl!';
    Require('class\Class1.php');        //延迟加载
    $class1 = new class1;
}else{
    echo 'not a girl';
    require('class\Class2.php');
    $class2 = new Class2;
}
```
再优化：
```
<?php
function my_loader($class){
    require('class\\'.$class.'.php');   //双斜杠转义
}

spl_autoload_register('my_loader'); //自动加载注册my_loader函数

$is_girl = $_GET['sex']==0?true : false;
if($is_girl){
    echo 'This is a girl!';
    $class1 = new class1;   //遇见不认识的class1，运行my_loader
}else{
    echo 'not a girl';
    $class2 = new Class2;
}
```

## 1.2 类的映射表机制
```
<?php
namespace app\controllers;

use yii\web\Controller;
use app\models\Test;
use app\models\Order;
use app\models\Customer;    //用下面的映射进行转换

class TestController extends Controller
{
    public function actionIndex()
    {
        \YII::$classMap['app\models\Order'] = 'D:\phpProject\basic\models\Customer.php';
        //就能提高加载的速度
        $order = new Order;
    }
}
```

# 2. 数据缓存
## 2.1 增删改查有效期
控制器中：
```
$cache = \YII::$app->cache;//获取缓存组件
$cache->add('key1', 'hello world!',15);//往缓存中写数据，参三生存时间秒可选
$cache->set('key1', 'hello world2',15);//修改数据（也能作为写入），参三生存时间秒可选
$cache->delete('key');//删除数据
$cache->flush();//清空数据
$data = $cache->get('key1');//读缓存
print_r($data);
var_dump($data);
```

## 2.2 数据缓存依赖
文件依赖：
```
$cache = \YII::$app->cache;
$dependency = new \yii\caching\FileDependency(['fileName'=>'hw.txt']);//设置依赖文件
$cache->add('key1','hello world!',1500,$dependency);//为缓存设置依赖
var_dump($cache->get('key1'));//读缓存,如果文件被修改，显示bool(false)
```
表达式依赖：
```
$cache = \YII::$app->cache;
$dependency = new \yii\caching\ExpressionDependency(
    ['expression'=>'\YII::$app->request->get("name")']
);//以get请求作为表达式，当该值发生变化，缓存即失效
$cache->add('key1','hello world!',1500,$dependency);
var_dump($cache->get('key1'));
```
Db依赖
```
$cache = \YII::$app->cache;
$dependency = new \yii\caching\DbDependency(
    ['sql'=>'SELECT count(*) FROM yii.order']
);
$cache->add('key1', 'hello world!', 1500,$dependency);
var_dump($cache->get('key1'));
```

# 3. 片段缓存
## 3.1 介绍
在控制器中使用视图，在视图中用beginCache endCache包围
视图（views/test/index.php）：
```
<?php if($this->beginCache('cache_div')){?> //写上唯一id标识
<div id='cache_div'>
    <div>这里将会被缓存</div>
</div>
<?php $this->endCache();}?>

<div id='no_cache_div'>
    <div>这里不会被缓存</div>
</div>
```

## 3.2 过期时间
```
<?php if($this->beginCache('cache_div',['duration'=>30])){?>  <!--duration二参寿选-->
    <div id='cache_div'>
        <div>这里将会被缓存</div>
    </div>
<?php $this->endCache();}?>
```

## 3.3 片段缓存的依赖设置
```
<?php
    $dependency = [
        'class' => 'yii\caching\FileDependency',    //缓存依赖类型
        'fileName'=>'hw.txt'
    ];
?>
<!--dependency-->
<?php if($this->beginCache('cache_div',['dependency' => $dependency])){?>
<div id='cache_div'>
    <div>这里将会被缓存</div>
</div>
<?php $this->endCache();}?>
```

## 3.4 缓存开关
```
<?php
    $enabled = ture;
?>
<!--缓存开-->

<?php if($this->beginCache('cache_div',['enabled' => $enabled])){?>
<div id='cache_div'>
    <div>这里将会被缓存</div>
</div>
<?php $this->endCache();}?>
```

## 3.5 嵌套使用
可配合其他属性使用比如时间,需要注意的是外层的冷却为过，内层修改是无法生效的
```
<?php if($this->beginCache('cache_div',['duration'=>10])){?>
<div id='cache_div'>
    <div>这里是外层缓存</div>
    
    <?php if($this->beginCache('cache_div',['duration'=>20])){?>
        <div id='cache_div'>
            <div>这里是内层缓存</div>
        </div>
    <?php $this->endCache();}?>
    
</div>
<?php $this->endCache();}?>
```

## 3.6 动态内容
使用片段缓存时，可能会遇到一大段较为静态的内容中有少许动态内容的情况。例如，一个显示着菜单栏和当前用户名的页面头部。或是缓存的内容包含每次请求都需要执行的 PHP 代码。
```
<?php if ($this->beginCache($id1)) {?>

    <!--...在此生成内容...-->

<?php echo $this->renderDynamic('return Yii::$app->user->identity->name;');?>

    <!--...在此生成内容...-->
    
<?php $this->endCache();}?>
```

# 4. 页面缓存
在服务器端缓存整个页面的内容，可以在使用页面缓存的同时，使用片段缓存和 动态内容。

## 4.1 behaviors()介绍
behaviors会在action之前执行
```
public function behaviors(){
    echo '1';
    return[];
}
public function actionIndex(){
    echo '2';
}
```

## 4.2 介绍
如果整个页面都不怎么会改动，可以使用页面缓存
behaviors用return[]告诉yii框架使用页面缓存
```
public function behaviors(){
    return[
        [
            'class' => 'yii\filters\PageCache',
            'only' => ['index'], //数组成员可以多个
            //只缓存index，在当前控制器中有多个action时有意义
            'duration' => 60,
            'variations' => [
                \Yii::$app->language,
            ],
            'dependency' => [
                'class' => 'yii\caching\DbDependency',
                'sql' => 'SELECT COUNT(*) FROM post',
            ],
        ]//上述代码表示页面缓存只在 index 动作时启用，页面内容最多被缓存 60 秒，会随着当前应用的语言更改而变化。如果文章总数发生变化则缓存的页面会失效。
    ];
}
```

# 5. http缓存
利用客户端 缓存

```
public function behaviors()
{
    return [
        [
            'class' => 'yii\filters\HttpCache', //这是http缓存
            'only' => ['index'],    //选
            //用LM最后修改时间来判断是否发生更改
            'lastModified' => function ($action, $params) {
                return filemtime('hw.txt');
            },
            //用etag哈希值判断是否发生更改
            'etagSeed' => function ($action, $params) {
                $fp = fopen('hw.txt','r');  //以读取方式打开文件
                $title = fgets($fp);    //读取第一行内容
                fclose($fp);    //关闭文件
                return $title;  //返回标题。如果标题未变，则使用缓存。
            },
        ],
    ];
}

public function actionIndex(){
    $content = file_get_contents('hw.txt');
    return $this->renderPartial('index',['new'=>$content]); //把hw里的文本传给index视图
}
```
