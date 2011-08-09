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

public class ViewUsersController implements Controller {
	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(ViewUsersController.class);
		}
		return log;
	}

	public ModelAndView handleRequest(HttpServletRequest arg0,
			HttpServletResponse arg1) {
		try {
			String sql = "FROM UserAccount order by lastName";
			Query q = HibernateSessionFactory.getSession().createQuery(sql);
			List users = q.list();
			return new ModelAndView("users", "users", users);
		} catch (HibernateException he) {
			log().error("failed to retrieve users from the database", he);
			throw he;
		} 
	}

}
