/**
 * 
 */
package serverServicePkg;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author DEV
 *
 */
public class ServerApp {

	private static serverDatabasePkg.DBlink theDB=null;


	private static void InitServerAppDB(){
		if ( theDB == null ) {
			theDB = new serverDatabasePkg.DBlink();
			theDB.InitDB();
		} else if ( theDB.isInit() == false ){
			theDB.InitDB();
		}
	}
	
	public static ResultSet getResultSet(String sql){
		
		Statement statement=null;
		ResultSet rs;
		
		InitServerAppDB();
		
		statement = theDB.createStatement();
		
		try {
			rs = statement.executeQuery(sql);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
		return rs;		
	}
	
	public static String new_login_session( int user_id, String localip ) {
		
		InitServerAppDB();
//		String sql = String.format("select * from user_login_session where user_id='%d' and localip='%s'", user_id,localip);
		java.util.UUID uuid = java.util.UUID.randomUUID();
		System.out.println(uuid); // debug

		java.util.Date curdate=new java.util.Date();
		java.text.DateFormat dateformat=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String time=dateformat.format(curdate); //		'2009-06-08 23:53:17'
		System.out.println(time); // debug
		
		String sql = String.format(
"insert into user_login_session (user_id,localip,login_token,login_start,login_last_link) values ('%d','%s','%s','%s','%s')",
				user_id,localip,uuid.toString(),time,time);
		
		
		Statement statement=null;
		
		try {
			statement = theDB.createStatement();
			statement.execute(sql);
			statement.close();
			return uuid.toString();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return null;
	}
	
	public static String Login(String name, String passwd, String localip){
		
		
		String login_token = null;
		
		int user_id = 0;
		
		// 检查用户名密码
        user_id = checkUserandPassword(name, endecrypt.MD5Util.string2MD5(passwd));
        // 用户名密码正确后，就产生登录token
        if ( user_id > 0 ) {
        	login_token = new_login_session(user_id,localip);
        }
        
        return login_token;
	}
	
	
	public static int checkUserandPassword(String name,String passwd) {
		
		int user_id = 0;
		Statement statement=null;
		ResultSet rs=null;
		String table = "users";
		String sql = "SELECT * FROM " + table + " WHERE LOGIN_NAME='"+name+"' and PASSWORD ='"+passwd+"'";
		

		InitServerAppDB();

		
		try {
			statement = theDB.createStatement();
			
			rs = statement.executeQuery(sql);
			
			// 输出每一个数据值
			while (rs.next()) {
				
				user_id = rs.getInt("USER_ID");
				System.out.print( user_id );
				System.out.print("数据库操作成功，恭喜你");
			}

			rs.close();
			statement.close();
				
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			user_id = 0;
		}
		
		return user_id;
	}
}
