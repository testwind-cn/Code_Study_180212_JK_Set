package com.wj.db.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.wj.db.dao.entity.User;
import com.wj.db.dao.intface.DaoIntface;

public class UserDaoImpl implements DaoIntface {

	/**
	 * 保存信息
	 */
	@Override
	public void save(Connection conn,Object obj) throws SQLException{
		// TODO Auto-generated method stub
		User user = (User ) obj;
		String SQLstr = "INSERT INTO the_user(name,passwd,email) values (?,?,?)";
		PreparedStatement ps;
		try {
			ps = conn.prepareStatement(SQLstr);
			ps.setString(1, user.getName());
			ps.setString(2, user.getPassword());
			ps.setString(3, user.getEmail());
			ps.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}

	/**
	 * 更新信息
	 */
	@Override
	public void update(Connection conn,Object obj) throws SQLException {
		// TODO Auto-generated method stub
		User user = (User ) obj;
		String SQLstr = "UPDATE the_user SET name=?,passwd=?,email=? WHERE id=?";
		PreparedStatement ps;
		try {
			ps = conn.prepareStatement(SQLstr);
			ps.setString(1, user.getName());
			ps.setString(2, user.getPassword());
			ps.setString(3, user.getEmail());
			ps.setLong(4, user.getId());
			ps.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * 删除信息
	 */
	@Override
	public void delete(Connection conn,Object obj) throws SQLException {
		// TODO Auto-generated method stub
		User user = (User ) obj;
		String SQLstr = "DELETE FROM the_user WHERE id=?";
		PreparedStatement ps;
		try {
			ps = conn.prepareStatement(SQLstr);
			ps.setLong(1, user.getId());
			ps.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	/**
	 * 获取记录
	 */
	@Override
	public ResultSet get(Connection conn,Object obj) throws SQLException {
		// TODO Auto-generated method stub
		User user = (User ) obj;
		String SQLstr = "SELECT * FROM the_user WHERE name=? AND passwd=?";
		PreparedStatement ps;
		try {
			ps = conn.prepareStatement(SQLstr);
			ps.setString(1, user.getName());
			ps.setString(2, user.getPassword());
			return ps.executeQuery();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 查询记录
	 */
	@Override
	public ArrayList get_where(Connection conn, String where) throws SQLException {
		// TODO Auto-generated method stub
		ArrayList list = new ArrayList();
		
		String SQLstr = "SELECT * FROM the_user WHERE " + where;
		PreparedStatement ps;
		ResultSet rs;
		
		try {
			ps = conn.prepareStatement(SQLstr);
			rs = ps.executeQuery();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			rs = null;
		}
			
		if ( rs != null )
		{
			while (rs.next())
			{
				User a_user = new User();
				a_user.setName((String) rs.getObject("name"));
				a_user.setId( ( (Integer) rs.getObject("id")).longValue() );
				a_user.setEmail((String) rs.getObject("email"));
				a_user.setPassword((String) rs.getObject("passwd"));
				list.add(a_user);
			}
		}
		
		return list;
	}

}
