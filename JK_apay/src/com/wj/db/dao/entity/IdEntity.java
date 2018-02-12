package com.wj.db.dao.entity;

public abstract class IdEntity {
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	protected Long id;
	

}
