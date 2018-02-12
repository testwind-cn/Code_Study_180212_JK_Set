package com.wj.db.dao.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;

import javax.servlet.http.HttpServlet;

import com.wj.db.dao.entity.Access_token;
import com.wj.db.dao.entity.User;
import com.wj.db.dao.impl.UserDaoImpl;
import com.wj.db.dao.impl.tokenDaoImpl;
import com.wj.db.dao.intface.DaoIntface;
import com.wj.db.dao.util.ConnectionFactory;

public class TokenService {

	private DaoIntface userDao;
	
	private String appid;
	private String secret;
	
	   
    /**
     * 
     */
    public TokenService() {
        super();
        // TODO Auto-generated constructor stub
        appid = "wx66dded684c14bfd1";
        secret = "e5f1a2b154a810183f1e3032eb289c98";
    }
    
    public TokenService(String appid,String secret) {
        super();
        // TODO Auto-generated constructor stub
        this.appid = appid;
        this.secret = secret;
    }
	
    
	/** 
     * 获取URL指定的资源 
     * 
     * @throws IOException 
     */ 
    private String getTokenStr(String appid,String secret ) { 
            URL url;
			try {
				url = new URL("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid="+appid+"&secret="+secret);
			} catch (MalformedURLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return null;
			}

			InputStream ins;
			try {
				ins = url.openStream();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return null;
			}

          //打开到此 URL 的连接并返回一个用于从该连接读入的 InputStream。 
            BufferedReader reader=new BufferedReader(new InputStreamReader(ins)); 
            String s="";
            try {
				while((s=reader.readLine())!=null)
				{
				    System.out.println(s);
				    reader.close(); 
				    return s;
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            try {
				reader.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            return "";
    }
    
    private String getTokenStr()
    {
    	return getTokenStr( appid, secret );
    }
    
    
    public String RefreshToken(boolean force) { // true = 强制刷新
    	
		if ( force == false )
		{
			String s = getCurrentToken();
			if  ( s !=null && s.length() > 0  )
				return s;
		}
		return GenAndSaveToken();
    }
    
    public String RefreshToken() {
    	return RefreshToken(false);
    }
    
    private String getCurrentToken(){
    	
    	Access_token access_token;
    	
    	Connection conn = null;
    	ArrayList alist =null;
    	userDao = new tokenDaoImpl(); // = DaoFactory.getInstance().createDao(UserDaoImpl.class);
		
		try {
			conn = ConnectionFactory.getInstance().makeConnection();
			alist = userDao.get_where(conn, null);
		} catch (Exception e){
		} finally {
			try {
				conn.close();
			} catch (Exception e3){
				e3.printStackTrace();
			}
		}
		
		if ( alist !=null && alist.size() > 0  )
		{
			System.out.println( alist.get(0).getClass() );
			System.out.println( Access_token.class );
			
			if ( Access_token.class.isInstance( alist.get(0) ) )
			{
				java.util.Date date=new java.util.Date();
				
				access_token = ( Access_token ) alist.get(0);
				long diff = date.getTime() - access_token.getStart_time().getTime();
				if (  diff < 60*1000*90 ) // 90 分钟刷新一次
					return access_token.getAccess_token();
			}
		}
    	return null;
    }
    
    private String GenAndSaveToken(){
    	String s;
    	Access_token access_token = new Access_token();
    	
    	s = getTokenStr();	  
    	
    	if  ( s == null ||  s.length() <= 0  )
    		return s;
    	
    	access_token.setAccess_token(s);
    	access_token.setStart_time(null);
    	save(access_token);

    	return s;
    }
	
    private boolean save(Access_token access_token){
		Connection conn = null;

		userDao = new tokenDaoImpl(); // = DaoFactory.getInstance().createDao(UserDaoImpl.class);
		
		try {
			conn = ConnectionFactory.getInstance().makeConnection();
			conn.setAutoCommit(false);
			userDao.save(conn, access_token);
			conn.commit();
		} catch (Exception e){
			e.printStackTrace();
			try {
				conn.rollback();
			} catch (Exception e2){
				e2.printStackTrace();
			}
		} finally {
			try {
				conn.close();
			} catch (Exception e3){
				e3.printStackTrace();
			}
		}
		return false;
	}

}
