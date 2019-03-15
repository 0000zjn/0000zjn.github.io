---
title: Yii博客系统实战
date: 2017-07-17 19:55
tags: PHP
toc: true
---
> 基于Yii框架的博客系统的开发记录，自用，他人勿看。

<!-- more -->

# 1.基础配置
## 1.1高级版：初始化-开发环境

## 1.2连接数据库
basic/config/db.php 或
advanced\common\config\main-local.php

## 1.3修改HOSTS、服务器配置
```
<VirtualHost *:80>
	ServerName localhost
	DocumentRoot I:/ProgramFiles/wamp64/www
	<Directory  "I:/ProgramFiles/wamp64/www/">
		Options +Indexes +Includes +FollowSymLinks +MultiViews
		AllowOverride All
		#使用.htaccess文件作为配置
		Require local
		# Require all granted
		# 换上这句即可局域网访问
	</Directory>
</VirtualHost>
```

## 1.4路由配置优化
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

## 1.5语言包配置
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

## 1.6 独立的用户系统
### 1.6.1 模型的区分
`models`分为`***Form.php`表单模型和`User.php`这种数据模型

### 1.6.2设计思路
1. 前后台数据表分离：user&admin
2. 代码调整
 1. 表单模型放在前后台中，`数据模型`放在common（移动LoginForm.php到前后台修改命名空间）
 2. 配置文件`config/main.php`
 3. 修改`表单模型`里的数据模型对应
 4. 前后台`站点控制器`的表单use的命名空间
 5. 语言包

# 2. 前台开发
## 2.1 前台布局
在main.php框架中：

### 2.1.1 菜单导航
+ 删除修改导航栏目改成left/rightMenus
+ 修改l/r相关代码

### 2.1.2登陆显示
+ 放入头像
`'label' => '<img src ="。。。">',`
为后期方便，位置调用参数显示，在config/params.php中加入
```
'avatar' => [
        'small' => '/statics/images/avatar/small.jpg',
    ]
```
+ 在对应的`Nav::widget()`中加入`'encodeLabels'=>false,`关闭代码过滤
+ 修改对应样式css文件
+ `linkOptions`：添加词缀，每个`'label'`是一个`<a>`。
+ 添加`'items'`下拉框

### 2.1.3 引入font-awesome
1. 放入文件夹到css下
2. 在`assets/AppAsset.php`静态资源管理中添加min.css引用
```
$rightMenus[] = [
    'label' => '<img src ="'.Yii::$app->params['avatar']['small'].'" alt="'.Yii::$app->user->identity->username.'">',
    'linkOptions' => ['class'=>'avatar'],
    'items' => [
        ['label' => '<i class="fa fa-sign-out"></i> 退出','url' => ['/site/logout'],'linkOptions' => ['data-method'=>'post']],
    ],
];
```

## 2.2 登录注册
### 2.2.1 重复密码&验证码
+ SignupForm里加入对应字段、配置
```
public $rePassword;
public $verifyCode;

public function rules()
{
    return [
        ['username', 'match','pattern'=>'/^[(\x{4E00}-\x{9FA5})a-zA-Z]+[(\x{4E00}-\x{9FA5})a-zA-Z_\d]*$/u','message'=>'用户名由字母，汉字，数字，下划线组成，且不能以数字和下划线开头。'],
    
        [['password','rePassword'], 'required'],
        [['password','rePassword'], 'string', 'min' => 6],
        ['rePassword','compare','compareAttribute'=>'password','message'=>\Yii::t('common', 'Tow times the password is not consitent.')],
    
        ['verifyCode', 'captcha'],
    ];
}
public function attributeLabels()
{
    return[
        'rePassword'=>'重复密码',
        'verifyCode'=>'验证码',
    ];
}
```
+ 视图中加入对应输入框

```
use yii\captcha\Captcha;
//--------------------------
<?= $form->field($model, 'rePassword')->passwordInput() ?>

<?= $form->field($model, 'verifyCode')->widget(Captcha::ClassName()) ?>
```

## 2.3创建文章控制器和数据表
1. 设置前台控制器基类
 1. 创建`base/BaseController.php`和`PostController`控制器
 2. 使`SiteController`、`PostController`继承`BaseController`
2. 创建`post/index.php`视图
3. 创建数据表

## 2.4创建文章模型Form&Model
1. Gii在common里创建数据模型`PostModel`(可以使用语言包)
2. 设置公共数据模型基类
 1. 创建`base\BaseModel.php`
 2. 其他Model`use`&`extends`基类模型
3. 创建`PostForm`表单模型

## 2.5创建文章功能
### 2.5.1表单生成
1. 在文章控制器`PostController`中加入创建文章`Create`操作
2. `post`视图文件夹中创建`create`页面
 1. 面包屑
 2. 表单（字段限于`PostForm`中定义的）

### 2.5.2分类表单
1. 创建分类模型`CatModel`
2. 获取分类数据
 1. 修改模型继承
 2. 创建取数据方法`getAllCats()`
 3. 在控制器调用取数据方法并渲染

### 2.5.3组件-标签图上传
- 按说明下载安装图片上传拓展
 `http://www.yii-china.com/post/detail/15.html`

### 2.5.4组件-富文本编辑器
- 按说明下载安装拓展
 `http://www.yii-china.com/post/detail/3.html`

### 2.5.5组件-标签
- 从教程资源包中取出tags放入common\widgets
- 编辑`create`视图和样式

### 2.5.6定义场景与文章创建逻辑
创建应用：场景
场景：不同场景能使用的列不同
1. 在表单模型中创建场景：
 1. 定义常量作为场景名`const SCENARIOS_UPDATE = 'update'；`
 2. 重写`scenarios()`
 3. 在`rules()`里`on`要应用的场景
2. 在控制器的`create`行为中使用场景
 1. 定义表单要使用的场景
 2. 使用表单模型中的create事务

### 2.5.7文章create事务方法
事务：作为单个逻辑工作单元执行的一系列操作(数据库概念)
在表单模型创建`create`事务：
1. 表单模型use数据模型
2. 给数据模型对象赋值
3. save()
4. 设计`_getSummary()`函数截取文章摘要

### 2.5.8文章创建后-使用事件
```
public function _eventAfterCreate($data)
{
    //向常量事件中添加(绑定)事件(事件名,[对象,方法],参数)
    $this->on(self::EVENT_AFTER_CREATE,[$this,'_eventAddTag'],$data);
    //触发事件
    $this->trigger(self::EVENT_AFTER_CREATE);
}
```

### 2.5.9标签功能
1. 创建标签表单模型`TagForm`
2. 生成文章-表单关系数据模型`RelationPostTagModel`
3. 在文章表单`PostForm`code 添加标签`_eventAddTag`函数
```
public function _eventAddTag($event)
{
    //保存标签

    //删除原先的关联

    //批量保存文章和标签的关联关系

        //批量插入

}
```

## 2.6文章展示
### 2.6.1文章详情
1. 控制器中加入`actionView($id)`
2. 创建`views/post/view.php`
3. `PostForm`添加`getViewById($id)`访问文章
 1. 查询
 2. 处理格式
 3. 返回
4. `PostModel`&`RelationPostTagModel`中添加`getRelate()`&`getTag()`

### 2.6.2文章统计
1. 建表、`PostExtendModel`
2. 在控制器-文章详情操作里添加`upCounter()`
3. 在model中code`upCounter()`
4. `PostForm`里添加查询关联`with('relate.tag', 'extend')`
5. `PostModel`里添加`getExtend()`关联
6. view添加浏览的数据`<?=isset($data['extend']['browser'])?$data['extend']['browser']:0?>`

### 2.6.3组件-文章列表
小部件：通过封装组件实现功能
部件调用表单，表单调用模型，在要使用的视图中use`yii\base\Widget;`和要使用的部件，在要展现的地方插入`<?=部件名::widget();?>`
1. 创建挂件文件结构
2. code文章列表组件`PostWidget`调用`PostForm`的`getList()`
3. 在文章表单添加 获取文章列表`getList()`调用`_formatList`&`BaseModel`的`getPages()`

## 2.7博客首页
### 2.7.1组件-图片轮播
1. 制作轮播组件`frontend\widgets\banner`
2. 使用`<?=BannerWidget::widget()?>`

### 2.7.2组件-留言板
1. 创建表和模型
2. 创建表单，添加获取留言板数据`getList()`和添加留言`create()`函数
3. 创建chat挂件
4. 在`site/index.php`里添加chat组件
4. 添加js（ajax），修改AppAsset
5. 在SiteController里添加接收

### 2.7.3组件-热门浏览
1. 制作轮播组件`frontend\widgets\hot`
2. 使用`<?=HotWidget::widget()?>`

### 2.7.4标签云
