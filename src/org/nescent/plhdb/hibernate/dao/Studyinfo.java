package org.nescent.plhdb.hibernate.dao;

import java.math.BigDecimal;

// Generated Dec 12, 2007 11:49:54 AM by Hibernate Tools 3.2.0.CR1

/**
 * Studyinfo generated by hbm2java
 */
@SuppressWarnings("unchecked")
public class Studyinfo implements java.io.Serializable {

	private String studyId;
	private String commonname;
	private String sciname;
	private String siteid;
	private String owners;
	private BigDecimal latitude;
	private BigDecimal longitude;

	public Studyinfo() {
	}

	public Studyinfo(String id) {
		this.studyId = id;
	}

	public void setStudyId(String studyId) {
		this.studyId = studyId;
	}

	public String getStudyId() {
		return studyId;
	}

	public String getCommonname() {
		return this.commonname;
	}

	public void setCommonname(String commonname) {
		this.commonname = commonname;
	}

	public String getSciname() {
		return this.sciname;
	}

	public void setSciname(String sciname) {
		this.sciname = sciname;
	}

	public String getSiteid() {
		return this.siteid;
	}

	public void setSiteid(String siteid) {
		this.siteid = siteid;
	}

	public String getOwners() {
		return this.owners;
	}

	public void setOwners(String owners) {
		this.owners = owners;
	}

	public BigDecimal getLatitude() {
		return this.latitude;
	}

	public void setLatitude(BigDecimal latitude) {
		this.latitude = latitude;
	}

	public BigDecimal getLongitude() {
		return this.longitude;
	}

	public void setLongitude(BigDecimal longitude) {
		this.longitude = longitude;
	}

}
