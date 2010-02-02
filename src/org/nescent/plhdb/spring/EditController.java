package org.nescent.plhdb.spring;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.nescent.plhdb.aa.PermissionManager;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.nescent.plhdb.util.PrepareModel;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class EditController implements Controller {

	private static Logger log;

	@SuppressWarnings("unused")
	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(EditController.class);
		}
		return log;
	}

	@SuppressWarnings("unchecked")
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) {
		String study_id = nullIfEmpty(request.getParameter("studyid"));
		String individual_id = nullIfEmpty(request.getParameter("individual"));

		PermissionManager manager = (PermissionManager) request.getSession()
				.getAttribute("permission_manager");
		if (manager == null) {
			throw new java.security.AccessControlException(
					"You have not logged in.");
		}
		Map<String, Object> models = PrepareModel.prepare(study_id,
				individual_id, manager);
		Session session = HibernateSessionFactory.getSession();

		return new ModelAndView("editData", models);
	}

	private String nullIfEmpty(String s) {
		return (s != null && s.trim().equals("")) ? null : s;
	}
}
