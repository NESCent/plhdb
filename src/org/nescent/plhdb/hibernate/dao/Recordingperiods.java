package org.nescent.plhdb.hibernate.dao;

import java.util.Date;

// Generated Dec 12, 2007 11:49:54 AM by Hibernate Tools 3.2.0.CR1

/**
 * Recordingperiods generated by hbm2java
 */
public class Recordingperiods implements java.io.Serializable {

	private RecordingperiodsId id;
	private Date startTime;
	private Double startTimeError;
	private String startEventType;
	private String startEventCode;
	private String startEventTypeNamespace;
	private Integer endObservationOid;
	private Date endTime;
	private Double endTimeError;
	private String endEventType;
	private String endEventCode;
	private String endEventTypeNamespace;
	private String periodType;

	public Recordingperiods() {
	}

	public Recordingperiods(RecordingperiodsId id) {
		this.id = id;
	}

	public RecordingperiodsId getId() {
		return this.id;
	}

	public void setId(RecordingperiodsId id) {
		this.id = id;
	}

	public Date getStartTime() {
		return this.startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public Double getStartTimeError() {
		return this.startTimeError;
	}

	public void setStartTimeError(Double startTimeError) {
		this.startTimeError = startTimeError;
	}

	public String getStartEventType() {
		return this.startEventType;
	}

	public void setStartEventType(String startEventType) {
		this.startEventType = startEventType;
	}

	public String getStartEventCode() {
		return this.startEventCode;
	}

	public void setStartEventCode(String startEventCode) {
		this.startEventCode = startEventCode;
	}

	public String getStartEventTypeNamespace() {
		return this.startEventTypeNamespace;
	}

	public void setStartEventTypeNamespace(String startEventTypeNamespace) {
		this.startEventTypeNamespace = startEventTypeNamespace;
	}

	public Integer getEndObservationOid() {
		return this.endObservationOid;
	}

	public void setEndObservationOid(Integer endObservationOid) {
		this.endObservationOid = endObservationOid;
	}

	public Date getEndTime() {
		return this.endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public Double getEndTimeError() {
		return this.endTimeError;
	}

	public void setEndTimeError(Double endTimeError) {
		this.endTimeError = endTimeError;
	}

	public String getEndEventType() {
		return this.endEventType;
	}

	public void setEndEventType(String endEventType) {
		this.endEventType = endEventType;
	}

	public String getEndEventCode() {
		return this.endEventCode;
	}

	public void setEndEventCode(String endEventCode) {
		this.endEventCode = endEventCode;
	}

	public String getEndEventTypeNamespace() {
		return this.endEventTypeNamespace;
	}

	public void setEndEventTypeNamespace(String endEventTypeNamespace) {
		this.endEventTypeNamespace = endEventTypeNamespace;
	}

	public String getPeriodType() {
		return this.periodType;
	}

	public void setPeriodType(String periodType) {
		this.periodType = periodType;
	}
}
