package org.nescent.plhdb.spring;

import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.nescent.plhdb.hibernate.dao.UserAccount;
import org.nescent.plhdb.util.PasswordService;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class SavePasswordController implements Controller {
	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(SavePasswordController.class);
		}
		return log;
	}

	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) {

		String email = request.getParameter("email");
		String oldpas = request.getParameter("oldpassword");
		String newpas = request.getParameter("newpassword");
		String renewpas = request.getParameter("renewpassword");

		if (!(newpas.equals(renewpas))) {
			request.getSession().setAttribute("Message",
					"new password and re-typed password do not match.");
			return new ModelAndView("changepassword");
		}
		Session session = HibernateSessionFactory.getSession();
		try {

			Query q = session
					.createQuery("FROM org.nescent.plhdb.hibernate.dao.UserAccount");

			List result = q.list();
			int accountId = ((Integer) request.getSession().getAttribute(
					"personOID")).intValue();
			for (Iterator it = result.iterator(); it.hasNext();) {
				UserAccount uaccount = (UserAccount) it.next();
				String useremail = uaccount.getEmail();

				String oldEncrytedPassword = PasswordService.getInstance()
						.encrypt(oldpas);
				String newEncrytedPassword = PasswordService.getInstance()
						.encrypt(newpas);

				if (uaccount.getUserAccountOid() == accountId) {
					if (!(useremail.equals(email))
							|| !uaccount.getPassword().equals(
									oldEncrytedPassword)) {
						request
								.getSession()
								.setAttribute(
										"Message",
										"failed to find the account based on the email and the old password you entered.");
						return new ModelAndView("changepassword");
					}

					uaccount.setPassword(newEncrytedPassword);

					session.save(uaccount);
					session.flush();

					request.getSession().setAttribute("Message",
							"Your password has been successfully changed.");
					return new ModelAndView("changepassword");
				}
			}

			request
					.getSession()
					.setAttribute(
							"Message",
							"failed to find the account based on the email and the old password you entered.");
			return new ModelAndView("changepassword");

		} catch (HibernateException he) {
			throw he;
		} 

	}
}
