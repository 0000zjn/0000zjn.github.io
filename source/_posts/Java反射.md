﻿---
title: Java反射
date: 2018-06-17 23:36
tags: JAVA
---

# 1. 获取类信息

<!-- more -->

1. 获取指定类对应的Class对象
    1. `Class c = ArrayList.class;`
    2. `Class c = list.getClass();`
    3. `Class c = Class.forName("java.util.ArrayList");//并加载指定的类`
2. 获取包名
`String packageName = c.getPackage().getName();`
3. 获取类的修饰符
`int mod = c.getModifiers();`
`String modifier = Modifier.toString(mod);`
4. 类的全限定名
`String className = c.getName();`
5. 父类
`Class superC = c.getSuperclass();`
6. 实现的接口
`Class interfaces = c.getInterfaces();`
7. public变量/成员变量及操作
`Field[] fields = c.getFields();`
`Field[] fields = c.getDeclaredFields();`
`Field field = c.getDeclaredField("变量名");`
`field.set(对象,"变量值")`
8. 构造方法
`Constructor[] constructors = c.getDeclaredConstructors();`
9. public方法(包括父类)/自己的的成员方法
`Method[] methods = c.getMethods();`
`Method[] methods = c.getDeclaredMethods();`
10. 通过类的类类型创建该类的对象实例
`String str = (String)c1.newInstance();//需要有无参数的构造方法`

# 2. 创建对象
```
Class c = Class.forName("java.util.ArrayList");
List list = (List)c.newInstance();
```

# 3. 方法反射
`方法对象.invoke(类对象,参数表);`
```
public class MethodDemo1 {
	public static void main(String[] args) {
        /**目标：要获取print(int,int)方法
         *获取一个方法就要获取类的信息
         *1.获取类的信息首先要获取类的类类型
         */
		A a1 = new A();
		Class c = a1.getClass();
        try {
            /*2.获取方法 名称和参数列表来决定  
             * getMethod获取的是public的方法
             * getDeclaredMethod自己声明的方法
             */
			Method m2 = c.getMethod("print");
            Method m = c.getDeclaredMethod("print", int.class,int.class);
	    	
            /*3.进行方法的反射操作
             *可用o接返回值
             *没有返回值即null
             *setAccessible(AccessibleObject[] array, boolean flag) 
             *使用单一安全性检查（为了提高效率）
             *为一组对象设置accessible标志的便捷方法。
             *setAccessible(boolean flag) 
             *将单个对象的accessible标志设置为指示的布尔值。
             */
            a1.setAccessible(true);
            Object o = a1.print(10, 20);
            Object o = m.invoke(a1,new Object[]{10,20});
            Object o = m.invoke(a1, 10,20);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
class A{
	public void print(){
		System.out.println("helloworld");
	}
	private void print(int a,int b){
		System.out.println(a+b);
	}
	public void print(String a,String b){
		System.out.println(a.toUpperCase()+","+b.toLowerCase());
	}
}
```




