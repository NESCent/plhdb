package org.nescent.plhdb.spring;

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
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class EditUserController implements Controller {
    private static Logger log;

    private static Logger log() {
	if (log == null) {
	    log = Logger.getLogger(EditUserController.class);
	}
	return log;
    }

    public ModelAndView handleRequest(HttpServletRequest request,
	    HttpServletResponse response){
	String id = nullIfEmpty(request.getParameter("id"));

	if (id == null || id.trim().equals("")) {
	    throw new IllegalArgumentException("No user id specified.");
	}

	Session session = HibernateSessionFactory.getSession();
	Transaction tx = session.beginTransaction();

	try {
	    String sql = "FROM Studyinfo ORDER BY studyId";
	    Query q = session.createQuery(sql);
	    List studies = q.list();
	    Map<String, Object> models = new HashMap<String, Object>();
	    models.put("studies", studies);
	    UserAccount ua = (UserAccount) session.get(
		    "org.nescent.plhdb.hibernate.dao.UserAccount", Integer
			    .parseInt(id));

	    if (ua == null) {
		throw new IllegalArgumentException(
			"failed to retrieve the user account with id: " + id);
	    }
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

    private String nullIfEmpty(String s) {
	return (s != null && s.trim().equals("")) ? null : s;
    }

}
