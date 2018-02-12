package com.wj.db_backup_old.dao.entity;

public abstract class IdEntity {
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	protected Long id;
	

}
