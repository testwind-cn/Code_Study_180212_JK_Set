/**
 * 
 */
package serverDatabasePkg;

import java.util.*;
import java.sql.*;
import com.mysql.jdbc.Driver;


/**
 * @author DEV
 *
 */
public class DBlink {
	
	// ����������
	private String driverName = "com.mysql.jdbc.Driver";
	// ���ݿ��û���
	private String userName = "root";
	// ����
	private String userPasswd = "thbl123";
	// ���ݿ���
	private String dbName = "haolaoban";
	// ����
	private String tableName = "test_users";
	// �����ַ���
	private String url = "jdbc:mysql://localhost/" + dbName + "?user=" + userName + "&password=" + userPasswd;
	
	private Connection connection=null;
	
	private boolean the_is_init = false;
	

	public boolean isInit() {
		return the_is_init;		
	}
	
	public void InitDB() {
		
		the_is_init = false;
		
		try {
			Class.forName(driverName).newInstance();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			connection = DriverManager.getConnection(url);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return;
		}
		the_is_init = true;
		
	}
	// �ر����ݿ�����
	public void closeDB() {
		boolean isClose = true;
		
		if ( connection == null ) {
			the_is_init = false;
			return;
		}
		
		try {
			isClose = connection.isClosed();
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		if ( isClose ) {
			connection = null;
			the_is_init = false;
			return;
		}
	
		try {
			connection.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		connection = null;
		the_is_init = false;	
	}
	
	public Statement createStatement(){
		try {
			if ( connection != null )
				return connection.createStatement();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	public void set() {
		
		Statement statement=null;
		String sql = "SELECT * FROM " + tableName;
		ResultSet rs=null;
		
		if ( isInit() == false ){
			InitDB();
		}

		// ������ݽ������
		ResultSetMetaData rmeta;
		try {
			statement = connection.createStatement();
			
			rs = statement.executeQuery(sql);
			rmeta = rs.getMetaData();
			// ȷ�����ݼ������������ֶ���
			int numColumns = rmeta.getColumnCount();
			System.out.println(numColumns);
			
			// ���ÿһ������ֵ
			System.out.print("id");
			System.out.print("|");
			System.out.print("num");
			System.out.print("<br>");
			while (rs.next()) {
				System.out.print(rs.getString(2) + " ");
				System.out.print("|");
				System.out.print(rs.getString(3));
				System.out.print("<br>");
			}
			System.out.print("<br>");
			System.out.print("���ݿ�����ɹ�����ϲ��");
			rs.close();
			statement.close();
				
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
