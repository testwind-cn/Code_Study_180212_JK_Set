package com.wj.db._test;

import java.sql.Connection;

import com.wj.db.dao.entity.User;
import com.wj.db.dao.impl.UserDaoImpl;
import com.wj.db.dao.intface.DaoIntface;
import com.wj.db.dao.service.UserService;
import com.wj.db.dao.util.ConnectionFactory;


/**
 * 什么都没有，就一个空 Test，连接下 数据库，测试下 DAO
 */

public class UserDaoTest {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		UserService serv = new UserService();
		User tom = new User();
		tom.setName("Tom14");
		tom.setPassword("1234");
		tom.setEmail("eee@sina.com");
		
		serv.enumdata("1");
	}

}
