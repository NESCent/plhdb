package org.nescent.plhdb.util;

public class SearchFertilityForm {
	String show_studyid;
	String show_animid;
	String show_startdate;
	String show_starttype;
	String show_stopdate;
	String show_stoptype;
	String op_studyid;
	String op_animid;
	String op_startdate;
	String op_starttype;
	String op_stopdate;
	String op_stoptype;
	String value_studyid;
	String value_animid;
	String value_startdate;
	String value_starttype;
	String value_stopdate;
	String value_stoptype;

	String sortBy;
	String page;
	String order;
	String numPerPage;
	String searchDistribution;
	String download;

	public String getDownload() {
		return download;
	}

	public void setDownload(String download) {
		this.download = nullIfEmpty(download);
	}

	public String getSearchDistribution() {
		return searchDistribution;
	}

	public void setSearchDistribution(String searchDistribution) {
		this.searchDistribution = nullIfEmpty(searchDistribution);
	}

	public String getNumPerPage() {
		return numPerPage;
	}

	public void setNumPerPage(String numPerPage) {
		this.numPerPage = nullIfEmpty(numPerPage);
	}

	public String getOrder() {
		return order;
	}

	public void setOrder(String order) {
		this.order = nullIfEmpty(order);
	}

	public String getSortBy() {
		return sortBy;
	}

	public void setSortBy(String sortBy) {
		this.sortBy = nullIfEmpty(sortBy);
	}

	public String getPage() {
		return page;
	}

	public void setPage(String page) {
		this.page = nullIfEmpty(page);
	}

	public void setShow_studyid(String show_studyid) {
		this.show_studyid = nullIfEmpty(show_studyid);
	}

	public void setShow_animid(String show_animid) {
		this.show_animid = nullIfEmpty(show_animid);
	}

	public void setShow_startdate(String show_startdate) {
		this.show_startdate = nullIfEmpty(show_startdate);
	}

	public void setShow_starttype(String show_starttype) {
		this.show_starttype = nullIfEmpty(show_starttype);
	}

	public void setShow_stopdate(String show_stopdate) {
		this.show_stopdate = nullIfEmpty(show_stopdate);
	}

	public void setShow_stoptype(String show_stoptype) {
		this.show_stoptype = nullIfEmpty(show_stoptype);
	}

	public String getShow_studyid() {
		return this.show_studyid;
	}

	public String getShow_animid() {
		return this.show_animid;
	}

	public String getShow_startdate() {
		return this.show_startdate;
	}

	public String getShow_starttype() {
		return this.show_starttype;
	}

	public String getShow_stopdate() {
		return this.show_stopdate;
	}

	public String getShow_stoptype() {
		return this.show_stoptype;
	}

	public void setOp_studyid(String op_studyid) {
		this.op_studyid = nullIfEmpty(op_studyid);
	}

	public void setOp_animid(String op_animid) {
		this.op_animid = nullIfEmpty(op_animid);
	}

	public void setOp_startdate(String op_startdate) {
		this.op_startdate = nullIfEmpty(op_startdate);
	}

	public void setOp_starttype(String op_starttype) {
		this.op_starttype = nullIfEmpty(op_starttype);
	}

	public void setOp_stopdate(String op_stopdate) {
		this.op_stopdate = nullIfEmpty(op_stopdate);
	}

	public void setOp_stoptype(String op_stoptype) {
		this.op_stoptype = nullIfEmpty(op_stoptype);
	}

	public String getOp_studyid() {
		return this.op_studyid;
	}

	public String getOp_animid() {
		return this.op_animid;
	}

	public String getOp_startdate() {
		return this.op_startdate;
	}

	public String getOp_starttype() {
		return this.op_starttype;
	}

	public String getOp_stopdate() {
		return this.op_stopdate;
	}

	public String getOp_stoptype() {
		return this.op_stoptype;
	}

	public void setValue_studyid(String value_studyid) {
		this.value_studyid = nullIfEmpty(value_studyid);
	}

	public void setValue_animid(String value_animid) {
		this.value_animid = nullIfEmpty(value_animid);
	}

	public void setValue_startdate(String value_startdate) {
		this.value_startdate = nullIfEmpty(value_startdate);
	}

	public void setValue_starttype(String value_starttype) {
		this.value_starttype = nullIfEmpty(value_starttype);
	}

	public void setValue_stopdate(String value_stopdate) {
		this.value_stopdate = nullIfEmpty(value_stopdate);
	}

	public void setValue_stoptype(String value_stoptype) {
		this.value_stoptype = nullIfEmpty(value_stoptype);
	}

	public String getValue_studyid() {
		return this.value_studyid;
	}

	public String getValue_animid() {
		return this.value_animid;
	}

	public String getValue_startdate() {
		return this.value_startdate;
	}

	public String getValue_starttype() {
		return this.value_starttype;
	}

	public String getValue_stopdate() {
		return this.value_stopdate;
	}

	public String getValue_stoptype() {
		return this.value_stoptype;
	}

	private String nullIfEmpty(String s) {
		return (s != null && s.trim().equals("")) ? null : s;
	}

}
