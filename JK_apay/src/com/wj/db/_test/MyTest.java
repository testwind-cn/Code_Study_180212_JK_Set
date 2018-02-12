package com.wj.db._test;


import java.net.InetAddress;
import java.sql.Connection;

import com.wj.db.dao.service.TokenService;
import com.wj.db.dao.util.ConnectionFactory;


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
		
		
		
		// System.out.println( getTokenStr("wx66dded684c14bfd1","e5f1a2b154a810183f1e3032eb289c98") );
		
		TokenService sss = new TokenService();
		System.out.println(sss.RefreshToken());

	}
	
	 

}
