---
title: Yii框架实战的思路、技术整理
date: 2017-07-28 13:08
updated: 2017-07-28 13:08
tags: PHP
toc: true
---
> 记录基于Yii框架实战的思路、技术整理，自用，他人勿看。

<!-- more -->

## 1. 基础配置
---
### 1.1 高级版：初始化-开发环境
---
### 1.2 连接数据库

basic/config/db.php 或
advanced\common\config\main-local.php
<!-- more -->

---
### 1.3 修改HOSTS、服务器配置模板
```
<VirtualHost *:80>
	ServerName localhost
	DocumentRoot I:/ProgramFiles/wamp64/www
	<Directory  "I:/ProgramFiles/wamp64/www/">
		Options +Indexes +Includes +FollowSymLinks +MultiViews
		AllowOverride All#使用.htaccess文件作为配置
		Require local
		# Require all granted# 换上这句即可局域网访问
	</Directory>
</VirtualHost>
```
---
### 1.4 路由配置优化
1.去掉index.php
将下面代码添加至`/web/.htaccess`中或添加至服务器路由配置`<Directory  ""></Directory>`中
```
# 开启 mod_rewrite 用于美化 URL 功能的支持（译注：对应 pretty URL 选项）
RewriteEngine on
# 如果请求的是真实存在的文件或目录，直接访问
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
# 如果请求的不是真实文件或目录，分发请求至 index.php
RewriteRule . index.php
```
2.路由优化
将下面的代码添加至`frontend\config\main.php` `components`中
```
'urlManager'=>[

             'enablePrettyUrl' => true, //对url进行美化

             'showScriptName' => false,//隐藏index.php

            //  'suffix' => '.html',//后缀

            //  'enableStrictParsing'=>FALSE,//不要求网址严格匹配，则不需要输入rules

            //  'rules' => []//网址匹配规则

        ],
```
---
### 1.5 语言包配置(选)
注意大小写
1.开启语言`frontend\config\main.php` `return[]`加入
```'language' => 'zh-CN',//这时已经可以使用自带的部分翻译```
2.添加自己的词库配置到`components`中
```
'i18n' => [
            'translations' => [
                '*' => [
                    'class' => 'yii\i18n\PhpMessageSource',
                    // 'basePath' => '/messages',//默认
                    'fileMap' => [
                        'common' => 'common.php',//有多个包可以并列下去
                    ],
                ],
            ],
        ],
```
3.创建自定义的语言包`frontend/messages/zh-CN/common.php`，名字和上面对应
```
<?php
return[
    'Blog'=>'博客',
];
```
4.使用
1:main视图中
```
['label' => 'Home', 'url' => ['/site/index']],
//改成
['label' =>Yii::t('yii','Home'), 'url' => ['/site/index']],
//使用了yii自带的语言包，同理：
['label' =>Yii::t('common','Home'), 'url' => ['/site/index']],
//就使用了自定义的语言包
```
2:对于视图中`<?= $form->field($model, 'email') ?>`格式，在模型中添加翻译：
```
public function attributeLabels()
{
    return[
        'username'=>'用户名',
        'email'=>\Yii::t('common', 'Email'),
    ];
}
```
---
### 1.6 独立的用户系统

#### 1.6.1 模型的区分
`models`分为`***Form.php`表单模型和`User.php`这种数据模型

#### 1.6.2 设计思路
1. 前后台数据表分离：user&admin
2. 代码调整
 1. 表单模型放在前后台中，`数据模型`放在common（移动LoginForm.php到前后台修改命名空间）
 2. 配置文件`config/main.php`
 3. 修改`表单模型`里的对应数据模型的使用
 4. 前后台`站点控制器`的表单use的命名空间
 5. 语言包

---
## 2. 技术点
---
### 2.1 部件的使用

---
### 2.2 查询方法
#### 2.2.1 Query
#### 2.2.2 *Model::find()

---
### 2.3 params的使用
```
//params.php中
return [
    'avatar' => [
        'small' => '/statics/images/avatar/small.jpg',
    ]
];
//view中
<img src ="'.Yii::$app->params['avatar']['small'].'" alt="'.Yii::$app->user->identity->username.'">
```
---
### 2.4 禁用自带的 Yii、JQuery 和 Bootstrap 脚本
- 去除 Yii.js 相关脚本
编辑 `frontend\asset\AppAsset.php` 文件，注释掉变量 `$depends` 里的 `yii\web\YiiAsset` 值。
编辑 `frontend\config\main.php` 文件，在字段 `components` 下面添加配置：
```
'assetManager' => [
 'bundles' => [
     'yii\web\YiiAsset' => [
         'js' => [],  // 去除 yii.js
         'sourcePath' => null,  // 防止在 frontend/web/asset 下生产文件
     ],
                        
     'yii\widgets\ActiveFormAsset' => [
         'js' => [],  // 去除 yii.activeForm.js
         'sourcePath' => null,  // 防止在 frontend/web/asset 下生产文件
     ],
        
     'yii\validators\ValidationAsset' => [
         'js' => [],  // 去除 yii.validation.js
         'sourcePath' => null,  // 防止在 frontend/web/asset 下生产文件
     ],
 ],
],
```
- 去除 JQuery 脚本
编辑 frontend\config\main.php 文件，在字段 'components' 下面添加配置：
```
'assetManager' => [
    'bundles' => [
        'yii\web\JqueryAsset' => [
            'js' => [],  // 去除 jquery.js
            'sourcePath' => null,  // 防止在 frontend/web/asset 下生产文件
        ],
    ],
],
```
- 去除 Bootstrap 库
编辑 `frontend\asset\AppAsset.php` 文件，注释掉变量 `$depends` 里的 `yii\bootstrap\BootstrapAsset` 值。
编辑 `frontend\config\main.php` 文件，在字段 `components` 下面添加配置：
```
'assetManager' => [
 'bundles' => [
     'yii\bootstrap\BootstrapAsset' => [
         'css' => [],  // 去除 bootstrap.css
         'sourcePath' => null, // 防止在 frontend/web/asset 下生产文件
     ],
     'yii\bootstrap\BootstrapPluginAsset' => [
         'js' => [],  // 去除 bootstrap.js
         'sourcePath' => null,  // 防止在 frontend/web/asset 下生产文件
     ],
 ],
],
```
---
### 2.5 AppAsset前端资源使用
tips:
1. 如果在其他地方注册资源包，应提供视图对象，如在 小部件 类中注册资源包， 可以通过 $this->view 获取视图对象。
2. 代码块用registerJs，代码文件用registerJsFile
3. @web是可省的
法一：资源包
```
/***************AppAsset中***************/
public $basePath = '@webroot';  //类指定资源文件放在 @webroot 目录下
public $baseUrl = '@web';       //对应的URL为 @web
public $css = [
    'css/site.css',             //资源包中包含一个CSS文件 css/site.css
];
public $js = [                  //没有JavaScript文件
];
public $depends = [             //依赖其他两个包
    'yii\web\YiiAsset',
    'yii\bootstrap\BootstrapAsset',
];

/***************视图中使用***************/
use frontend\assets\AppAsset;    //别忘了use
AppAsset::register($this);      //按AppAsset注册
```

法二：自定方法
```
/***************AppAsset中***************/
//自定方法，然后在视图中注册
public static function addScript($view, $jsfile) {
    $view->registerJsFile($jsfile, [AppAsset::className(), 'depends' => 'frontend\assets\AppAsset', 'position'=>\yii\web\View::POS_END]);
    
//如果不加depends，自定方法的渲染优先级高于AppAsset，so会先于jq渲染，so必加
//二参的position指明加载位置
}

/***************视图中使用***************/
use frontend\assets\AppAsset;
AppAsset::addScript($this,'@web/statics/js/ui.js');//使用自定方法注册
```

法三：registerCssFile
```
//会先于AppAsset渲染
$this->registerCssFile('/statics/css/denglu.css');
```

法四：嵌入式
```
//嵌入式的优先级最低，代码最后渲染
$this->registerJs('
    $(document).ready(function(){//直接使用
    });
');
```

法五：元素块-不建议
```
<div id="mybutton">点我弹出OK</div>

<?php $this->beginBlock('test') ?>  
    $(function($) {
      $('#mybutton').click(function() {
        alert('OK');
      });
    });
<?php $this->endBlock() ?>
<?php $this->registerJs($this->blocks['test'], \yii\web\View::POS_END); ?>

POS_HEAD——head结束标签之前：$this->registerJs('alert(4)',View::POS_HEAD);
POS_BEGIN——body开始标签之后：$this->registerJs('alert(4)',View::POS_BEGIN);
POS_END——body结束标签之前：$this->registerJs('alert(4)',View::POS_END);
POS_READY POS_LOAD：$this->registerJs('alert(4)', View::POS_READY);
```

法六：等同于直接写
```
<?= Html::jsFile('@web/js/main.js'); ?>
<?= Html::script('alert("Hello!");', ['defer' => true]);
<?= Html::cssFile('@web/css/ie5.css', ['condition' => 'IE 5']) ?>//<!--[if IE 5]><![endif]-->
<?= Html::style('.danger { color: #f00; }') ?>
```
---
### 2.6 init() run()函数略解
```
如在插件中：
class TopMenu extends Widget{
    public function init(){
        parent::init();
        echo '<ul>'；
    }
    public funtion run(){
        return '</ul>';
    }
    public function addMenu($menuName){
        return '<li>'.$menuName.'</li>';
    }
}

视图中：
<?php $menu = TopMenu::begin();?>
//输出<ul>
<?=$menu->addMenu('menu1');?>
<?=$menu->addMenu('menu12');?>
<?php TopMenu::begin();?>
//输出</ul>
```
---
## 3. 基本流程
---
### 3.1 活动记录（数据模型）和控制器设置基类
```
//---------------base/BaseModel.php-------------------
<?php
namespace common\models\base;
/**
*基础模型
*/
use yii\db\ActiveRecord;

class BaseModel extends ActiveRecord
{}

//------------base/BaseController.php---------------------
<?php
namespace frontend\controllers\base;
/**
*基础控制器
*/
use yii\web\Controller;

class BaseController extends Controller
{
    public function beforeAction($action)
    {
        //检测-如果父级的beforeAction返回的是不通过
        if (!parent::beforeAction($action)) {
            return false;
        }
        return true;
    }
}
```
### 3.2 创建数据库&数据模型
use Gii
### 3.3 创建表单模型
+ 字段
+ 规则`rules()`
+ 字段名称（标签属性）`attributeLabels()`

### 3.4 创建控制器
+ 创建行为action
 + new表单对象
 + 渲染视图`return $this->render('create',['model'=>$model]);`

### 3.5 创建视图view
