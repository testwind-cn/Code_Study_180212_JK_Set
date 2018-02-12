package com.wj.db_backup_old.dao.util;

import java.io.InputStream;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class ConnectionFactory {
	private static String driver_1;
	private static String dburl_1;
	private static String user_1;
	private static String password_1;
	
	private static String driver_2;
	private static String dburl_2;
	private static String user_2;
	private static String password_2;
	
	private static final ConnectionFactory factory = new ConnectionFactory();
	
	private Connection conn;
	
	static{
		Properties prop = new Properties();
		try {
			InputStream in = ConnectionFactory.class.getClassLoader().getResourceAsStream("dbconfig.properties");
			//http://riddickbryant.iteye.com/blog/436693
			prop.load(in);
		}catch(Exception e){
			
			System.out.println("======配置信息读取错误=====");
			
		}
		driver_1 = prop.getProperty("driver_1");
		dburl_1 = prop.getProperty("dburl_1");
		user_1 = prop.getProperty("user_1");
		password_1 = prop.getProperty("password_1");
		
		driver_2 = prop.getProperty("driver_2");
		dburl_2 = prop.getProperty("dburl_2");
		user_2 = prop.getProperty("user_2");
		password_2 = prop.getProperty("password_2");
		
		System.out.println("======配置信息读取正确=====");
		
	}
	private ConnectionFactory(){
		
	}
	
	public static ConnectionFactory getInstance(){
		System.out.println("======getInstance=====");
		return factory;
	}
	
	public Connection makeConnection(){
		
		boolean needRelink = false;
		boolean isLocal = false;
		
		String addr="";
		String name="";
		try {
			name = InetAddress.getLocalHost().getHostName();
			addr = InetAddress.getLocalHost().getHostAddress();
		} catch (UnknownHostException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}//获得本机IP
		
		if ( addr.startsWith("10") )  // addr.startsWith("54");
			isLocal = true;

		
		try {
			if ( conn == null || conn.isClosed() )
				needRelink = true;
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			needRelink = true;
		}
		
		
		if ( needRelink )
			try {
				// conn = DriverManager.getConnection("jdbc:mysql://127.3.65.130:3306/good","adminXWhfEjP","xiK1_8lvsT6G");
				if ( isLocal )
				{
					Class.forName(driver_1);
					conn = DriverManager.getConnection(dburl_1, user_1, password_1);
				}
				else
				{
					Class.forName(driver_2);
					conn = DriverManager.getConnection(dburl_2, user_2, password_2);
				}

			} catch (Exception e) {
				// aa = e.toString();
				e.printStackTrace();
			} finally {

			}
		return conn;
	}
	
	public void closeConnection(){
		
		boolean needClose = false;
		
		try {
			if ( conn == null || conn.isClosed() )
				needClose = false;
			else
				needClose = true;
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			needClose = false;
		}
		if ( needClose && conn != null )
		{
			try {
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		conn = null;
	}
}
