package com.wj.db.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;

import com.wj.db.dao.entity.Access_token;
import com.wj.db.dao.entity.User;
import com.wj.db.dao.intface.DaoIntface;

public class tokenDaoImpl implements DaoIntface {

	/**
	 * 保存信息
	 */
	@Override
	public void save(Connection conn,Object obj) throws SQLException{
		// TODO Auto-generated method stub
		Access_token access_token = (Access_token ) obj;
		String SQLstr = "INSERT INTO access_token(access_token,start_time) values (?,?)";
		PreparedStatement ps;
		try {
			
			ps = conn.prepareStatement(SQLstr);
			ps.setString(1, access_token.getAccess_token());
			ps.setTimestamp(2, access_token.getStart_time());

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
		String SQLstr = "SELECT * FROM access_token WHERE name=? AND passwd=?";
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
		ArrayList<Access_token> list = new ArrayList<Access_token>();
		
		String SQLstr = "SELECT access_token,start_time FROM access_token order by start_time desc ";
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
				Access_token a_token = new Access_token();
				a_token.setAccess_token( (String) rs.getObject("access_token") );
				a_token.setStart_time( rs.getTimestamp("start_time") );
				list.add( a_token);
				// 取第一个就立刻return ，否则不return
				return list;
			}
		}
		
		return  list;
	}

}
