package org.nescent.plhdb.util;

public class Fertility {
    String id;
    String startDate;
    String stopDate;
    String startType;
    String stopType;

    public String getId() {
	return id;
    }

    public void setId(String id) {
	this.id = id;
    }

    public String getStartDate() {
	return startDate;
    }

    public void setStartDate(String startDate) {
	this.startDate = startDate;
    }

    public String getStopDate() {
	return stopDate;
    }

    public void setStopDate(String stopDate) {
	this.stopDate = stopDate;
    }

    public String getStartType() {
	return startType;
    }

    public void setStartType(String startType) {
	this.startType = startType;
    }

    public String getStopType() {
	return stopType;
    }

    public void setStopType(String stopType) {
	this.stopType = stopType;
    }
    
    public String toString(){
    	return id+","+startDate+","+startType+","+stopDate+","+stopType;
    }

}
