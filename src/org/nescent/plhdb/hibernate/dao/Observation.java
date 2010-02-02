package org.nescent.plhdb.hibernate.dao;

// Generated Dec 12, 2007 11:49:54 AM by Hibernate Tools 3.2.0.CR1

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * Observation generated by hbm2java
 */
public class Observation implements java.io.Serializable {

	private int observationOid;
	private Individual individual;
	private Cvterm cvterm;
	private Cvterm distribution;
	private Date minBoundary;
	private Date maxBoundary;
	private Date timeOfObservation;
	private Double timeError;
	private Set recordingperiodsForStartOid = new HashSet(0);
	private Set recordingperiodsForEndOid = new HashSet(0);

	public Observation() {
	}

	public Observation(int observationOid, Individual individual,
			Cvterm cvterm, Date timeOfObservation) {
		this.observationOid = observationOid;
		this.individual = individual;
		this.cvterm = cvterm;
		this.timeOfObservation = timeOfObservation;
	}

	public Observation(int observationOid, Individual individual,
			Cvterm cvterm, Date timeOfObservation, Double timeError,
			Set recordingperiodsForStartOid, Set recordingperiodsForEndOid) {
		this.observationOid = observationOid;
		this.individual = individual;
		this.cvterm = cvterm;
		this.timeOfObservation = timeOfObservation;
		this.timeError = timeError;
		this.recordingperiodsForStartOid = recordingperiodsForStartOid;
		this.recordingperiodsForEndOid = recordingperiodsForEndOid;
	}

	public int getObservationOid() {
		return this.observationOid;
	}

	public void setObservationOid(int observationOid) {
		this.observationOid = observationOid;
	}

	public Cvterm getDistribution() {
		return distribution;
	}

	public void setDistribution(Cvterm distribution) {
		this.distribution = distribution;
	}

	public Date getMinBoundary() {
		return minBoundary;
	}

	public void setMinBoundary(Date minBoundary) {
		this.minBoundary = minBoundary;
	}

	public Date getMaxBoundary() {
		return maxBoundary;
	}

	public void setMaxBoundary(Date maxBoundary) {
		this.maxBoundary = maxBoundary;
	}

	public Individual getIndividual() {
		return this.individual;
	}

	public void setIndividual(Individual individual) {
		this.individual = individual;
	}

	public Cvterm getCvterm() {
		return this.cvterm;
	}

	public void setCvterm(Cvterm cvterm) {
		this.cvterm = cvterm;
	}

	public Date getTimeOfObservation() {
		return this.timeOfObservation;
	}

	public void setTimeOfObservation(Date timeOfObservation) {
		this.timeOfObservation = timeOfObservation;
	}

	public Double getTimeError() {
		return this.timeError;
	}

	public void setTimeError(Double timeError) {
		this.timeError = timeError;
	}

	public Set getRecordingperiodsForStartOid() {
		return this.recordingperiodsForStartOid;
	}

	public void setRecordingperiodsForStartOid(Set recordingperiodsForStartOid) {
		this.recordingperiodsForStartOid = recordingperiodsForStartOid;
	}

	public Set getRecordingperiodsForEndOid() {
		return this.recordingperiodsForEndOid;
	}

	public void setRecordingperiodsForEndOid(Set recordingperiodsForEndOid) {
		this.recordingperiodsForEndOid = recordingperiodsForEndOid;
	}

}
