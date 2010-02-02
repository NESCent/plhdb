/**
 * PermissionManager: class to hold all permissions of an user and perform 
 * permission check
 */
package org.nescent.plhdb.aa;

import java.util.ArrayList;
import java.util.List;

/**
 * @author xianhua
 * 
 */
public class PermissionManager {
	List<Permission> permissions;
	boolean admin = false;

	public PermissionManager() {
		permissions = new ArrayList<Permission>();
	}

	public boolean isAdmin() {
		return admin;
	}

	public void setAdmin(boolean admin) {
		this.admin = admin;
	}

	@SuppressWarnings("unchecked")
	public void addPermission(Permission permission) {
		if (permissions != null) {
			permissions.add(permission);
			permission.setManager(this);
		}
	}

	public boolean permit(Permission permission) {
		if (permissions == null)
			return false;
		for (Permission perm : permissions) {
			boolean permitted = perm.permit(permission);
			if (permitted)
				return true;
		}
		return false;
	}

	public List<String> getPermittedStudies(String access) {
		List<String> studies = new ArrayList<String>();

		for (Permission p : permissions) {
			if (p.getAccess().equals(Permission.ACCESS_TYPE_ALL)
					|| (p.getAccess().toUpperCase()
							.equals(access.toUpperCase()))) {
				studies.add(p.getStudy());
			}
		}
		return studies;
	}
}
