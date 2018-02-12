package com.jike.spring.chapter04.instance;

import org.springframework.beans.factory.BeanFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {

	public static void main(String[] args) {
		helloWorldInstanceFactory();
	}
	
	//使用无参数构造器来实例化Bean
	public static void sayHelloWithNoArgs() {
		BeanFactory beanFactory = 
				new ClassPathXmlApplicationContext("conf/conf-instance.xml");
		HelloWorld helloWorld = beanFactory.getBean("helloWorldWithNoArgs", HelloWorld.class);
		helloWorld.sayHello();
	}
	//使用有参数构造器来实例化Bean
	public static void sayHelloWithArgs() {
		BeanFactory beanFactory = 
				new ClassPathXmlApplicationContext("conf/conf-instance.xml");
		HelloWorld helloWorld = beanFactory.getBean("helloWorldWithArgs", HelloWorld.class);
		helloWorld.sayHello();
	}
	

	//使用静态工厂方法来实例化Bean
    public static void helloWorldStaticFactory() {
        // 1、读取配置文件实例化一个IOC容器
    	BeanFactory beanFactory = 
        		new ClassPathXmlApplicationContext("conf/conf-instance.xml");
        // 2、从容器中获取Bean，注意此处完全“面向接口编程，而不是面向实现”
    	HelloWorld helloWorld 
    	= beanFactory.getBean("helloWorldStaticFactory", HelloWorld.class);
        // 3、执行业务逻辑
    	helloWorld.sayHello();
    }

    //使用实例化工厂方法来实例化Bean
    public static void helloWorldInstanceFactory() {
        // 1、读取配置文件实例化一个IOC容器
    	BeanFactory beanFactory = 
        		new ClassPathXmlApplicationContext("conf/conf-instance.xml");
        // 2、从容器中获取Bean，注意此处完全“面向接口编程，而不是面向实现编程”
    	HelloWorld helloWorld 
    	= beanFactory.getBean("helloWorldInstance", HelloWorld.class);
        // 3、执行业务逻辑
    	helloWorld.sayHello();
    }
}
