package com.wj.db.dao.entity;

import java.sql.Timestamp;

public class Access_token extends IdEntity {

	private String access_token;
	private Timestamp start_time;
	private String email;

	public String getAccess_token() {
		return access_token;
	}

	public void setAccess_token(String access_token) {
		this.access_token = access_token;
	}

	public Timestamp getStart_time() {
		return start_time;
	}

	public void setStart_time(Timestamp start_time) {
		if ( start_time == null)
		{
			java.util.Date date=new java.util.Date();
			start_time = new Timestamp(date.getTime());
		};
		this.start_time = start_time;
	}

	@Override
	public String toString() {
		return "access_token [access_token=" + access_token + ", start_time=" + start_time + ", id=" + id + "]";
	}

}
