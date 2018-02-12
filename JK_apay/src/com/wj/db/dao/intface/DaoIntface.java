package com.wj.db.dao.intface;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.wj.db.dao.entity.User;;

public interface DaoIntface {
	
	public void save(Connection conn ,Object user) throws SQLException  ;
	public void update(Connection conn ,Object user) throws SQLException  ;
	public void delete(Connection conn ,Object user) throws SQLException  ;
	public ResultSet get(Connection conn ,Object user) throws SQLException  ;
	public ArrayList get_where(Connection conn ,String where) throws SQLException  ;

}
