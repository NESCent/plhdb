package org.nescent.plhdb.hibernate.dao;

// Generated Dec 12, 2007 11:49:54 AM by Hibernate Tools 3.2.0.CR1

/**
 * ObservationsId generated by hbm2java
 */
public class ObservationsId implements java.io.Serializable {

	private Integer observationOid;

	public ObservationsId() {
	}

	public ObservationsId(Integer observationOid) {
		this.observationOid = observationOid;

	}

	public Integer getObservationOid() {
		return this.observationOid;
	}

	public void setObservationOid(Integer observationOid) {
		this.observationOid = observationOid;
	}

	@Override
	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ObservationsId))
			return false;
		ObservationsId castOther = (ObservationsId) other;

		return ((this.getObservationOid() == castOther.getObservationOid()) || (this
				.getObservationOid() != null
				&& castOther.getObservationOid() != null && this
				.getObservationOid().equals(castOther.getObservationOid())));
	}

	@Override
	public int hashCode() {
		int result = 17;

		result = 37
				* result
				+ (getObservationOid() == null ? 0 : this.getObservationOid()
						.hashCode());

		return result;
	}

}
