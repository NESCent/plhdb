package org.nescent.plhdb.spring;

import java.security.AccessControlException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.nescent.plhdb.aa.PermissionManager;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.nescent.plhdb.hibernate.dao.Femalefertilityinterval;
import org.nescent.plhdb.util.PrepareModel;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class DeleteFertilityController implements Controller {

	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(DeleteFertilityController.class);
		}
		return log;
	}

	@SuppressWarnings("unchecked")
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) {
		PermissionManager manager = (PermissionManager) request.getSession()
				.getAttribute("permission_manager");
		if (manager == null) {
			throw new AccessControlException("You have not logged in.");
		}
		String id = nullIfEmpty(request.getParameter("fertility"));
		String animOid = nullIfEmpty(request.getParameter("animOid"));
		if (id == null) {
			throw new IllegalArgumentException("No id  specified.");
		}
		if (animOid == null) {
			throw new IllegalArgumentException("No animal oid  specified.");
		}

		Session session = HibernateSessionFactory.getSession();
		try {

			Femalefertilityinterval period = (Femalefertilityinterval) session
					.get(
							"org.nescent.plhdb.hibernate.dao.Femalefertilityinterval",
							Integer.parseInt(id));
			if (period == null) {
				log().error(
						"failed to retrieve the femalefertilityinterval record with id:"
								+ id);
				throw new IllegalArgumentException(
						"failed to retrieve the femalefertilityinterval record with id:"
								+ id);
			}
			session.delete(period);
			session.flush();

			Map<String, Object> models = PrepareModel.prepare(null, animOid,
					manager);
			models.put("tab", "fertility");
			return new ModelAndView("editData", models);
		} catch (HibernateException he) {
			log().error("failed to delete the fertility with id: " + id, he);
			throw he;
		} 
	}

	private String nullIfEmpty(String s) {
		return (s != null && s.trim().equals("")) ? null : s;
	}
}
