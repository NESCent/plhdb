package org.nescent.plhdb.hibernate.dao;

// Generated Dec 12, 2007 11:49:54 AM by Hibernate Tools 3.2.0.CR1

/**
 * IndividualRelationshipsId generated by hbm2java
 */
public class IndividualRelationshipsId implements java.io.Serializable {

	private Integer parentOid;
	private String parentName;
	private String parentId;
	private Integer childOid;
	private String childName;
	private String childId;
	private String reltype;

	public IndividualRelationshipsId() {
	}

	public IndividualRelationshipsId(Integer parentOid, String parentName,
			String parentId, Integer childOid, String childName,
			String childId, String reltype) {
		this.parentOid = parentOid;
		this.parentName = parentName;
		this.parentId = parentId;
		this.childOid = childOid;
		this.childName = childName;
		this.childId = childId;
		this.reltype = reltype;
	}

	public Integer getParentOid() {
		return this.parentOid;
	}

	public void setParentOid(Integer parentOid) {
		this.parentOid = parentOid;
	}

	public String getParentName() {
		return this.parentName;
	}

	public void setParentName(String parentName) {
		this.parentName = parentName;
	}

	public String getParentId() {
		return this.parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public Integer getChildOid() {
		return this.childOid;
	}

	public void setChildOid(Integer childOid) {
		this.childOid = childOid;
	}

	public String getChildName() {
		return this.childName;
	}

	public void setChildName(String childName) {
		this.childName = childName;
	}

	public String getChildId() {
		return this.childId;
	}

	public void setChildId(String childId) {
		this.childId = childId;
	}

	public String getReltype() {
		return this.reltype;
	}

	public void setReltype(String reltype) {
		this.reltype = reltype;
	}

	@Override
	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof IndividualRelationshipsId))
			return false;
		IndividualRelationshipsId castOther = (IndividualRelationshipsId) other;

		return ((this.getParentOid() == castOther.getParentOid()) || (this
				.getParentOid() != null
				&& castOther.getParentOid() != null && this.getParentOid()
				.equals(castOther.getParentOid())))
				&& ((this.getParentName() == castOther.getParentName()) || (this
						.getParentName() != null
						&& castOther.getParentName() != null && this
						.getParentName().equals(castOther.getParentName())))
				&& ((this.getParentId() == castOther.getParentId()) || (this
						.getParentId() != null
						&& castOther.getParentId() != null && this
						.getParentId().equals(castOther.getParentId())))
				&& ((this.getChildOid() == castOther.getChildOid()) || (this
						.getChildOid() != null
						&& castOther.getChildOid() != null && this
						.getChildOid().equals(castOther.getChildOid())))
				&& ((this.getChildName() == castOther.getChildName()) || (this
						.getChildName() != null
						&& castOther.getChildName() != null && this
						.getChildName().equals(castOther.getChildName())))
				&& ((this.getChildId() == castOther.getChildId()) || (this
						.getChildId() != null
						&& castOther.getChildId() != null && this.getChildId()
						.equals(castOther.getChildId())))
				&& ((this.getReltype() == castOther.getReltype()) || (this
						.getReltype() != null
						&& castOther.getReltype() != null && this.getReltype()
						.equals(castOther.getReltype())));
	}

	@Override
	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getParentOid() == null ? 0 : this.getParentOid().hashCode());
		result = 37
				* result
				+ (getParentName() == null ? 0 : this.getParentName()
						.hashCode());
		result = 37 * result
				+ (getParentId() == null ? 0 : this.getParentId().hashCode());
		result = 37 * result
				+ (getChildOid() == null ? 0 : this.getChildOid().hashCode());
		result = 37 * result
				+ (getChildName() == null ? 0 : this.getChildName().hashCode());
		result = 37 * result
				+ (getChildId() == null ? 0 : this.getChildId().hashCode());
		result = 37 * result
				+ (getReltype() == null ? 0 : this.getReltype().hashCode());
		return result;
	}

}
