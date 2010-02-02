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

public class AddUserController implements Controller {
	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(AddUserController.class);
		}
		return log;
	}

	@SuppressWarnings("unchecked")
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) {

		Session session = HibernateSessionFactory.getSession();
		Transaction tx = session.beginTransaction();

		try {
			String sql = "FROM Studyinfo ORDER BY studyId";
			Query q = session.createQuery(sql);
			List studies = q.list();
			tx.commit();
			return new ModelAndView("adduser", "studies", studies);
		} catch (HibernateException he) {
			log().error("failed to retrive the user.", he);
			throw he;
		} finally {
			if (!tx.wasCommitted())
				tx.rollback();
		}
	}

}
