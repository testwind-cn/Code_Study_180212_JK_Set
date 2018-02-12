package com.jike.spring.chapter04.instance;

public class HelloWorldImpl implements HelloWorld {

    private String message;

    /**
     * 空构造器
     */
    public HelloWorldImpl() {
        this.message = "Hello World!";
    }

    /**
     * 带参构造器
     * 
     * @param message
     */
    public HelloWorldImpl(String message) {
        this.message = message;
    }

    public void sayHello() {
        System.out.println(message);
    }

}
