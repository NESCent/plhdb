package org.nescent.plhdb.spring;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.nescent.plhdb.hibernate.dao.UserAccount;
import org.nescent.plhdb.util.AccessRecord;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class SaveUserController implements Controller {
    private static Logger log;

    private static Logger log() {
	if (log == null) {
	    log = Logger.getLogger(SaveUserController.class);
	}
	return log;
    }

    public boolean isValid(String str) {
	return (str != null && !str.trim().equals(""));
    }

    @SuppressWarnings("unchecked")
    public ModelAndView handleRequest(HttpServletRequest request,
	    HttpServletResponse response) {
	Session session = HibernateSessionFactory.getSession();
	Transaction tx = session.beginTransaction();

	String id = request.getParameter("user");
	String firstName = request.getParameter("firstName");
	String lastName = request.getParameter("lastName");
	String email = request.getParameter("email");
	String isAdmin = request.getParameter("isAdmin");
	if (!isValid(id)) {
	    throw new IllegalArgumentException("No user id specified.");
	}
	try {
	    UserAccount ua = null;
	    if (id.equals("-1")) {
		ua = new UserAccount();
		ua.setAdmin(isAdmin.equals("yes"));
		ua.setEmail(email);
		ua.setFirstName(firstName);
		ua.setLastName(lastName);
		ua.setCreateDate(Calendar.getInstance().getTime());
		ua.setEnableDisableStatus("Y");
		ua.setPassword("password");
		session.save(ua);

	    } else {
		ua = (UserAccount) session.get(
			"org.nescent.plhdb.hibernate.dao.UserAccount", Integer
				.parseInt(id));

		if (ua == null) {
		    throw new IllegalArgumentException(
			    "failed to retrieve the user account with id: "
				    + id);
		}
		ua.setAdmin(isAdmin.equals("yes"));
		ua.setEmail(email);
		ua.setFirstName(firstName);
		ua.setLastName(lastName);
		ua.setAdmin(isAdmin.equals("yes"));
		session.update(ua);
	    }
	    for (AccessRecord r : getAccessRecords(request)) {
		saveAccess(ua, r, session);
	    }
	    session.flush();
	    tx.commit();
	    String sql = "FROM Studyinfo ORDER BY studyId";
	    Query q = session.createQuery(sql);
	    List studies = q.list();
	    Map<String, Object> models = new HashMap<String, Object>();
	    models.put("studies", studies);
	    tx.commit();
	    models.put("user", ua);
	    return new ModelAndView("edituser", models);
	} catch (HibernateException he) {
	    log().error("failed to retrive the user.", he);
	    throw he;
	} finally {
	    if (!tx.wasCommitted())
		tx.rollback();
	}
    }

    @SuppressWarnings("unchecked")
    public void saveAccess(UserAccount acct, AccessRecord r, Session session)
	    throws HibernateException {
	String permid = r.getId();
	String access = r.getAccess();
	String study = r.getStudy();

	org.nescent.plhdb.hibernate.dao.Permission perm = null;

	if (permid.equals("-1")) { // new record

	    if (isValid(access) && isValid(study)) {
		perm = new org.nescent.plhdb.hibernate.dao.Permission();
		perm.setAccess(access);
		perm.setStudy(study);
		perm.setUserAccount(acct);
		acct.getPermissions().add(perm);
		session.save(perm);
	    }
	} else { // existing fertility

	    perm = (org.nescent.plhdb.hibernate.dao.Permission) session.get(
		    "org.nescent.plhdb.hibernate.dao.Permission", Integer
			    .parseInt(permid));
	    if (perm == null) {
		throw new IllegalArgumentException(
			"failed to retrieve the permission with id: " + permid);
	    }
	    if (isValid(access) && isValid(study)) {
		perm.setStudy(study);
		perm.setAccess(access);
		perm.setUserAccount(acct);
		session.update(perm);
	    } else {
		acct.getPermissions().remove(perm);
		session.delete(perm);
	    }
	}
    }

    @SuppressWarnings("unchecked")
    public List<AccessRecord> getAccessRecords(HttpServletRequest request) {
	List<AccessRecord> list = new ArrayList<AccessRecord>();
	for (Enumeration en = request.getParameterNames(); en.hasMoreElements();) {
	    String name = (String) en.nextElement();

	    if (name.startsWith("newid")) {
		AccessRecord r = new AccessRecord();
		r.setId("-1");
		String id = request.getParameter(name);
		r
			.setAccess(nullIfEmpty(request.getParameter("newaccess"
				+ id)));
		r.setStudy(nullIfEmpty(request.getParameter("newstudy" + id)));
		list.add(r);
	    } else if (name.startsWith("id")) {
		AccessRecord r = new AccessRecord();
		String id = nullIfEmpty(request.getParameter(name));
		r.setId(id);
		r.setAccess(nullIfEmpty(request.getParameter("access" + id)));
		r.setStudy(nullIfEmpty(request.getParameter("study" + id)));
		list.add(r);
	    }
	}

	return list;
    }

    private String nullIfEmpty(String s) {
	return (s != null && s.trim().equals("")) ? null : s;
    }

}
