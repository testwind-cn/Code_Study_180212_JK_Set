package com.jike.spring.chapter04.definition;

import org.springframework.beans.factory.BeanFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {

	public static void main(String[] args) {
		sayHelloWorldById();
	}

	
	public static void sayHelloWorldById() {
		BeanFactory beanFactory = 
				new ClassPathXmlApplicationContext("conf/conf-definition.xml");
		HelloWorld helloWorld = beanFactory.getBean("helloWorld", HelloWorld.class);
		helloWorld.sayHello();
	}
	
	public static void sayHelloWorldByClass() {
		BeanFactory beanFactory = 
				new ClassPathXmlApplicationContext("conf/conf-definition.xml");
		HelloWorld helloWorld = beanFactory.getBean(HelloWorldImpl.class);
		helloWorld.sayHello();
	}
	
	public static void sayHelloWorldByName() {
		BeanFactory beanFactory = 
				new ClassPathXmlApplicationContext("conf/conf-definition.xml");
		HelloWorld helloWorld = beanFactory.getBean("helloWorldByName", HelloWorld.class);
		helloWorld.sayHello();
	}
	
	public static void sayHelloWorldByNameAndId() {
		BeanFactory beanFactory = 
				new ClassPathXmlApplicationContext("conf/conf-definition.xml");
		HelloWorld helloWorld01 = beanFactory.getBean("helloWorldById", HelloWorld.class);
		helloWorld01.sayHello();
		HelloWorld helloWorld02 = beanFactory.getBean("helloWorldByName01", HelloWorld.class);
		helloWorld02.sayHello();
		
	}
	
	public static void sayHelloWorldByMultiName() {
		BeanFactory beanFactory = 
				new ClassPathXmlApplicationContext("conf/conf-definition.xml");
		HelloWorld bean1 = beanFactory.getBean("bean1", HelloWorld.class);
		bean1.sayHello();
		HelloWorld bean11 = beanFactory.getBean("alias11", HelloWorld.class);
		bean11.sayHello();
		HelloWorld bean12 = beanFactory.getBean("alias12", HelloWorld.class);
		bean12.sayHello();
		HelloWorld bean13 = beanFactory.getBean("alias13", HelloWorld.class);
		bean13.sayHello();
		
		HelloWorld bean2 = beanFactory.getBean("bean2", HelloWorld.class);
		bean1.sayHello();
		HelloWorld bean21 = beanFactory.getBean("alias21", HelloWorld.class);
		bean21.sayHello();
		HelloWorld bean22 = beanFactory.getBean("alias22", HelloWorld.class);
		bean22.sayHello();
		HelloWorld bean23 = beanFactory.getBean("alias23", HelloWorld.class);
		bean23.sayHello();
		
		
	}
	
	public static void sayHelloWorldByAlias() {
		BeanFactory beanFactory = 
				new ClassPathXmlApplicationContext("conf/conf-definition.xml");
		HelloWorld bean3 = beanFactory.getBean("bean3", HelloWorld.class);
		HelloWorld bean31 = beanFactory.getBean("alias31", HelloWorld.class);
		HelloWorld bean32 = beanFactory.getBean("alias32", HelloWorld.class);
		bean3.sayHello();
		bean31.sayHello();
		bean32.sayHello();
		
		
	}
}
