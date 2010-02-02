package org.nescent.plhdb.spring;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Map;
import java.security.AccessControlException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.nescent.plhdb.aa.PermissionManager;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.nescent.plhdb.hibernate.dao.Biography;
import org.nescent.plhdb.util.PrepareModel;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class AddIndividualController implements Controller {
	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(AddIndividualController.class);
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
		String individualid = nullIfEmpty(request.getParameter("individualid"));
		String individualname = nullIfEmpty(request
				.getParameter("individualname"));
		String sex = nullIfEmpty(request.getParameter("sex"));
		String birthgroup = nullIfEmpty(request.getParameter("birthgroup"));
		String birthgroupcertainty = nullIfEmpty(request
				.getParameter("birthgroupcertainty"));
		String isfirstborn = nullIfEmpty(request.getParameter("isfirstborn"));
		String studyid = nullIfEmpty(request.getParameter("studyid"));
		String momid = nullIfEmpty(request.getParameter("momid"));
		String birthdate = nullIfEmpty(request.getParameter("birthdate"));
		String bdmin = nullIfEmpty(request.getParameter("bdmin"));
		String bdmax = nullIfEmpty(request.getParameter("bdmax"));
		String bddist = nullIfEmpty(request.getParameter("bddist"));

		String entrydate = nullIfEmpty(request.getParameter("entrydate"));
		String entrytype = nullIfEmpty(request.getParameter("entrytype"));
		String departdate = nullIfEmpty(request.getParameter("departdate"));
		String departdateerror = nullIfEmpty(request
				.getParameter("departdateerror"));
		String departtype = nullIfEmpty(request.getParameter("departtype"));

		if (individualid == null || individualid.trim().equals("")) {
			throw new IllegalArgumentException("No individual id specified.");
		}

		if (entrydate == null || entrydate.trim().equals("")) {
			throw new IllegalArgumentException("No entry date specified.");
		}

		if (entrytype == null || entrytype.trim().equals("")) {
			throw new IllegalArgumentException("No  entry type specified.");
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

		/*
		 * if (bdmin == null) { throw new IllegalArgumentException(
		 * "No birth date derror specified."); }
		 */
		if (departdate == null) {
			throw new IllegalArgumentException("No depart date specified.");
		}
		if (departtype == null) {
			throw new IllegalArgumentException("No depart type specified.");
		}
		/*
		if (departdateerror == null) {
			throw new IllegalArgumentException(
					"No depart date error specified.");
		}
*/
		Session session = HibernateSessionFactory.getSession();
		
		SimpleDateFormat sfm = new SimpleDateFormat("dd-MMM-yyyy");

		try {
			Biography b = new Biography();

			b.setAnimname(individualname);
			b.setStudyid(studyid);
			b.setAnimid(individualid);
			b.setBirthgroup(birthgroup);
			if (birthgroupcertainty != null
					&& !birthgroupcertainty.trim().equals(""))
				b.setBgqual(Character.valueOf(birthgroupcertainty.charAt(0)));
			if (isfirstborn != null && !isfirstborn.trim().equals(""))
				b.setFirstborn(Character.valueOf(isfirstborn.charAt(0)));
			if (sex != null && !sex.trim().equals(""))
				b.setSex(Character.valueOf(sex.charAt(0)));

			if (momid != null && !momid.trim().equals("")) {
				b.setMomid(momid);
			}

			if (birthdate != null) {
				b.setBirthdate(sfm.parse(birthdate));
			}
			if (bdmin != null && !bdmin.trim().equals("")) {
				b.setBdmin(sfm.parse(bdmin));
			}
			if (bdmax != null && !bdmax.trim().equals("")) {
				b.setBdmax(sfm.parse(bdmax));
			}

			if (bddist != null && !bddist.trim().equals("")) {
				b.setBddist(bddist);
			}

			b.setBirthgroup(birthgroup);

			b.setEntrydate(sfm.parse(entrydate));
			b.setEntrytype(entrytype);

			if (departdate != null && !departdate.trim().equals("")) {
				b.setDepartdate(sfm.parse(departdate));
				if (departdateerror != null
						&& !departdateerror.trim().equals(""))
					b.setDepartdateerror(Double.parseDouble(departdateerror));
				b.setDeparttype(departtype);
			}

			session.save(b);

			Map<String, Object> models = PrepareModel.prepare(studyid, String
					.valueOf(b.getAnimOid()), manager);
			return new ModelAndView("editData", models);
		} catch (HibernateException he) {
			log().error("failed to add indivdual.", he);
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
