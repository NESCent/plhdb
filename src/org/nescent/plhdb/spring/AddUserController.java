package org.nescent.plhdb.spring;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Query;
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

		try {
			String sql = "FROM Studyinfo ORDER BY studyId";
			Query q = HibernateSessionFactory.getSession().createQuery(sql);
			List studies = q.list();
			return new ModelAndView("adduser", "studies", studies);
		} catch (HibernateException he) {
			log().error("failed to retrive the user.", he);
			throw he;
		} 
	}

}
