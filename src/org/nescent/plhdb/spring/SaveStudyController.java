package org.nescent.plhdb.spring;

import java.math.BigDecimal;
import java.security.AccessControlException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.nescent.plhdb.aa.PermissionManager;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.nescent.plhdb.hibernate.dao.Studyinfo;
import org.nescent.plhdb.util.PrepareModel;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class SaveStudyController implements Controller {
	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(SaveStudyController.class);
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
		String scientificName = nullIfEmpty(request
				.getParameter("scientificName"));
		String commonName = nullIfEmpty(request.getParameter("commonName"));

		String studyId = nullIfEmpty(request.getParameter("studyid"));
		String owners = nullIfEmpty(request.getParameter("owners"));
		String siteName = nullIfEmpty(request.getParameter("siteName"));
		String latitude = nullIfEmpty(request.getParameter("latitude"));
		String longitude = nullIfEmpty(request.getParameter("longitude"));

		Double d_lat = null;
		Double d_long = null;

		Session session = HibernateSessionFactory.getSession();
		Transaction tx = session.beginTransaction();

		if (studyId == null || studyId.trim().equals("")) {
			throw new IllegalArgumentException("No study id specified.");
		}

		if (latitude != null) {
			try {
				d_lat = Double.valueOf(latitude);
			} catch (NumberFormatException nfe) {
				throw new IllegalArgumentException("invalid latitude: "
						+ latitude, nfe);
			}
		}
		if (longitude != null) {
			try {
				d_long = Double.valueOf(longitude);
			} catch (NumberFormatException nfe) {
				throw new IllegalArgumentException("invalid longitude: "
						+ longitude, nfe);
			}
		}

		BigDecimal big_lat = d_lat == null ? null : BigDecimal.valueOf(d_lat);
		BigDecimal big_long = d_long == null ? null : BigDecimal
				.valueOf(d_long);
		;

		if (scientificName == null || scientificName.trim().equals("")) {
			throw new IllegalArgumentException("No scientific name specified.");
		}

		if (siteName == null || siteName.trim().equals("")) {
			throw new IllegalArgumentException("No siteName specified.");
		}

		try {
			saveStudyHibernate(session, studyId, owners, siteName, big_lat,
					big_long, commonName, scientificName);
			session.flush();
			tx.commit();

			Map<String, Object> models = PrepareModel.prepare(studyId, null,
					manager);
			models.put("tab", "study");
			return new ModelAndView("editData", models);
		} catch (HibernateException he) {
			log().error("failed to save study.", he);
			throw he;
		} finally {
			if (!tx.wasCommitted())
				tx.rollback();
		}
	}

	public void saveStudyHibernate(Session session, String study_id,
			String owners, String siteName, BigDecimal latitude,
			BigDecimal longitude, String commonName, String scientificName) {
		String sql = "FROM Studyinfo WHERE studyId= :studyid";
		Query q = session.createQuery(sql);
		q.setString("studyid", study_id);
		List studies = q.list();
		Studyinfo study = null;
		if (studies.size() == 0) {
			log().error("failed to retrieve the study with id: " + study_id);
			throw new IllegalArgumentException(
					"failed to retrieve the study with id: " + study_id);
		}

		study = (Studyinfo) studies.get(0);
		study.setSiteid(siteName);
		study.setCommonname(commonName);
		study.setSciname(scientificName);
		study.setLatitude(latitude);
		study.setLongitude(longitude);
		study.setOwners(owners);

		session.update(study);

	}

	private String nullIfEmpty(String s) {
		return (s != null && s.trim().equals("")) ? null : s;
	}

}
