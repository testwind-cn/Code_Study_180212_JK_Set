/**
 * 
 */
package com.wj.db.dao.service;

import java.io.IOException;
import java.util.Properties;

/**
 * @author DEV
 *其实我没有使用这个工厂，感觉没必要用 WJ 2017-9-19
 */
public class DaoFactory {
	/*----------读取daofactory.properties配置文件*/
	private static Properties prop = new Properties();
	static {
		try {
			prop.load(DaoFactory.class.getClassLoader().getResourceAsStream("daofactory.properties"));
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

	/*-------------将DaoFactory设为单例模式-----------------*/
	private static DaoFactory instance = new DaoFactory();

	private DaoFactory() {
	}

	public static DaoFactory getInstance() {
		return instance;
	}

	/*---------------dao工厂，产生dao的实现类----------------------*/
	public <T> T createDao(Class<T> interfaceClass) { // 传入dao接口的接口名.class，返回接口的实现类
		String simplename = interfaceClass.getSimpleName();
		System.out.println("简单类名是：" + simplename); // UserDao
		String classname = prop.getProperty(simplename); // 从配置文件得到接口的简单类名的完整的impl的实现类名
		
		try {
			return (T) Class.forName(classname).newInstance();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {

			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		return null;
	}
}
