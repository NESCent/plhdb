package org.nescent.plhdb.spring;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.nescent.plhdb.aa.PermissionManager;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.nescent.plhdb.hibernate.dao.Studyinfo;
import org.nescent.plhdb.util.PrepareModel;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class DeleteStudyController implements Controller {
	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(DeleteStudyController.class);
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
		String studyId = nullIfEmpty(request.getParameter("studyid"));

		Session session = HibernateSessionFactory.getSession();
		Transaction tx = session.beginTransaction();

		if (studyId == null || studyId.trim().equals("")) {
			throw new IllegalArgumentException("No studyid specified.");
		}
		
		try {
			Studyinfo studyInfo = (Studyinfo) session.get(Studyinfo.class, studyId);

			if (studyInfo == null) {
				log().error(
						"failed to retrieve the studyinfo with id: " + studyId);
				throw new IllegalArgumentException(
						"failed to retrieve the studyinfo with id: " + studyId);
			}

			session.delete(studyInfo);
			tx.commit();

			Map<String, Object> models = PrepareModel.prepare(null, null,
					manager);
			models.put("tab", "study");
			return new ModelAndView("editData", models);

		} catch (HibernateException he) {
			log().error("failed to delete the study with id: " + studyId, he);
			throw he;
		} finally {
			if (!tx.wasCommitted())
				tx.rollback();
		}
	}

	private String nullIfEmpty(String s) {
		return (s != null && s.trim().equals("")) ? null : s;
	}
	
	public static void main(String [] agrs){
		String studyId = "1";

		Session session = HibernateSessionFactory.getSession();
		Transaction tx = session.beginTransaction();

		try {
			Studyinfo studyInfo = (Studyinfo) session.get(Studyinfo.class, studyId);

			if (studyInfo == null) {
				log().error(
						"failed to retrieve the studyinfo with id: " + studyId);
				throw new IllegalArgumentException(
						"failed to retrieve the studyinfo with id: " + studyId);
			}

			session.delete(studyInfo);
			tx.commit();
			
		} catch (HibernateException he) {
			log().error("failed to delete the study with id: " + studyId, he);
			throw he;
		} finally {
			if (!tx.wasCommitted())
				tx.rollback();
		}
	}

}
