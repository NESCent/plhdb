package org.nescent.plhdb.spring;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class ViewUsersController implements Controller {
    private static Logger log;

    private static Logger log() {
	if (log == null) {
	    log = Logger.getLogger(ViewUsersController.class);
	}
	return log;
    }

    public ModelAndView handleRequest(HttpServletRequest arg0,
	    HttpServletResponse arg1){
	Session session = HibernateSessionFactory.getSession();
	Transaction tx = session.beginTransaction();
	try {
	    String sql = "FROM UserAccount order by lastName";
	    Query q = session.createQuery(sql);
	    List users = q.list();
	    tx.commit();

	    return new ModelAndView("users", "users", users);
	} catch (HibernateException he) {
	    log().error("failed to retrieve users from the database", he);
	    throw he;
	} finally {
	    if (!tx.wasCommitted())
		tx.rollback();
	}
    }

}
