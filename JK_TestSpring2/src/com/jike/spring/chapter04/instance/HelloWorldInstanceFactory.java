package com.jike.spring.chapter04.instance;

public class HelloWorldInstanceFactory {
     
	 /**
     * 工厂方法 
     * 
     * @param message
     * @return
     */
    public HelloWorld newInstance(String message) {
        // 返回需要的Bean实例
        return new HelloWorldImpl(message);
    }

}
