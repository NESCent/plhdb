/**
 * Permission class to hold permission parameters and validate against 
 * another Permission object 
 */
package org.nescent.plhdb.aa;

import java.io.Serializable;

/**
 * @author xianhua
 * @author Surya Dhullipalla
 */

public class Permission implements Serializable {
	public static String ACCESS_TYPE_SEARCH = "search";
	public static String ACCESS_TYPE_READ = "view";
	public static String ACCESS_TYPE_INSERT = "insert";
	public static String ACCESS_TYPE_UPDATE = "edit";
	public static String ACCESS_TYPE_DELETE = "delete";
	public static String ACCESS_TYPE_ALL = "all";

	public static int INT_ACCESS_TYPE_SEARCH = 0;
	public static int INT_ACCESS_TYPE_READ = 1;
	public static int INT_ACCESS_TYPE_INSERT = 2;
	public static int INT_ACCESS_TYPE_UPDATE = 3;
	public static int INT_ACCESS_TYPE_DELETE = 4;
	public static int INT_ACCESS_TYPE_ALL = 5;

	public static String OBJECT_ALL = "all";

	String access;
	String study;

	PermissionManager manager;

	public PermissionManager getManager() {
		return manager;
	}

	public void setManager(PermissionManager manager) {
		this.manager = manager;
	}

	public String getAccess() {
		return access;
	}

	public void setAccess(String access) {
		this.access = access;
	}

	public String getStudy() {
		return study;
	}

	public void setStudy(String study) {
		this.study = study;
	}

	public boolean permit(Permission permission) {
		if (study.equals(Permission.OBJECT_ALL)) {
			if (access.equals(Permission.ACCESS_TYPE_ALL)) {
				return true;
			} else if (access.equals(permission.getAccess())) {
				return true;
			} else {
				return false;
			}
		} else if (study.equals(permission.getStudy())) {
			if (access.equals(Permission.ACCESS_TYPE_ALL)) {
				return true;
			} else if (access.equals(permission.getAccess())) {
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}

	}

	static public int getAccessType(String access) {
		if (access.equals("search"))
			return Permission.INT_ACCESS_TYPE_SEARCH;
		if (access.equals("view"))
			return Permission.INT_ACCESS_TYPE_READ;
		if (access.equals("insert"))
			return Permission.INT_ACCESS_TYPE_INSERT;
		if (access.equals("edit"))
			return Permission.INT_ACCESS_TYPE_UPDATE;
		if (access.equals("delete"))
			return Permission.INT_ACCESS_TYPE_DELETE;
		if (access.equals("all"))
			return Permission.INT_ACCESS_TYPE_ALL;

		return -1;
	}

	@Override
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		if (obj instanceof Permission) {
			Permission p = (Permission) obj;
			return study.equals(p.getStudy());
		} else
			return super.equals(obj);

	}

	public int compareTo(Object o)

	{
		Permission p = (Permission) o;
		return study.compareTo(p.getStudy());

	}
}
