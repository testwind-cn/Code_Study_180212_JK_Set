package com.wj.db_backup_old.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.wj.db_backup_old.dao.entity.User;
import com.wj.db_backup_old.dao.inface.UserDaoInface;

public class UserDaoImpl implements UserDaoInface {

	/**
	 * 保存信息
	 */
	@Override
	public void save(Connection conn,User user) throws SQLException{
		// TODO Auto-generated method stub
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
	public void update(Connection conn,User user) throws SQLException {
		// TODO Auto-generated method stub
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
	public void delete(Connection conn,User user) throws SQLException {
		// TODO Auto-generated method stub
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
	public ResultSet get(Connection conn,User user) throws SQLException {
		// TODO Auto-generated method stub
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

}
