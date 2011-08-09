package org.nescent.plhdb.spring;

import java.text.ParseException;
import java.text.SimpleDateFormat;
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

public class SaveBiographyController implements Controller {

	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(SaveBiographyController.class);
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
		String individual_id = nullIfEmpty(request
				.getParameter("individual_id"));
		String individualid = nullIfEmpty(request.getParameter("individualid1"));
		String individualname = nullIfEmpty(request
				.getParameter("individualname1"));
		String sex = nullIfEmpty(request.getParameter("sex1"));
		String birthgroup = nullIfEmpty(request.getParameter("birthgroup1"));
		String birthgroupcertainty = nullIfEmpty(request
				.getParameter("birthgroupcertainty1"));
		String isfirstborn = nullIfEmpty(request.getParameter("isfirstborn1"));
		String studyid = nullIfEmpty(request.getParameter("studyid1"));
		String momid = nullIfEmpty(request.getParameter("momid1"));
		String birthdate = nullIfEmpty(request.getParameter("birthdate1"));
		String bdmin = nullIfEmpty(request.getParameter("bdmin1"));
		String bdmax = nullIfEmpty(request.getParameter("bdmax1"));
		String bddist = nullIfEmpty(request.getParameter("bddist1"));

		String entrydate = nullIfEmpty(request.getParameter("entrydate1"));
		String entrytype = nullIfEmpty(request.getParameter("entrytype1"));
		String departdate = nullIfEmpty(request.getParameter("departdate1"));
		String departdateerror = nullIfEmpty(request
				.getParameter("departdateerror1"));
		String departtype = nullIfEmpty(request.getParameter("departtype1"));

		if (individual_id == null) {
			throw new IllegalArgumentException("No individual oid specified.");
		}

		if (individualid == null) {
			throw new IllegalArgumentException("No individual id specified.");
		}

		if (entrydate == null) {
			throw new IllegalArgumentException("No entry date specified.");
		}

		if (entrytype == null) {
			throw new IllegalArgumentException("No entry type specified.");
		}

		if (sex == null) {
			throw new IllegalArgumentException("No sex specified.");
		}
		if (isfirstborn == null) {
			throw new IllegalArgumentException("No 'is first born' specified.");
		}
		if (studyid == null) {
			throw new IllegalArgumentException("No studyid specified.");
		}
		if (birthdate == null) {
			throw new IllegalArgumentException("No birth date specified.");
		}

		if (departdate == null) {
			throw new IllegalArgumentException("No depart date specified.");
		}
		if (departtype == null) {
			throw new IllegalArgumentException("No depart type specified.");
		}

		/*
		 * if (departdateerror == null) { throw new IllegalArgumentException(
		 * "No depart date error specified."); }
		 */
		Session session = HibernateSessionFactory.getSession();
		SimpleDateFormat sfm = new SimpleDateFormat("dd-MMM-yyyy");
		try {

			Biography biography = (Biography) session.get(
					"org.nescent.plhdb.hibernate.dao.Biography", Integer
							.parseInt(individual_id));

			if (biography == null) {
				throw new IllegalArgumentException(
						"failed to retrieve the biography with id: "
								+ individual_id);
			}

			biography.setAnimname(individualname);
			biography.setAnimid(individualid);
			biography.setStudyid(studyid);
			biography.setBirthgroup(birthgroup);

			if (birthgroupcertainty != null
					&& !birthgroupcertainty.trim().equals("")) {
				biography.setBgqual(Character.valueOf(birthgroupcertainty
						.charAt(0)));
			} else {
				biography.setBgqual(null);
			}
			if (isfirstborn != null && !isfirstborn.trim().equals(""))
				biography
						.setFirstborn(Character.valueOf(isfirstborn.charAt(0)));
			if (sex != null)
				biography.setSex(Character.valueOf(sex.charAt(0)));

			biography.setMomid(momid);

			if (bdmin != null) {
				biography.setBdmin(sfm.parse(bdmin));
			}
			if (bdmax != null) {
				biography.setBdmax(sfm.parse(bdmax));
			}

			if (bddist != null) {
				biography.setBddist(bddist);
			}

			if (birthdate != null)
				biography.setBirthdate(sfm.parse(birthdate));
			else
				biography.setBirthdate(null);

			biography.setEntrydate(sfm.parse(entrydate));
			biography.setEntrytype(entrytype);
			if (departdate != null)
				biography.setDepartdate(sfm.parse(departdate));
			else
				biography.setDepartdate(null);

			biography.setDeparttype(departtype);

			if (departdateerror != null)
				biography.setDepartdateerror(Double
						.parseDouble(departdateerror));
			else
				biography.setDepartdateerror(null);

			session.update(biography);
			session.flush();
			Map<String, Object> models = PrepareModel.prepare(studyid,
					individual_id, manager);

			models.put("tab", "biography");
			return new ModelAndView("editData", models);
		} catch (HibernateException he) {
			log().error("failed to update the biography.", he);
			throw he;
		} catch (ParseException he) {
			log().error("failed to parse the date.", he);
			throw new IllegalArgumentException("failed to parse the date.", he);
		} 
	}

	private String nullIfEmpty(String s) {
		return (s != null && s.trim().equals("")) ? null : s;
	}

}
