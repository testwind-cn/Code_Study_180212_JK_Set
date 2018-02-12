package com.jike.spring.chapter04.instance;

public class HelloWorldStaticFactory {
	 /**
     * 工厂方法 
     * 
     * @param message
     * @return
     */
    public static HelloWorld newInstance(String message) {
        // 返回需要的Bean实例
        return new HelloWorldImpl(message);
    }

}
