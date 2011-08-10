package org.nescent.plhdb.spring;

import java.math.BigDecimal;
import java.security.AccessControlException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.nescent.plhdb.aa.PermissionManager;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.nescent.plhdb.hibernate.dao.Studyinfo;
import org.nescent.plhdb.util.PrepareModel;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class AddStudyController implements Controller {
	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(AddStudyController.class);
		}
		return log;
	}

	@SuppressWarnings("unchecked")
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) {

		String scientificName = nullIfEmpty(request
				.getParameter("scientificName"));
		String commonName = nullIfEmpty(request.getParameter("commonName"));
		String studyId = nullIfEmpty(request.getParameter("studyId"));
		String owners = nullIfEmpty(request.getParameter("owners"));
		String siteName = nullIfEmpty(request.getParameter("siteName"));
		String latitude = nullIfEmpty(request.getParameter("latitude"));
		String longitude = nullIfEmpty(request.getParameter("longitude"));

		if (scientificName == null) {
			throw new IllegalArgumentException("No scientific name specified.");
		}
		if (studyId == null) {
			throw new IllegalArgumentException("No study id specified.");
		}
		if (siteName == null) {
			throw new IllegalArgumentException("No siteName specified.");
		}

		Studyinfo studyInfo = new Studyinfo();
		PermissionManager manager = (PermissionManager) request.getSession()
				.getAttribute("permission_manager");
		if (manager == null) {
			throw new AccessControlException("You have not logged in.");
		}

		Session session = HibernateSessionFactory.getSession();
		try {
			studyInfo.setStudyId(studyId);
			studyInfo.setCommonname(commonName);
			studyInfo.setSciname(scientificName);
			studyInfo.setOwners(owners);
                        if (latitude != null) {
                            studyInfo.setLatitude(new BigDecimal(latitude));
                        }
			if (longitude != null) {
                            studyInfo.setLongitude(new BigDecimal(longitude));
                        }
			studyInfo.setSiteid(siteName);
			session.save(studyInfo);
			Map<String, Object> models = PrepareModel.prepare(studyInfo
					.getStudyId(), null, manager);
			models.put("tab", "study");
			return new ModelAndView("editData", models);
		} catch (NumberFormatException nfe) {
			throw new IllegalArgumentException(
                            "invalid latitude or longitude: "+latitude +", "+longitude,
                            nfe);
		} catch (HibernateException he) {
			log().error("failed to add study.", he);
			throw he;
		}
	}

	private String nullIfEmpty(String s) {
		return (s != null && s.trim().equals("")) ? null : s;
	}

}
