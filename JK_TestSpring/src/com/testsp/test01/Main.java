package com.testsp.test01;

import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.beans.factory.xml.XmlBeanDefinitionReader;
import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;

public class Main {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
//		Resource r = new FileSystemResource("helloMessage.xml");
//		BeanFactory f = new XmlBeanFactory(r);
//		Person person = (Person ) f.getBean("person");
//		String s =  person.sayHello();
//		System.out.println("Ther person say:" + s);
		


		
	
		ApplicationContext context= new ClassPathXmlApplicationContext("helloMessage.xml");
		Person person= (Person) context.getBean("person");
		String s =  person.sayHello();
		System.out.println("Ther person say:" + s);

		
	}

}
