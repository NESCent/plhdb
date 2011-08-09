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
import org.nescent.plhdb.hibernate.dao.Biography;
import org.nescent.plhdb.util.PrepareModel;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class DeleteBiographyController implements Controller {
	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(DeleteBiographyController.class);
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
		String individual_id = nullIfEmpty(request.getParameter("individual"));

		if (individual_id == null || individual_id.trim().equals("")) {
			throw new IllegalArgumentException("No individual oid specified.");
		}

		Session session = HibernateSessionFactory.getSession();
		try {

			Biography biography = (Biography) session.get(
					"org.nescent.plhdb.hibernate.dao.Biography", Integer
							.parseInt(individual_id));

			if (biography == null) {
				throw new IllegalArgumentException(
						"failed to retrieve the biography with id: "
								+ individual_id);
			}

			session.delete(biography);
			session.flush();
			Map<String, Object> models = PrepareModel.prepare(biography
					.getStudyid(), null, manager);

			models.put("tab", "study");
			return new ModelAndView("editData", models);
		} catch (HibernateException he) {
			log().error("failed to delete the biography with id: " 
                                    + individual_id,
                                    he);
			throw he;
		} 
	}

	private String nullIfEmpty(String s) {
		return (s != null && s.trim().equals("")) ? null : s;
	}

}
