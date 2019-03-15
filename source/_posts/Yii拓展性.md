---
title: Yii拓展性
date: 2017-07-16 15:55
tags: PHP
toc: true
---
> 学习Yii框架拓展性时记的笔记。

<!-- more -->

# 1. 模块化技术
## 1.1 用Gii新建模块
1. 进入Module Generator模块生成器
2. Module Class： `app\modules\article\Article`modules下article模块下文章类
Module ID：`article`
3. 添加配置项到config/web.php
4. 生成 在basic下生成modules文件夹，包含Article.php和controllers、views文件夹
5. 如果需要数据模型活动记录，需自行添加文件夹

## 1.2 使用子模块-父模块调用
控制器：
```
public function actionIndex(){
    //获取子模块
    $article = \YII::$app->getModule('article');
    //调用子模块的操作
    $article->runAction('default/index');   //控制器/操作
}
```

## 1.3 直接访问子模块-浏览器访问
```
?r=article/default/index //模块-控制器-操作
```

## 1.4 创建子模块的子模块
Module Class：`app\modules\article\modules\category\Category`
Module ID：`category`
在父模块article/Article.php中添加配置
```
public $controllerNamespace = 'app\modules\article\controllers';

public function init()
{
    parent::init();
    
    $this->modules = [
        'category' => [
            'class' => 'app\modules\article\modules\category\Category`,
        ],
    ];
}
```

# 2. 事件机制
## 2.1 扫描式

## 2.2 绑定式
绑定关系写在控制器里，触发事件写在前置条件后
猫叫触发老鼠跑
在vendor下创建一个`animal`文件夹，创建`Cat.php`&`Mourse.php`&`Dog.php`
1.`Cat.php`
```
<?php
namespace vendor\animal;    //为了实现自动加载，写命名空间
use \yii\base\Component;    //组件类
use \yii\base\Event;        //事件类

class MyEvent extends Event{    //事件方法
    public $message;
}

class Cat extents Component{
    public function shout(){
        echo 'miao miao miao<br>';
        $me = new MyEvent;
        $me->message = 'hello my event<br>';
        $shis->trigger('miao',$me);
        //触发miao事件，一参是事件名，二参是触发事件附带的参数
    }
}
```
2.`Dog.php`
```
<?php
namespace vendor\animal;

class Dog{
    public function look(){
    echo 'i am looking<br>';
    }
}
```
3.`Mourse.php`
```
<?php
namespace vendor\animal;

class Mourse{
    public function run(){
    echo $me->message;
    echo 'i am runing<br>';
    }
}
```
4.`AnimalController.php`
```
namespace app\controllers;
use yii\web\Controller;
use vendor\animal\Cat;  //告诉程序猫和老鼠在哪个命名空间下
use vendor\animal\Mourse;
use vendor\animal\Dog;
use \yii\base\Event;    //类级别的事件管理需要使用event

class AnimalController extends Controller{
    public function actionIndex(){
        $cat = new Cat;
        $cat2 = new Cat;
        $mourse = new Mourse;
        $dog = new Dog;
        
        $cat->on('miao',[$mourse,'run']);   //对象级别的事件管理：对特定的对象起作用(事件名,[对象,方法],参数)
        $cat->on('miao',[$dog,'look']);     //component组件类的捆绑方法,把miao和老鼠的run和狗的look进行绑定
        $cat->off('miao',[$dog,'look']);    //解绑
        
        Event::on(Cat::className(),'miao',[$mourse,'run']);//类也可写成`vendor\animal\Cat`
        //类级事件绑定,所有猫叫都会触发(类名,事件名,[对象,方法],参数)
        
        Event::on(Cat::className(),'miao',function(){
            echo 'miao event has triggered<br>';
        }); //也可以触发匿名函数，实现监听
        
        $cat->shout();
        $cat2->shout();
    }
}
```

# 3. Mixin
使用行为拓展类和对象

## 3.1 类混合
用行为类往一个类中注入新的方法和属性
1.basic下新建behaviors文件夹下新建`Behavior1.php`
```
<?php
namespace app\Behaviors;    //规定命名空间
use yii\base\Behavior;  //行为类
class Behavior1 extends Behavior{   //行为1里有 一个字段和一个方法
    protected $height;
    public function eat(){
        echo 'dog eat<br>';
    }
    
    public function events(){
        return[
            'wang' =>'shout'    //行为1接收wang事件，wang事件会触发shout
        ];
    }
    
    public function shout($event){  //$event 是 yii\base\Event 或其子类的对象
        echo 'wang wang wang<br>';
    }
}
```
2.为`Dog.php`注入行为
```
<?php
namespace vendor\animal;
use app\behaviors\Behavior1;
use YII\base\Component;         //使类 拥有处理事件，转发事件，接收行为 的能力
class Dog extends Component{    //使用行为，需继承Component

    public function behaviors(){    //为Dog类添加 行为1
        return [                    //数组：可以添加多个行为
            Behavior1::className(), //添加了eat方法
        ];
    }
    
    public function look(){
        echo 'i am looking<br>';
    }
}
```
3.`AnimalController.php`
```
namespace app\controllers;
use yii\web\Controller;
use vendor\animal\Dog;

class AnimalController extends Controller{
    public function actionIndex(){
        $dog = new Dog;
        $dog->look();
        $dog->eat();    //添加后就可以直接使用它了
        //echo $dog->height = '15cm'; //报错，因为dog和行为1不是继承，而是注入关系。
        $dog->trigger('wang');  //让这只狗触发wang事件
    }
}
```

## 3.2 对象混合
把别的对象的属性和方法注入到想用的对象








