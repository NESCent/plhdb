package org.nescent.plhdb.spring;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.nescent.plhdb.aa.PermissionManager;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.nescent.plhdb.hibernate.dao.Biography;
import org.nescent.plhdb.util.PrepareModel;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class RemoveBiographyController implements Controller {

	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(RemoveBiographyController.class);
		}
		return log;
	}

	@SuppressWarnings("unchecked")
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) {
		PermissionManager manager = (PermissionManager) request.getSession()
				.getAttribute("permission_manager");
		if (manager == null) {
			throw new java.security.AccessControlException(
					"You have not logged in.");
		}
		String animoid = nullIfEmpty(request.getParameter("animoid"));
		if (animoid == null) {
			throw new IllegalArgumentException("No individual oid specified.");
		}

		Session session = HibernateSessionFactory.getSession();
		try {

			Biography biography = (Biography) session.get(
                            "org.nescent.plhdb.hibernate.dao.Biography", 
                            Integer.parseInt(animoid));

			if (biography == null) {
				throw new IllegalArgumentException(
				"failed to retrieve the biography with id: " + animoid);
			}

			String animid = biography.getAnimid();
			String studyid = biography.getStudyid();
			String sql = "FROM Biography where studyid= :studyid AND momid= :momid";

			Query q = session.createQuery(sql);
			q.setString("studyid", studyid);
			q.setString("momid", animid);
			List list = q.list();

			session.delete(biography);
			session.flush();

                        // for the children of the deleted individual, ensure that the 
                        // momID hasn't disappeared (not every momID is also a biography)
			for (int i = 0; i < list.size(); i++) {
				Biography b = (Biography) list.get(i);
				session.refresh(b);
				b.setMomid(animid);
				session.update(b);
			}
			session.flush();

			Map<String, Object> models = PrepareModel.prepare(biography
					.getStudyid(), null, manager);

			models.put("tab", "study");
			return new ModelAndView("editData", models);
		} catch (HibernateException he) {
			log().error("failed to remove the biography with id: " + animoid,
					he);
			throw he;
		} 
	}

	private String nullIfEmpty(String s) {
		return (s != null && s.trim().equals("")) ? null : s;
	}

}
