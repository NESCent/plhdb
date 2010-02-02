package org.nescent.plhdb.spring;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.nescent.plhdb.aa.PermissionManager;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.nescent.plhdb.hibernate.dao.Cvterm;
import org.nescent.plhdb.hibernate.dao.UserAccount;
import org.nescent.plhdb.util.PasswordService;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class LoginController implements Controller {
	private static Logger log;

	@SuppressWarnings("unused")
	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(LoginController.class);
		}
		return log;
	}

	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) {

		String password = request.getParameter("password");
		String email = request.getParameter("email");

		Session session = HibernateSessionFactory.getSession();

		// Transaction tx = session.beginTransaction();

		try {
			PermissionManager pm = new PermissionManager();

			String pword = PasswordService.getInstance().encrypt(password);
			UserAccount ua = (UserAccount) session.createCriteria(
					UserAccount.class).add(Restrictions.eq("email", email))
					.add(Restrictions.eq("password", pword)).uniqueResult();

			if (ua == null) {
				log().error("failed to find the account for user: " + email);
				throw new IllegalArgumentException(
						"The account is not found or the password is invalid.");
			}

			Set assocs = ua.getPermissions();
			if (assocs == null) {
				log().error(
						"failed to find the roles for the logged in user: "
								+ email);
				throw new IllegalArgumentException(
						"failed to find the roles for the logged in user: "
								+ email);
			} else {
				for (Iterator it = assocs.iterator(); it.hasNext();) {
					org.nescent.plhdb.hibernate.dao.Permission perm = (org.nescent.plhdb.hibernate.dao.Permission) it
							.next();
					org.nescent.plhdb.aa.Permission p = new org.nescent.plhdb.aa.Permission();

					p.setAccess(perm.getAccess());
					p.setStudy(perm.getStudy());
					pm.addPermission(p);
				}
			}
			pm.setAdmin(ua.isAdmin());
			request.getSession().setAttribute("permission_manager", pm);
			request.getSession().setAttribute("personOID",
					new Integer(ua.getUserAccountOid()));
			request.getSession().setAttribute("username", email);
			request.getSession().setAttribute("isadmin",
					Boolean.valueOf(ua.isAdmin()));

			List<Cvterm> starts = new ArrayList<Cvterm>();
			// prepare commonly used data in the editing interface, such as
			// cvterms,
			// owners and individuals.
			String sql = "FROM Cvterm term JOIN term.cvtermRelationshipsForSubjectOid.cvtermByObjectOid o WHERE o.name='start of recording' ORDER BY term.namespace, term.name";
			Query q = session.createQuery(sql);
			List result = q.list();
			for (int i = 0; i < result.size(); i++) {
				starts.add((Cvterm) ((Object[]) result.get(i))[0]);
			}
			request.getSession().setAttribute("start_cvterms", starts);

			List stops = new ArrayList();
			sql = "FROM Cvterm term JOIN term.cvtermRelationshipsForSubjectOid.cvtermByObjectOid o WHERE o.name='end of recording' ORDER BY term.namespace, term.name";
			q = session.createQuery(sql);
			result = q.list();
			for (int i = 0; i < result.size(); i++) {
				stops.add(((Object[]) result.get(i))[0]);
			}
			request.getSession().setAttribute("stop_cvterms", stops);

			List birthdayDists = new ArrayList();
			sql = "FROM Cvterm term JOIN term.cvtermRelationshipsForSubjectOid.cvtermByObjectOid o WHERE o.name='probability distribution' ORDER BY term.namespace, term.name";
			q = session.createQuery(sql);
			result = q.list();
			for (int i = 0; i < result.size(); i++) {
				birthdayDists.add(((Object[]) result.get(i))[0]);
			}
			request.getSession().setAttribute("bddist_cvterms", birthdayDists);

			// session.flush();
			// tx.commit();

			return new ModelAndView("home", "username", "");
		} catch (HibernateException he) {
			log().error("failed to log in.", he);
			throw he;
		}

		/*
		 * finally{ if(!tx.wasCommitted()){ tx.rollback(); } }
		 */
	}
}
