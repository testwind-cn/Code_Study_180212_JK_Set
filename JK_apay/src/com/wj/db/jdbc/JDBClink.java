package com.wj.db.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;


//private static String the_str = "jdbc:mysql://ddd-acewind.tenxapp.com:59210/test";
//private static String the_user = "admin";
//private static String the_passwd = "IoNvUwN4Teo6";


public class JDBClink {
	
	String sql  = "SELECT * from the_user";
	Connection conn = null;
	Statement st = null;
	ResultSet rs = null;
	
	private static Connection the_conn = null;
	private static String the_str = "jdbc:mysql://127.0.0.1:3306/haolaoban";
	private static String the_user = "root";
	private static String the_passwd = "thbl123";
	
	public static Connection getConnection(){
    	
    	if ( the_conn != null )
    		return the_conn;
    	
    	try {
    		Class.forName("com.mysql.jdbc.Driver");
//			conn = DriverManager.getConnection("jdbc:mysql://127.3.65.130:3306/good","adminXWhfEjP","xiK1_8lvsT6G");
    		the_conn = DriverManager.getConnection(the_str,the_user,the_passwd);

    	}catch(Exception e){
		//	aa = e.toString();
		}finally {
			
		}
    	
    	return the_conn;	
    }
	private void closeConnection(){
		if (the_conn !=null ){
			try {
				the_conn.close();
			}catch(Exception e){
				
			}finally {
				the_conn = null;
			}
		}
	}
	public static void insert(){
		Connection conn = getConnection();
		try {
			String sql = "INSERT INTO the_user(name,passwd,email) VALUES ('Tom_jdbc','1234','sss@gmail.com')";
			Statement st = the_conn.createStatement();
			int count = st.executeUpdate(sql);
			
		}catch(Exception e){
			e.printStackTrace();
			
		}finally {
			
		}
	}
	public static void update(){
		Connection conn = getConnection();
		try {
			String sql = "UPDATE the_user SET passwd='weweww' WHERE name='wewe'";
			Statement st = the_conn.createStatement();
			int count = st.executeUpdate(sql);
			
		}catch(Exception e){
			e.printStackTrace();
			
		}
		
	}
//	public static void main(String[] args) {

//	}

}
