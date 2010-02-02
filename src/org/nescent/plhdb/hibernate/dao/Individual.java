package org.nescent.plhdb.hibernate.dao;

// Generated Dec 12, 2007 11:49:54 AM by Hibernate Tools 3.2.0.CR1

import java.util.HashSet;
import java.util.Set;

/**
 * Individual generated by hbm2java
 */
public class Individual implements java.io.Serializable {

	private int individualOid;
	private Study study;
	private String name;
	private String individualId;
	private Character sex;
	private String birthgroup;
	private Character birthgroupCertainty;
	private Character isFirstBorn;
	private Set observations = new HashSet(0);
	private Set individualRelationshipsForChildOid = new HashSet(0);
	private Set individualRelationshipsForParentOid = new HashSet(0);

	public Individual() {
	}

	public Individual(int individualOid, Study study, String id) {
		this.individualOid = individualOid;
		this.study = study;
		this.individualId = id;
	}

	public Individual(int individualOid, Study study, String name, String id,
			Character sex, String birthgroup, Character birthgroupCertainty,
			Character isFirstBorn, Set observations,
			Set individualRelationshipsForChildOid,
			Set individualRelationshipsForParentOid) {
		this.individualOid = individualOid;
		this.study = study;
		this.name = name;
		this.individualId = id;
		this.sex = sex;
		this.birthgroup = birthgroup;
		this.birthgroupCertainty = birthgroupCertainty;
		this.isFirstBorn = isFirstBorn;
		this.observations = observations;
		this.individualRelationshipsForChildOid = individualRelationshipsForChildOid;
		this.individualRelationshipsForParentOid = individualRelationshipsForParentOid;
	}

	public int getIndividualOid() {
		return this.individualOid;
	}

	public void setIndividualOid(int individualOid) {
		this.individualOid = individualOid;
	}

	public Study getStudy() {
		return this.study;
	}

	public void setStudy(Study study) {
		this.study = study;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getIndividualId() {
		return this.individualId;
	}

	public void setIndividualId(String id) {
		this.individualId = id;
	}

	public Character getSex() {
		return this.sex;
	}

	public void setSex(Character sex) {
		this.sex = sex;
	}

	public String getBirthgroup() {
		return this.birthgroup;
	}

	public void setBirthgroup(String birthgroup) {
		this.birthgroup = birthgroup;
	}

	public Character getBirthgroupCertainty() {
		return this.birthgroupCertainty;
	}

	public void setBirthgroupCertainty(Character birthgroupCertainty) {
		this.birthgroupCertainty = birthgroupCertainty;
	}

	public Character getIsFirstBorn() {
		return this.isFirstBorn;
	}

	public void setIsFirstBorn(Character isFirstBorn) {
		this.isFirstBorn = isFirstBorn;
	}

	public Set getObservations() {
		return this.observations;
	}

	public void setObservations(Set observations) {
		this.observations = observations;
	}

	public Set getIndividualRelationshipsForChildOid() {
		return this.individualRelationshipsForChildOid;
	}

	public void setIndividualRelationshipsForChildOid(
			Set individualRelationshipsForChildOid) {
		this.individualRelationshipsForChildOid = individualRelationshipsForChildOid;
	}

	public Set getIndividualRelationshipsForParentOid() {
		return this.individualRelationshipsForParentOid;
	}

	public void setIndividualRelationshipsForParentOid(
			Set individualRelationshipsForParentOid) {
		this.individualRelationshipsForParentOid = individualRelationshipsForParentOid;
	}

}
