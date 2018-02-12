package com.wj.db.dao.service;

import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.wj.db.dao.entity.User;
import com.wj.db.dao.impl.UserDaoImpl;
import com.wj.db.dao.intface.DaoIntface;
import com.wj.db.dao.util.ConnectionFactory;

public class UserService {

	private DaoIntface userDao;
	
	
	public boolean check(User user){
		Connection conn = null;
		
		userDao = new UserDaoImpl(); // = DaoFactory.getInstance().createDao(UserDaoImpl.class); //传入dao接口的完整类名，由dao工厂根据接口名创建出dao的实现类daoimpl  
	    
		try {
			conn = ConnectionFactory.getInstance().makeConnection();
			conn.setAutoCommit(false);
			ResultSet resultSet = userDao.get(conn, user);
			while (resultSet.next()){
				return true;
			}
			
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
	
	
	public boolean save(User user){
		Connection conn = null;
		
		userDao = new UserDaoImpl(); // = DaoFactory.getInstance().createDao(UserDaoImpl.class);
		
		try {
			conn = ConnectionFactory.getInstance().makeConnection();
			conn.setAutoCommit(false);

						
			userDao.save(conn, user);
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
	
	public ArrayList enumdata(String where) {
		where = "1";
		
		Connection conn = null;
		userDao = new UserDaoImpl();
		
		try {
			conn = ConnectionFactory.getInstance().makeConnection();
			return userDao.get_where(conn, where);
		} catch (Exception e){
			e.printStackTrace();

			
		} finally {

		}
		

		return null;
	}
}
