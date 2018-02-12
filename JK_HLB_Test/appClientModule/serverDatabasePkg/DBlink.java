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
	
	// 驱动程序名
	private String driverName = "com.mysql.jdbc.Driver";
	// 数据库用户名
	private String userName = "root";
	// 密码
	private String userPasswd = "thbl123";
	// 数据库名
	private String dbName = "haolaoban";
	// 表名
	private String tableName = "test_users";
	// 联结字符串
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
	// 关闭数据库连接
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

		// 获得数据结果集合
		ResultSetMetaData rmeta;
		try {
			statement = connection.createStatement();
			
			rs = statement.executeQuery(sql);
			rmeta = rs.getMetaData();
			// 确定数据集的列数，亦字段数
			int numColumns = rmeta.getColumnCount();
			System.out.println(numColumns);
			
			// 输出每一个数据值
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
			System.out.print("数据库操作成功，恭喜你");
			rs.close();
			statement.close();
				
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
