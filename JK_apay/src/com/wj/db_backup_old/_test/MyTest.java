package com.wj.db_backup_old._test;

import java.net.InetAddress;
import java.sql.Connection;

import com.wj.db_backup_old.dao.util.ConnectionFactory;


/**
 * 什么都没有，就一个空 Test，连接下 数据库
 */

public class MyTest {

	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("======程序开始=====");
		ConnectionFactory cf =ConnectionFactory.getInstance();
		Connection conn = cf.makeConnection();
		System.out.println(conn.getAutoCommit());
		
		String addr = InetAddress.getLocalHost().getHostName();//获得本机IP  
		String name = InetAddress.getLocalHost().getHostAddress();
		System.out.println( name+"  "+addr);

	}

}
